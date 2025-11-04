#!/bin/bash
#
# A Flake-based bootstrap script for a new Ubuntu machine
#

set -e # Exit immediately if a command exits with a non-zero status

# --- 1. USER CONFIGURATION ---
#
# !! IMPORTANT !!
# Set these variables to match your setup.

# Your GitHub repo URL
CONFIG_REPO="https://github.com/pedropalb/dotfiles.git"

# The username on the new machine.
# This MUST match the key you use in your 'flake.nix'
# (e.g., homeConfigurations."johndoe" = ... )
YOUR_USERNAME="pedro"

# --- 2. SCRIPT CONFIG (No need to edit) ---
CONFIG_PATH="$HOME/.config/home-manager"

# --- 3. INSTALL BASE DEPENDENCIES ---
echo "--- Ensuring git and curl are installed ---"
if ! command -v git &> /dev/null || ! command -v curl &> /dev/null; then
  sudo apt-get update
  sudo apt-get install -y git curl
else
  echo "git and curl are already installed."
fi

# --- 4. INSTALL NIX ---
echo "--- Installing Nix Package Manager ---"
if ! command -v nix &> /dev/null; then
  sh <(curl -L https://nixos.org/nix/install) --daemon
  
  # Source the nix profile to make 'nix' available to this script
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "Nix is already installed."
fi

# --- 5. ENABLE NIX FLAKES ---
echo "--- Enabling Nix Flakes ---"
NIX_CONFIG_FILE="/etc/nix/nix.conf"
FLAKE_CONFIG_LINES="experimental-features = nix-command flakes\naccept-flake-config = true"

if ! grep -q "experimental-features.*flakes" "$NIX_CONFIG_FILE"; then
  echo "Adding Flake configuration to $NIX_CONFIG_FILE"
  echo -e "$FLAKE_CONFIG_LINES" | sudo tee -a "$NIX_CONFIG_FILE"
  
  # Restart the daemon to apply changes
  sudo systemctl restart nix-daemon.service
else
  echo "Nix Flakes are already enabled."
fi

# --- 6. CLONE YOUR CONFIG REPO ---
echo "--- Cloning configuration repo ---"
if [ -d "$CONFIG_PATH" ]; then
  echo "Config directory $CONFIG_PATH already exists. Backing up."
  mv "$CONFIG_PATH" "$CONFIG_PATH.bak-$(date +%F-%T)"
fi
git clone "$CONFIG_REPO" "$CONFIG_PATH"
cd "$CONFIG_PATH" # Enter the directory

# --- 7. APPLY THE CONFIGURATION ---
echo "--- Applying Home Manager configuration ---"
# We run 'nix run' to use the 'home-manager' command from the Flake
# registry. This command will then read our local flake.nix,
# build our configuration, and activate it.
nix run github:nix-community/home-manager -- switch --flake .#$YOUR_USERNAME

echo "--- All done! Close and reopen your terminal. ---"

