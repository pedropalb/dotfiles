# Dotfiles

This repository contains personal dotfiles managed with **Nix**, **Nix Flakes**, and **Home Manager**. It provides a reproducible, modular, and declarative configuration for a Linux environment, specifically optimized for `x86_64-linux`. It also includes a dedicated bash-based script for replicating this environment on Android via **Termux**.

## Overview

These dotfiles install and configure a full development environment, primarily focusing on CLI tools. As a general rule, GUI applications are not installed via Home Manager in this repository.

Included configurations:
- **Shell**: Zsh with Oh My Zsh and Powerlevel10k theme.
- **Editor**: Neovim (configured via LazyVim).
- **Terminal**: WezTerm (Configuration only; the app itself is not installed by Home Manager).
- **Languages**: Rust (via Fenix), Node.js, and Python (via uv).
- **CLI Tools**: `ripgrep`, `fd`, `fzf`, `atuin`, `bat`, `zoxide`, `fastfetch`, `btop`, and more.
- **Coding Agents**: `herdr` and `omp` (via the `llm-agents.nix` flake; see [Coding Agents](#coding-agents)).

## Getting Started

### Initial Setup (Linux)
To bootstrap a new Linux system, you can use the provided convenience script:
```bash
./bootstrap.sh
```
This script installs Nix (using the Determinate Systems installer) and applies the initial Home Manager configuration.

### Initial Setup (Termux / Android)
To bootstrap a new Termux environment, run the standalone installation script directly:
```bash
curl -fsSL https://raw.githubusercontent.com/pedropalb/dotfiles/main/termux/install.sh | bash
```

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
    - `core.nix`: User identity, stateVersion, XDG paths, sessionPath, manual.
    - `shell.nix`: Zsh, prompt (p10k), shell utilities (zoxide, fzf, atuin), aliases, and general CLI utilities.
    - `terminal.nix`: WezTerm symlink, tmux, nerd font, and fontconfig.
    - `services.nix`: User services (Syncthing, `STNOUPGRADE`, plannotator env).
    - `dev.nix`: Git, lazygit, Neovim, npm env, and all language toolchains (Rust, Node, Python, Nix, Lua, shell, Docker, markup, TeX, TOML). Haskell, Java, and Kotlin are opt-in via `extraLanguages`.
    - `arch.nix`: Arch Linux specific packages (paru).
- `config/`: Contains raw configuration files symlinked into your home directory.
    - `config/nvim/`: Full Neovim configuration.
    - `config/wezterm/`: WezTerm configuration.
- `termux/`: Contains installation, testing, and configuration scripts specifically for reproducing the environment on Termux (Android).

### Customization
- To add **packages**, modify the relevant file in `modules/`: general CLI tools go in `modules/shell.nix`, development toolchains in `modules/dev.nix`.
- To change **shell aliases**, edit `modules/shell.nix`.
- For **Neovim** specific changes, edit the files in `config/nvim/`. These are symlinked as "out-of-store" symlinks, so changes take effect immediately.

### Opt-in Languages

Haskell, Java, and Kotlin tooling are off by default. To enable them per machine, pass `extraLanguages` (a subset of `[ "haskell" "java" "kotlin" ]`) to `mkHome` in `flake.nix`:

```nix
"default" = mkHome { username = "pedro"; extraLanguages = [ "haskell" ]; };
```

### Coding Agents

`herdr` and `omp` are installed from the [numtide/llm-agents.nix](https://github.com/numtide/llm-agents.nix) flake input through Home Manager. `omp` is the [oh-my-pi](https://github.com/can1357/oh-my-pi) coding agent. Bump both with `nix flake update llm-agents`.

The numtide binary cache is configured system-wide on this machine in
`/etc/nix/nix.custom.conf`, so `herdr` and `omp` can be downloaded from the
cache instead of being built locally. On a new machine, configure it before
your first `home-manager switch`; otherwise `omp` is compiled from source —
over a thousand derivations, including two Zig toolchains. Nix ignores
binary-cache settings from a non-root user, and the flake's own `nixConfig`
does not take effect on its own.

With the Determinate Systems installer, append these settings to
`/etc/nix/nix.custom.conf` (never `/etc/nix/nix.conf`, which is regenerated):

```
extra-substituters = https://cache.numtide.com
extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
```

Then restart the daemon, since it only reads its configuration at startup:

```bash
sudo systemctl restart nix-daemon
```

Confirm it took effect with `nix config show substituters` — a malformed setting only produces a warning, so the first sign of a mistake would be a switch that starts building instead of downloading.
