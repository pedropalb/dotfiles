#!/bin/bash
set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Globals
INSTALLER_SCRIPT=""
cleanup() {
    rm -f "${INSTALLER_SCRIPT:-}"
}
trap cleanup EXIT

log() { echo -e "${BLUE}[INFO]${NC} $1" >&2; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1" >&2; }

# 1. Check Dependencies
check_dependencies() {
    local missing_deps=()
    for cmd in git curl sudo xz mktemp; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if ! command -v sha256sum &> /dev/null && ! command -v shasum &> /dev/null; then
        missing_deps+=("sha256sum or shasum")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        error "Please install them using your system package manager."
        exit 1
    fi
}

# 2. Detect OS and select Flake configuration
detect_flake_config() {
    local user="${USER}"
    local os_id=""
    local os_like=""
    
    if [ -f /etc/os-release ]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        os_id="${ID:-}"
        os_like="${ID_LIKE:-}"
    fi

    local flake_config=""
    # Check for Arch or Arch-derivatives
    if [[ "$os_id" == "arch" || "$os_like" == *"arch"* ]]; then
        log "Detected Arch Linux."
        flake_config="${user}-arch"
    else
        log "Detected Generic Linux (Ubuntu/Debian/Fedora/etc)."
        flake_config="${user}"
    fi
    
    echo "$flake_config"
}

# 3. Install Nix
install_nix() {
    log "Checking for Nix installation..."
    if ! command -v nix &> /dev/null; then
        log "Nix not found. Installing via Determinate Systems installer..."

        NIX_INSTALLER_OPTS="install"
        if [ -n "${CI:-}" ]; then
            NIX_INSTALLER_OPTS="install --no-confirm"
        fi

        # Secure download and verification
        local installer_version="v3.15.2"
        local installer_checksum="a03f0e7209eb171d4826754f3559db453a9ad2645e8de98bb6c1ac6e0ce3398f"
        local installer_url="https://install.determinate.systems/nix/tag/${installer_version}"

        log "Downloading Nix installer from ${installer_url}..."
        INSTALLER_SCRIPT=$(mktemp)

        if ! curl --proto '=https' --tlsv1.2 -sSf -L "${installer_url}" -o "${INSTALLER_SCRIPT}"; then
            error "Failed to download Nix installer."
            exit 1
        fi

        log "Verifying installer checksum..."
        local verified=false
        local actual_checksum

        if command -v sha256sum &> /dev/null; then
            if echo "${installer_checksum}  ${INSTALLER_SCRIPT}" | sha256sum --check --status; then
                verified=true
            else
                # shellcheck disable=SC2034
                read -r actual_checksum _ <<< "$(sha256sum "${INSTALLER_SCRIPT}")"
            fi
        elif command -v shasum &> /dev/null; then
            if echo "${installer_checksum}  ${INSTALLER_SCRIPT}" | shasum -a 256 -c -s; then
                verified=true
            else
                # shellcheck disable=SC2034
                read -r actual_checksum _ <<< "$(shasum -a 256 "${INSTALLER_SCRIPT}")"
            fi
        else
            error "No SHA256 checksum utility found."
            rm -f "${INSTALLER_SCRIPT}"
            exit 1
        fi

        if [ "$verified" = false ]; then
            error "Installer checksum verification failed!"
            error "Expected: ${installer_checksum}"
            error "Actual:   ${actual_checksum}"
            exit 1
        fi

        log "Running Nix installer..."
        chmod +x "${INSTALLER_SCRIPT}"
        sh "${INSTALLER_SCRIPT}" $NIX_INSTALLER_OPTS

        if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
            . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
        fi

        if [ -n "${CI:-}" ]; then
            log "Starting nix-daemon in background for CI..."
            sudo /nix/var/nix/profiles/default/bin/nix-daemon > /tmp/nix-daemon.log 2>&1 &
            sleep 5
        fi
    else
        log "Nix is already installed."
        if ! nix flake --help &>/dev/null; then
            warn "Flakes do not appear to be enabled. Please enable 'flakes' and 'nix-command' in /etc/nix/nix.conf"
            exit 1
        fi
    fi
}

# Main Logic
main() {
    check_dependencies

    local flake_config
    flake_config=$(detect_flake_config)
    log "Target Flake Configuration: $flake_config"

    install_nix

    CONFIG_REPO="${CONFIG_REPO:-https://github.com/pedropalb/dotfiles.git}"
    CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/home-manager}"

    echo "--- Cloning configuration repo ---"
    if [ -d "$CONFIG_DIR" ]; then
        if [ -d "$CONFIG_DIR/.git" ]; then
            log "Config directory exists and is a git repo. Pulling latest changes..."
            git -C "$CONFIG_DIR" pull || warn "Failed to pull latest changes. Continuing..."
        else
            warn "Config directory $CONFIG_DIR exists but is not a git repo. Backing up."
            mv "$CONFIG_DIR" "$CONFIG_DIR.bak-$(date +%F-%T)"
            git clone "$CONFIG_REPO" "$CONFIG_DIR"
        fi
    else
        mkdir -p "$(dirname "$CONFIG_DIR")"
        git clone "$CONFIG_REPO" "$CONFIG_DIR"
    fi

    echo "--- Applying Home Manager configuration ---"
    nix run github:nix-community/home-manager -- switch --flake "${CONFIG_DIR}#${flake_config}"

    success "All done! Close and reopen your terminal."
}

main "$@"
