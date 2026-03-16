# Dotfiles

This repository contains personal dotfiles managed with **Nix**, **Nix Flakes**, and **Home Manager**. It provides a reproducible, modular, and declarative configuration for a Linux environment, specifically optimized for `x86_64-linux`.

## Overview

These dotfiles install and configure a full development environment, primarily focusing on CLI tools. As a general rule, GUI applications are not installed via Home Manager in this repository.

Included configurations:
- **Shell**: Zsh with Oh My Zsh and Powerlevel10k theme.
- **Editor**: Neovim (configured via LazyVim).
- **Terminal**: WezTerm (Configuration only; the app itself is not installed by Home Manager).
- **Languages**: Rust (via Fenix), Node.js, and Python (via uv).
- **CLI Tools**: `ripgrep`, `fd`, `fzf`, `atuin`, `bat`, `zoxide`, `fastfetch`, `btop`, and more.

## Getting Started

### Initial Setup
To bootstrap a new system, you can use the provided convenience script:
```bash
./bootstrap.sh
```
This script installs Nix (using the Determinate Systems installer) and applies the initial Home Manager configuration.

### Applying Changes
After modifying the configuration, apply the changes by running:

```bash
# For standard Linux
home-manager switch --flake .#default

# For Arch Linux (includes extra packages)
home-manager switch --flake .#arch
```

If `home-manager` is not yet in your PATH, you can run:
```bash
nix run github:nix-community/home-manager -- switch --flake .#default
```

## Technologies Used

- **[Nix](https://nixos.org/)**: A powerful package manager that makes package management reliable and reproducible.
- **[Nix Flakes](https://nixos.wiki/wiki/Flakes)**: An upcoming Nix feature that provides a standardized way to manage dependencies and versioning.
- **[Home Manager](https://github.com/nix-community/home-manager)**: A Nix-based tool to manage a user environment, including packages and dotfiles.

## Repository Structure

The repository is modularized to make it easy to find and modify specific configurations:

- `flake.nix`: The entry point for the configuration. Defines inputs and system configurations (`default` and `arch`).
- `home.nix`: The main aggregator that imports common modules.
- `modules/`: Contains logical configuration blocks:
    - `core.nix`: Base system packages and Home Manager setup.
    - `shell.nix`: Zsh, prompt, and shell utilities.
    - `languages.nix`: Programming language toolchains.
    - `editors.nix`: Neovim setup.
    - `git.nix`: Git configuration.
    - `terminal.nix`: Terminal emulator configuration (WezTerm).
    - `arch.nix`: Arch Linux specific packages.
- `config/`: Contains raw configuration files symlinked into your home directory.
    - `config/nvim/`: Full Neovim configuration.
    - `config/wezterm/`: WezTerm configuration.

### Customization
- To add **packages**, modify the relevant file in `modules/` (e.g., `modules/core.nix` for general tools).
- To change **shell aliases**, edit `modules/shell.nix`.
- For **Neovim** specific changes, edit the files in `config/nvim/`. These are symlinked as "out-of-store" symlinks, so changes take effect immediately.
