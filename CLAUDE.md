# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal dotfiles managed with Nix Flakes and Home Manager. Declarative, modular configuration for a Linux (x86_64-linux) development environment. GUI apps are not installed here — only CLI tools and configurations.

## Commands

```bash
# Apply configuration (standard Linux)
home-manager switch --flake .#default

# Apply configuration (Arch Linux — adds paru and Arch-specific packages)
home-manager switch --flake .#arch

# If home-manager is not in PATH
nix run github:nix-community/home-manager -- switch --flake .#default

# Bootstrap a fresh system (installs Nix + applies config)
./bootstrap.sh
```

There are no test or lint commands. CI validates the bootstrap process end-to-end in an Arch container.

## Architecture

**Entry point:** `flake.nix` defines inputs (nixpkgs unstable, home-manager, fenix, flake-parts) and two home configurations (`default`, `arch`) via a `mkHome` helper. Custom arguments (`username`, `homeDirectory`, `dotfilesDir`, `fenix`) are passed to modules through `extraSpecialArgs`.

**Aggregator:** `home.nix` imports all common modules from `modules/`.

**Modules (`modules/`):** Each file is a self-contained Home Manager module receiving `{ pkgs, config, lib, username, homeDirectory, fenix, dotfilesDir, ... }`. Language toolchains live under `modules/dev/`.

**Raw configs (`config/`):** Neovim (LazyVim) and WezTerm configs live here and are linked via out-of-store symlinks (`config.lib.file.mkOutOfStoreSymlink`), so edits take effect immediately without `home-manager switch`.

## Key Patterns

- **Out-of-store symlinks** for frequently-edited configs (nvim, wezterm) — avoids rebuilds on every change.
- **Conditional module loading** — `arch.nix` is only included when `isArch = true`.
- **Fenix for Rust** — the `fenix` flake input provides the stable Rust toolchain with selected components.
- **Systemd session variable sync** — `systemd.user.sessionVariables = config.home.sessionVariables` keeps env vars consistent across systemd services.

## Conventions

- **Commit messages:** Conventional commits format (e.g., `feat(services): add syncthing`, `refactor: reorganize modules`).
- **Adding packages:** Add to the relevant module in `modules/`, not to `home.nix`.
- **Shell aliases/env vars:** Define in `modules/shell.nix`.
- **State version:** 25.11 — do not change without understanding migration implications.
