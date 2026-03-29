#!/bin/bash
# CI test script — runs inside the Termux Docker container.
# Usage: bash test.sh <dotfiles_dir>
set -euo pipefail

DOTFILES_DIR="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
TERMUX_DIR="$DOTFILES_DIR/termux"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }

assert_cmd()  { command -v "$1" &>/dev/null && pass "command: $1" || fail "command not found: $1"; }
assert_link() { [ -L "$1" ] && pass "symlink: $1" || fail "symlink missing: $1"; }
assert_link_target() {
  local link="$1" expected="$2"
  local actual
  actual="$(readlink "$link")"
  [ "$actual" = "$expected" ] && pass "symlink target: $link" || fail "symlink target wrong: $link -> $actual (expected $expected)"
}
assert_no_link() { [ ! -L "$1" ] && pass "no symlink: $1" || fail "symlink still exists: $1"; }

# ---------------------------------------------------------------------------
# Phase 1: Install
# ---------------------------------------------------------------------------
echo "=== Phase 1: install ==="
export DOTFILES_REPO_URL="file://$DOTFILES_DIR"
(cd /tmp && cat "$TERMUX_DIR/install.sh" | bash)

# Update variables to point to the cloned repository
export DOTFILES_DIR="$HOME/.dotfiles"
TERMUX_DIR="$DOTFILES_DIR/termux"

# ---------------------------------------------------------------------------
# Phase 2: Verify installation
# ---------------------------------------------------------------------------
echo ""
echo "=== Phase 2: verify ==="

# Add local bin to path for verification
export PATH="$HOME/.local/bin:$PATH"

# pkg packages
assert_cmd make
assert_cmd nvim
assert_cmd rg
assert_cmd fd
assert_cmd bat
assert_cmd fastfetch
assert_cmd yazi
assert_cmd dust
assert_cmd lazygit
assert_cmd eza
assert_cmd fzf
assert_cmd zoxide
assert_cmd atuin
assert_cmd stylua
assert_cmd taplo
assert_cmd uv
assert_cmd ruff
assert_cmd shfmt
assert_cmd lua-language-server
assert_cmd node
assert_cmd python
assert_cmd cargo

# uv tool packages
assert_cmd debugpy

# npm packages
assert_cmd vtsls
assert_cmd prettier
assert_cmd vscode-json-language-server
assert_cmd docker-compose-langserver
assert_cmd docker-langserver
assert_cmd yaml-language-server
assert_cmd markdownlint

# symlinks
assert_link "$HOME/.zshenv"
assert_link_target "$HOME/.zshenv" "$DOTFILES_DIR/termux/configs/zshenv"

assert_link "$HOME/.config/zsh/.zshrc"
assert_link_target "$HOME/.config/zsh/.zshrc" "$DOTFILES_DIR/termux/configs/zshrc"

assert_link "$HOME/.config/zsh/.p10k.zsh"
assert_link_target "$HOME/.config/zsh/.p10k.zsh" "$DOTFILES_DIR/.p10k.zsh"

assert_link "$HOME/.config/nvim"
assert_link_target "$HOME/.config/nvim" "$DOTFILES_DIR/config/nvim"

assert_link "$HOME/.gitconfig"
assert_link_target "$HOME/.gitconfig" "$DOTFILES_DIR/termux/configs/gitconfig"

assert_link "$HOME/.config/atuin/config.toml"
assert_link_target "$HOME/.config/atuin/config.toml" "$DOTFILES_DIR/termux/configs/atuin/config.toml"

assert_link "$HOME/.config/npm/npmrc"
assert_link_target "$HOME/.config/npm/npmrc" "$DOTFILES_DIR/termux/configs/npmrc"

# git config
GIT_NAME="$(git config --global user.name 2>/dev/null || true)"
[ "$GIT_NAME" = "pedropalb" ] && pass "git user.name" || fail "git user.name wrong: '$GIT_NAME'"

GIT_BRANCH="$(git config --global init.defaultBranch 2>/dev/null || true)"
[ "$GIT_BRANCH" = "main" ] && pass "git init.defaultBranch" || fail "git init.defaultBranch wrong: '$GIT_BRANCH'"

# oh-my-zsh
[ -d "$HOME/.oh-my-zsh" ] && pass "oh-my-zsh installed" || fail "oh-my-zsh missing"
[ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ] && pass "powerlevel10k installed" || fail "powerlevel10k missing"

# ---------------------------------------------------------------------------
# Phase 3: Idempotency — run install again, must succeed with no new actions
# ---------------------------------------------------------------------------
echo ""
echo "=== Phase 3: idempotency ==="
LOG_FILE="$HOME/.local/share/termux-dotfiles/install.log"
LOG_BEFORE="$(wc -l < "$LOG_FILE")"
bash "$TERMUX_DIR/install.sh"
LOG_AFTER="$(wc -l < "$LOG_FILE")"

NEW_LINES=$(( LOG_AFTER - LOG_BEFORE ))
# Only the header comment line should be new (one line added per run)
if [ "$NEW_LINES" -le 1 ]; then
  pass "idempotency: no new actions logged (${NEW_LINES} new lines)"
else
  fail "idempotency: ${NEW_LINES} new actions logged — install is not idempotent\n$(tail -n "$NEW_LINES" "$LOG_FILE")"
fi

# ---------------------------------------------------------------------------
# Phase 4: Uninstall
# ---------------------------------------------------------------------------
echo ""
echo "=== Phase 4: uninstall ==="
echo "y" | bash "$TERMUX_DIR/uninstall.sh"

# ---------------------------------------------------------------------------
# Phase 5: Verify uninstall
# ---------------------------------------------------------------------------
echo ""
echo "=== Phase 5: verify uninstall ==="

assert_no_link "$HOME/.zshenv"
assert_no_link "$HOME/.config/zsh/.zshrc"
assert_no_link "$HOME/.config/zsh/.p10k.zsh"
assert_no_link "$HOME/.config/nvim"
assert_no_link "$HOME/.gitconfig"
assert_no_link "$HOME/.config/atuin/config.toml"
assert_no_link "$HOME/.config/npm/npmrc"

[ ! -d "$HOME/.oh-my-zsh" ] && pass "oh-my-zsh removed" || fail "oh-my-zsh still present"
[ ! -f "$HOME/.local/share/termux-dotfiles/install.log" ] && pass "install.log removed" || fail "install.log still present"

echo ""
echo -e "${GREEN}All tests passed.${NC}"
