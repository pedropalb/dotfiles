#!/bin/bash
set -euo pipefail

# Bootstrap for curl | bash
if [ ! -f "$(dirname "$0")/lib.sh" ]; then
  echo "=> Bootstrapping Termux Dotfiles installation..."
  
  if ! command -v git >/dev/null 2>&1; then
    echo "=> Installing git..."
    export TERMUX_PKG_NO_MIRROR_SELECT=1
    export DEBIAN_FRONTEND=noninteractive
    pkg update -y
    pkg install -y -o Dpkg::Options::="--force-confnew" git
  fi

  REPO_URL="${DOTFILES_REPO_URL:-https://github.com/pedropalb/dotfiles.git}"
  DOTFILES_DIR="$HOME/.dotfiles"

  if [ ! -d "$DOTFILES_DIR" ]; then
    echo "=> Cloning repository to $DOTFILES_DIR..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
  else
    echo "=> Repository already exists at $DOTFILES_DIR"
    echo "=> Pulling latest changes..."
    (cd "$DOTFILES_DIR" && git pull || true)
  fi

  echo "=> Handing over to local install script..."
  exec bash "$DOTFILES_DIR/termux/install.sh" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

# Paths
DATA_DIR="$HOME/.local/share/termux-dotfiles"
BACKUP_DIR="$DATA_DIR/backups"
LOG_FILE="$DATA_DIR/install.log"

# ---------------------------------------------------------------------------
# Package lists
# ---------------------------------------------------------------------------

PKG_PACKAGES=(
  git zsh neovim
  build-essential
  ripgrep fd bat fastfetch yazi dust lazygit eza unzip
  fzf zoxide
  nodejs python
  rust clang lldb
  lua-language-server shfmt
  atuin stylua taplo uv ruff
)

# npm global packages: "package_name:check_command"
NPM_PACKAGES=(
  "@vtsls/language-server:vtsls"
  "prettier:prettier"
  "vscode-langservers-extracted:vscode-json-language-server"
  "@microsoft/compose-language-service:docker-compose-langserver"
  "dockerfile-language-server-nodejs:docker-langserver"
  "yaml-language-server:yaml-language-server"
  "markdownlint-cli:markdownlint"
)

# ---------------------------------------------------------------------------
# Phase 1: pkg packages
# ---------------------------------------------------------------------------

install_pkg_packages() {
  log_info "--- Phase 1: pkg packages ---"
  # Configure mirrors to North America (non-interactive)
  local chosen_mirrors="$PREFIX/etc/termux/chosen_mirrors"
  local mirror_group="$PREFIX/etc/termux/mirrors/north_america"
  if [ -d "$mirror_group" ]; then
    log_info "pkg: switching to North America mirror group"
    ln -sf "$mirror_group" "$chosen_mirrors"
  fi
  
  # Prevent 'pkg' from re-checking/overriding our mirror choice
  export TERMUX_PKG_NO_MIRROR_SELECT=1
  export DEBIAN_FRONTEND=noninteractive

  # Using pkg for mirror selection logic, but with non-interactive flags
  pkg update -y
  pkg upgrade -y -o Dpkg::Options::="--force-confnew"

  for p in "${PKG_PACKAGES[@]}"; do
    if is_pkg_installed "$p"; then
      log_info "pkg: $p already installed"
    else
      log_info "pkg: installing $p"
      pkg install -y -o Dpkg::Options::="--force-confnew" "$p"
      log_action "PKG" "$p"
    fi
  done
}

# ---------------------------------------------------------------------------
# Phase 2: npm global packages
# ---------------------------------------------------------------------------

install_npm_packages() {
  log_info "--- Phase 2: npm global packages ---"

  # Ensure prefix directory exists so npm installs to ~/.local
  ensure_dir "$HOME/.local/bin"
  ensure_dir "$HOME/.local/lib"
  ensure_dir "$HOME/.config/npm"

  # Set prefix for this session (npmrc symlink handles subsequent shells)
  export npm_config_prefix="$HOME/.local"

  for entry in "${NPM_PACKAGES[@]}"; do
    local pkg="${entry%%:*}"
    local cmd="${entry##*:}"
    if is_command_available "$cmd"; then
      log_info "npm: $pkg already installed ($cmd found)"
    else
      log_info "npm: installing $pkg"
      npm install -g "$pkg"
      log_action "NPM" "$pkg"
    fi
  done
}

# ---------------------------------------------------------------------------
# Phase 3: uv tool packages
# ---------------------------------------------------------------------------

