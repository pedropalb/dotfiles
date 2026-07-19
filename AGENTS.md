# Agents Guidelines

This repository contains personal dotfiles managed with **Nix**, **Nix Flakes**, and **Home Manager** for standard Linux environments, alongside a dedicated bash-based setup for **Termux (Android)**. It targets a Linux environment (specifically `x86_64-linux`), with a base configuration (`default`) and an Arch-specific extension (`arch`), as well as a pure `pkg`/bash driven setup for Termux `aarch64`.

## Project Overview

- **Architecture:** Managed via Nix Flakes for reproducible environment and configuration on standard Linux. Configuration is modularized into `modules/`. For Termux, a bash script (`termux/install.sh`) orchestrates standard `pkg`, `npm`, and `uv` installations to mirror the Nix environment.
- **Home Manager:** Used to manage user-level packages, dotfiles (via symlinks), and shell environment.
- **Main Technologies:**
  - **Nix / Flakes:** System and package management.
  - **Home Manager:** User configuration management.
  - **Zsh:** Main shell with Oh My Zsh and Powerlevel10k theme.
  - **Neovim:** Configured with LazyVim.
  - **WezTerm:** Terminal emulator.
  - **Rust:** Development environment managed via Fenix.
  - **Other Tools:** `ripgrep`, `fd`, `fzf`, `atuin`, `bat`, `zoxide`, `uv`, `nodejs`, `fastfetch`, `btop`, `yazi`, `syncthing`, `eza`.

## Key Files and Directories

- `flake.nix`: The entry point for the Nix Flake. Defines inputs (nixpkgs, home-manager, fenix) and the `default` and `arch` home configurations.
- `home.nix`: The core Home Manager configuration aggregator. Imports common modules from `modules/`.
- `modules/`: Contains the modularized configuration files:
  - `modules/core.nix`: Core Home Manager setup, user info, stateVersion, XDG paths, sessionPath, manual.
  - `modules/shell.nix`: Zsh, prompt (p10k), shell utilities (zoxide, fzf, atuin), aliases, and general CLI utilities (`ripgrep`, `fd`, `bat`, `yazi`, `eza`, etc.).
  - `modules/terminal.nix`: WezTerm symlink, tmux, nerd font, and fontconfig.
  - `modules/services.nix`: User services (e.g., Syncthing, `STNOUPGRADE`, plannotator env).
  - `modules/dev.nix`: Git, lazygit, Neovim, npm env, and all language toolchains (Rust, Node, Python, Nix, Lua, shell, Docker, markup, TeX, TOML). Declares `my.languages.{haskell,java,kotlin}.enable` opt-in options for Haskell, Java, and Kotlin tooling (off by default; toggled via `extraLanguages` in `flake.nix`).
  - `modules/arch.nix`: Arch Linux specific packages (paru).
- `termux/`: Contains scripts and configurations for setting up the environment on Android via Termux.
  - `termux/install.sh`: Main installation script for Termux. Can be run directly via `curl ... | bash`.
  - `termux/lib.sh`: Library of shared functions for Termux scripts.
  - `termux/test.sh`: CI test script to verify the Termux installation in a Docker container.
  - `termux/uninstall.sh`: Script to cleanly remove all packages and symlinks installed by the Termux setup.
  - `termux/configs/`: Raw configuration files specifically adapted for the Termux environment.
- `bootstrap.sh`: A convenience script to install Nix (via Determinate Systems installer) and apply the initial Home Manager configuration.
- `config/`: Contains raw configuration files for applications, symlinked by Home Manager.
  - `config/nvim/`: Full Neovim configuration based on LazyVim.
  - `config/wezterm/wezterm.lua`: WezTerm configuration using Github Dark scheme and MesloLGL Nerd Font.
- `.p10k.zsh`: Configuration for the Powerlevel10k Zsh theme.

## Building and Running

### Initial Setup (Linux)

To bootstrap a new system, run:

```bash
./bootstrap.sh
```

### Initial Setup (Termux / Android)

To install the environment on a fresh Termux instance, run:

