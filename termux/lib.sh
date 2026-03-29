#!/bin/bash
# Shared helpers for install.sh and uninstall.sh

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC} $1" >&2; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1" >&2; }

# Append a typed record to the install log
# Usage: log_action TYPE DATA
log_action() {
  echo "${1}:${2}" >> "$LOG_FILE"
}

# Create directory if it doesn't exist, log it
ensure_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    log_action "DIR" "$dir"
  fi
}

# Check if a pkg package is installed
# Usage: is_pkg_installed PACKAGE_NAME
is_pkg_installed() {
  dpkg -s "$1" 2>/dev/null | grep -q "^Status: install ok installed"
}

# Check if a command is available on PATH
# Usage: is_command_available COMMAND
is_command_available() {
  command -v "$1" &>/dev/null
}

# Create a symlink, backing up any existing file/dir first
# Usage: make_symlink TARGET LINK_PATH
make_symlink() {
  local target="$1"
  local link="$2"
  local link_dir
  link_dir="$(dirname "$link")"

  ensure_dir "$link_dir"

  if [ -L "$link" ]; then
    local current_target
    current_target="$(readlink "$link")"
    if [ "$current_target" = "$target" ]; then
      log_info "symlink: already correct: $link"
      return 0
    fi
    log_info "symlink: removing stale link: $link -> $current_target"
    rm "$link"
  elif [ -e "$link" ]; then
    local backup="$BACKUP_DIR/$(echo "$link" | tr '/' '__')"
    log_info "symlink: backing up $link -> $backup"
    mv "$link" "$backup"
    log_action "BACKUP" "${link}:${backup}"
  fi

  ln -s "$target" "$link"
  log_info "symlink: $link -> $target"
  log_action "SYMLINK" "${link}:${target}"
}
