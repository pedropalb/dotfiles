# Gemini CLI Context: Dotfiles

This repository contains personal dotfiles managed with **Nix**, **Nix Flakes**, and **Home Manager**. It targets a Linux environment (specifically `x86_64-linux`).

## Project Overview

- **Architecture:** Managed via Nix Flakes for reproducible environment and configuration.
- **Home Manager:** Used to manage user-level packages, dotfiles (via symlinks), and shell environment.
- **Main Technologies:**
    - **Nix / Flakes:** System and package management.
    - **Home Manager:** User configuration management.
    - **Zsh:** Main shell with Oh My Zsh and Powerlevel10k theme.
    - **Neovim:** Configured with LazyVim.
    - **WezTerm:** Terminal emulator.
    - **Rust:** Development environment managed via Fenix.
    - **Other Tools:** `ripgrep`, `fd`, `fzf`, `atuin`, `bat`, `zoxide`, `uv`, `nodejs`.

## Key Files and Directories

- `flake.nix`: The entry point for the Nix Flake. Defines inputs (nixpkgs, home-manager, fenix) and the `pedro` home configuration.
- `home.nix`: The core Home Manager configuration. Defines installed packages, XDG configuration files, session variables, and shell settings.
- `bootstrap.sh`: A convenience script to install Nix (via Determinate Systems installer) and apply the initial Home Manager configuration.
- `config/`: Contains raw configuration files for applications, symlinked by Home Manager.
    - `config/nvim/`: Full Neovim configuration based on LazyVim.
    - `config/wezterm/wezterm.lua`: WezTerm configuration using Github Dark scheme and MesloLGL Nerd Font.
- `.p10k.zsh`: Configuration for the Powerlevel10k Zsh theme.

## Building and Running

### Initial Setup
To bootstrap a new system, run:
```bash
./bootstrap.sh
```

### Applying Changes
After modifying `home.nix` or `flake.nix`, apply the changes with:
```bash
home-manager switch --flake .#pedro
```
Alternatively, if `home-manager` is not in your path yet:
```bash
nix run github:nix-community/home-manager -- switch --flake .#pedro
```

### Neovim Configuration
Neovim is symlinked as an "out-of-store" symlink in `home.nix`:
```nix
"nvim".source = config.lib.file.mkOutOfStoreSymlink "${repoConfig}/nvim";
```
This allows editing files in `config/nvim/` and having changes reflected immediately in Neovim without a `home-manager switch`.

## Development Conventions

- **Nix-First:** All system packages and environment tools should be added via `home.nix` or `flake.nix`.
- **Symlinking:** Use `mkOutOfStoreSymlink` for configurations that are frequently iterated on (like Neovim or WezTerm) to avoid constant Nix builds.
- **Rust Development:** Rust is managed via the `fenix` input in the flake, providing a stable toolchain with common components.
- **Shell:** Zsh is the primary shell. Custom aliases and environment variables should be defined in `home.nix`.
