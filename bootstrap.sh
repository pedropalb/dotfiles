#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

log "Checking for Nix installation..."
if ! command -v nix &> /dev/null; then
    log "Nix not found. Installing via Determinate Systems installer..."
    
    # This installer automatically:
    # - Enables Flakes
    # - Sets up the Nix Daemon
    # - Configures build users
    # - Works on Systemd (Arch/Ubuntu/Fedora) and Launchd (macOS)
    NIX_INSTALLER_OPTS="install"
    if [ -n "$CI" ]; then
        NIX_INSTALLER_OPTS="install --no-confirm"
    fi
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- $NIX_INSTALLER_OPTS
    
    # Source the nix configuration immediately for this script session
    if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
        . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
else
    log "Nix is already installed."
    
    # Verify Flakes are enabled (Determinate installer does this by default, 
    # but vanilla installs might not have it).
    if ! nix flake --help &>/dev/null; then
        warn "Flakes do not appear to be enabled. Please enable 'flakes' and 'nix-command' in /etc/nix/nix.conf"
        exit 1
    fi
fi

# ---------------------------------------------------------------------------------------------------------------
CONFIG_REPO="${CONFIG_REPO:-https://github.com/pedropalb/dotfiles.git}"
USERNAME="${USERNAME:-pedro}"  # This MUST match the key you use in your 'flake.nix'
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/home-manager}"

echo "--- Cloning configuration repo ---"
if [ -d "$CONFIG_DIR" ]; then
  echo "Config directory $CONFIG_DIR already exists. Backing up."
  mv "$CONFIG_DIR" "$CONFIG_DIR.bak-$(date +%F-%T)"
else
  mkdir -p $CONFIG_DIR
fi
git clone "$CONFIG_REPO" "$CONFIG_DIR"

echo "--- Applying Home Manager configuration ---"
# We run 'nix run' to use the 'home-manager' command from the Flake
# registry. This command will then read our local flake.nix,
# build our configuration, and activate it.
nix run github:nix-community/home-manager -- switch --flake "${CONFIG_DIR}#${USERNAME}"

echo "--- All done! Close and reopen your terminal. ---"

