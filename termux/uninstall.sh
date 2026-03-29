#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

DATA_DIR="$HOME/.local/share/termux-dotfiles"
BACKUP_DIR="$DATA_DIR/backups"
LOG_FILE="$DATA_DIR/install.log"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

restore_backup() {
  local orig="$1"
  local backup="$2"
  if [ -e "$backup" ]; then
    log_info "restore: $backup -> $orig"
    ensure_dir "$(dirname "$orig")"
    mv "$backup" "$orig"
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  log_info "=== Termux Dotfiles Uninstall ==="

  if [ ! -f "$LOG_FILE" ]; then
    log_error "No install log found at $LOG_FILE — nothing to uninstall."
    exit 1
  fi

  echo "This will remove all packages and configs installed by the Termux dotfiles setup."
  printf "Continue? [y/N] "
  read -r response
  case "$response" in
    [yY]) ;;
    *) log_info "Aborted."; exit 0 ;;
  esac

  # Process log in reverse (LIFO) to undo most recent actions first
  # Use tac if available, otherwise reverse with awk
  local reverse_cmd
  if command -v tac &>/dev/null; then
    reverse_cmd="tac"
  else
    reverse_cmd="awk 'BEGIN{i=0} {lines[i++]=$0} END{for(j=i-1;j>=0;j--) print lines[j]}'"
  fi

  eval "$reverse_cmd \"$LOG_FILE\"" | grep -v '^#' | while IFS= read -r line; do
    type="${line%%:*}"
    data="${line#*:}"

    case "$type" in
      SYMLINK)
        link="${data%%:*}"
        if [ -L "$link" ]; then
          log_info "remove symlink: $link"
          rm "$link"
        fi
        ;;
      BACKUP)
        orig="${data%%:*}"
        backup="${data##*:}"
        restore_backup "$orig" "$backup"
        ;;
      PKG)
        if is_pkg_installed "$data"; then
          log_info "pkg: uninstalling $data"
          pkg uninstall -y "$data" 2>/dev/null || log_warn "pkg: failed to uninstall $data (skipping)"
        fi
        ;;
      NPM)
        log_info "npm: uninstalling $data"
        npm uninstall -g "$data" 2>/dev/null || log_warn "npm: failed to uninstall $data (skipping)"
        ;;
      UV_TOOL)
        log_info "uv tool: uninstalling $data"
        uv tool uninstall "$data" 2>/dev/null || log_warn "uv tool: failed to uninstall $data (skipping)"
        ;;
      OMZ)
        if [ -d "$HOME/.oh-my-zsh" ]; then
          log_info "removing oh-my-zsh"
          rm -rf "$HOME/.oh-my-zsh"
        fi
        ;;
      P10K)
        local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        if [ -d "$p10k_dir" ]; then
          log_info "removing powerlevel10k"
          rm -rf "$p10k_dir"
        fi
        ;;
      ZSH_PLUGIN)
        local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$data"
        if [ -d "$plugin_dir" ]; then
          log_info "removing zsh plugin: $data"
          rm -rf "$plugin_dir"
        fi
        ;;
      SHELL)
        local prev_shell="${data#changed_from:}"
        log_info "shell: restoring to $prev_shell"
        chsh -s "$prev_shell" || log_warn "shell: failed to restore shell (skipping)"
        ;;
      DIR)
        # Only remove if empty
        rmdir "$data" 2>/dev/null || true
        ;;
      *)
        # Unknown record type — skip
        ;;
    esac
  done

  # Clean up our data directory
  rm -f "$LOG_FILE"
  rmdir "$BACKUP_DIR" 2>/dev/null || true
  rmdir "$DATA_DIR" 2>/dev/null || true

  log_success "=== Uninstall complete ==="
}

main "$@"