```bash
curl -fsSL https://raw.githubusercontent.com/pedropalb/dotfiles/main/termux/install.sh | bash
```

### Applying Changes

After modifying `home.nix` or `flake.nix`, apply the changes with:

```bash
# For standard Linux
home-manager switch --flake .#default

# For Arch Linux (includes extra packages)
home-manager switch --flake .#arch
```

Alternatively, if `home-manager` is not in your path yet:

```bash
nix run github:nix-community/home-manager -- switch --flake .#default
```

### Opt-in Languages

Haskell, Java, and Kotlin tooling are off by default. To enable them per machine, pass `extraLanguages` (a subset of `[ "haskell" "java" "kotlin" ]`) to `mkHome` in `flake.nix`:

```nix
"default" = mkHome { username = "pedro"; extraLanguages = [ "haskell" ]; };
```

A typo'd language name fails loudly at eval time with `The option \`my.languages.<name>' does not exist`.

### Neovim Configuration

Neovim is symlinked as an "out-of-store" symlink in `modules/dev.nix`:

```nix
xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/nvim";
```

This allows editing files in `config/nvim/` and having changes reflected immediately in Neovim without a `home-manager switch`.

### LazyVim Architecture & Extension

The Neovim config under `config/nvim/` is a standard LazyVim distribution. Files are auto-discovered by lazy.nvim:

- `lua/config/options.lua`: loaded **before** lazy.nvim startup. Use for `vim.opt.*` only.
- `lua/config/autocmds.lua`: loaded on the `VeryLazy` event. Use `vim.api.nvim_create_autocmd` for custom behavior.
- `lua/config/keymaps.lua`: custom keymaps.
- `lua/config/lazy.lua`: lazy.nvim bootstrap and `require("lazy").setup({...})`.
- `lua/plugins/*.lua`: plugin specs. Every file returning a table is auto-loaded; multiple specs targeting the same plugin are merged.

**Overriding LazyVim defaults:** create a spec in `lua/plugins/` with the same plugin name and an `opts` table. lazy.nvim deep-merges (`lazy/core/util.lua:M.merge`): a scalar value replaces a table at the same key; `vim.NIL` deletes a key. Example — disable diagnostic virtual text globally:

```lua
-- lua/plugins/lsp.lua
return {
  { "neovim/nvim-lspconfig", opts = { diagnostics = { virtual_text = false } } },
}
```

LazyVim's lspconfig `config()` calls `vim.diagnostic.config(opts.diagnostics)` with the merged opts, so this is the sanctioned way to change diagnostic display.

**Diagnostics API notes:**
- `vim.diagnostic.config(opts, namespace)` — the second arg is a **namespace**, not a `bufnr`. There is no buffer-local diagnostic config; per-buffer behavior requires wrapping `vim.diagnostic.handlers.<name>` (a table with `show(namespace, bufnr, diagnostics, opts)` and `hide(namespace, bufnr)` — see `:h diagnostic-handlers-example`).
- `<leader>ud` (Snacks toggle) enables/disables **all** diagnostics, not virtual text specifically.

**Verifying LazyVim behavior:** installed plugins live at `~/.local/share/nvim/lazy/` (e.g. `LazyVim/lua/lazyvim/plugins/lsp/init.lua`). Grep there to confirm how defaults are applied before overriding.

## Development Conventions

- **Nix-First:** All system packages and environment tools should be added via the appropriate module in `modules/`.
- **Modular Structure:** Keep configuration split into logical modules. Use `modules/shell.nix` for general CLI utilities and `modules/dev.nix` for development toolchains, and create new modules if necessary.
- **Symlinking:** Use `mkOutOfStoreSymlink` for configurations that are frequently iterated on (like Neovim or WezTerm) to avoid constant Nix builds.
- **Rust Development:** Rust is managed via the `fenix` input in the flake, providing a stable toolchain with common components.
- **Shell:** Zsh is the primary shell. Custom aliases and environment variables should be defined in `modules/shell.nix`.
- **Commit messages:** Commit messages should be in conventional commits standard.