install_uv_tool_packages() {
  log_info "--- Phase 3: uv tool packages ---"

  if [ -x "$HOME/.local/bin/debugpy" ]; then
    log_info "uv tool: debugpy already installed"
  else
    log_info "uv tool: installing debugpy"
    uv tool install debugpy
    log_action "UV_TOOL" "debugpy"
  fi
}

# ---------------------------------------------------------------------------
# Phase 4: Oh-My-Zsh + plugins + Powerlevel10k
# ---------------------------------------------------------------------------

install_zsh_extras() {
  log_info "--- Phase 4: Oh-My-Zsh + plugins ---"

  # oh-my-zsh
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log_info "oh-my-zsh: already installed"
  else
    log_info "oh-my-zsh: installing"
    # --unattended skips the post-install shell switch; --keep-zshrc avoids overwriting ours
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_action "OMZ" "installed"
  fi

  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  # powerlevel10k theme
  local p10k_dir="$custom/themes/powerlevel10k"
  if [ -d "$p10k_dir" ]; then
    log_info "powerlevel10k: already installed"
  else
    log_info "powerlevel10k: installing"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    log_action "P10K" "installed"
  fi

  # zsh-autosuggestions
  local as_dir="$custom/plugins/zsh-autosuggestions"
  if [ -d "$as_dir" ]; then
    log_info "zsh-autosuggestions: already installed"
  else
    log_info "zsh-autosuggestions: installing"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$as_dir"
    log_action "ZSH_PLUGIN" "zsh-autosuggestions"
  fi

  # zsh-syntax-highlighting
  local sh_dir="$custom/plugins/zsh-syntax-highlighting"
  if [ -d "$sh_dir" ]; then
    log_info "zsh-syntax-highlighting: already installed"
  else
    log_info "zsh-syntax-highlighting: installing"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$sh_dir"
    log_action "ZSH_PLUGIN" "zsh-syntax-highlighting"
  fi

  # zsh-completions
  local comp_dir="$custom/plugins/zsh-completions"
  if [ -d "$comp_dir" ]; then
    log_info "zsh-completions: already installed"
  else
    log_info "zsh-completions: installing"
    git clone https://github.com/zsh-users/zsh-completions "$comp_dir"
    log_action "ZSH_PLUGIN" "zsh-completions"
  fi
}

# ---------------------------------------------------------------------------
# Phase 5: Symlinks
# ---------------------------------------------------------------------------

install_symlinks() {
  log_info "--- Phase 5: symlinks ---"

  # zsh
  make_symlink "$DOTFILES_DIR/termux/configs/zshenv"          "$HOME/.zshenv"
  make_symlink "$DOTFILES_DIR/termux/configs/zshrc"           "$HOME/.config/zsh/.zshrc"
  make_symlink "$DOTFILES_DIR/.p10k.zsh"                      "$HOME/.config/zsh/.p10k.zsh"

  # neovim
  make_symlink "$DOTFILES_DIR/config/nvim"                    "$HOME/.config/nvim"

  # git
  make_symlink "$DOTFILES_DIR/termux/configs/gitconfig"       "$HOME/.gitconfig"

  # atuin
  make_symlink "$DOTFILES_DIR/termux/configs/atuin/config.toml" "$HOME/.config/atuin/config.toml"

  # npm
  make_symlink "$DOTFILES_DIR/termux/configs/npmrc"           "$HOME/.config/npm/npmrc"
}

# ---------------------------------------------------------------------------
# Phase 6: Set zsh as default shell
# ---------------------------------------------------------------------------

set_default_shell() {
  log_info "--- Phase 6: default shell ---"

  local current_shell
  current_shell="$(basename "$SHELL")"
  local termux_shell=""
  if [ -L "$HOME/.termux/shell" ]; then
    termux_shell="$(basename "$(readlink "$HOME/.termux/shell")")"
  fi

  if [ "$current_shell" = "zsh" ] || [ "$termux_shell" = "zsh" ]; then
    log_info "shell: zsh is already the default"
  else
    log_info "shell: changing default from $current_shell to zsh"
    if chsh -s zsh 2>/dev/null; then
      log_action "SHELL" "changed_from:$current_shell"
    else
      log_warn "shell: chsh failed (may not be supported in this environment)"
    fi
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  log_info "=== Termux Dotfiles Install ==="
  log_info "Dotfiles dir: $DOTFILES_DIR"

  ensure_dir "$DATA_DIR"
  ensure_dir "$BACKUP_DIR"
  echo "# Install run: $(date -Iseconds)" >> "$LOG_FILE"

  install_pkg_packages
  install_npm_packages
  install_uv_tool_packages
  install_zsh_extras
  install_symlinks
  set_default_shell

  log_success "=== Install complete ==="
  log_info "Restart your terminal or run: exec zsh"
}

main "$@"

