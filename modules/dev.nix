{
  pkgs,
  config,
  lib,
  fenix,
  llmAgents,
  bunSrc,
  bunVersion,
  dotfilesDir,
  ...
}:

let
  # nixpkgs trails upstream bun, so the release comes from the `bun-src` flake
  # input; only the tarball is swapped, the nixpkgs packaging is kept.
  bun = pkgs.bun.overrideAttrs {
    version = bunVersion;
    src = bunSrc;
  };
in

{
  options.my.languages = {
    haskell.enable = lib.mkEnableOption "Haskell development tooling";
    java.enable = lib.mkEnableOption "Java development tooling";
    kotlin.enable = lib.mkEnableOption "Kotlin development tooling";
  };

  config = lib.mkMerge [
    {
      # ---- Version control ----
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "pedropalb";
            email = "pedro17lopes@gmail.com";
          };
          init.defaultBranch = "main";
          pull.rebase = true;
        };
      };

      # ---- Editor ----
      xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/nvim";

      # ---- Node/npm environment (from dev/node.nix) ----
      xdg.configFile."npm/npmrc".text = ''
        prefix=${config.home.homeDirectory}/.local
        cache=${config.xdg.cacheHome}/npm
        init-module=${config.xdg.configHome}/npm/config/npm-init.js
      '';

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
        NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
        NODE_PATH = "${config.home.homeDirectory}/.local/lib/node_modules";

        # ---- Bun environment (mirrors the npm layout above) ----
        BUN_INSTALL_BIN = "${config.home.homeDirectory}/.local/bin";
        BUN_INSTALL_GLOBAL_DIR = "${config.home.homeDirectory}/.local/lib/bun";
        BUN_INSTALL_CACHE_DIR = "${config.xdg.cacheHome}/bun";
      };

      home.packages = with pkgs; [
        # tools
        lazygit
        neovim
        llmAgents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
        llmAgents.packages.${pkgs.stdenv.hostPlatform.system}.omp
        # rust
        gcc
        (fenix.packages.${pkgs.stdenv.hostPlatform.system}.stable.withComponents [
          "cargo"
          "rustc"
          "rust-src"
          "clippy"
          "rustfmt"
          "rust-analyzer"
        ])
        lldb # Provides lldb-vscode / codelldb for Rust
        # node
        nodejs
        vtsls
        prettier
        vscode-langservers-extracted # Provides jsonls, eslint
        pnpm
        # bun
        bun
        # python
        uv
        ty
        ruff
        python3Packages.debugpy # For Python DAP
        # nix
        statix
        nil
        nixfmt
        # lua
        lua-language-server
        stylua
        # shell
        shfmt
        # docker
        docker-compose-language-service
        dockerfile-language-server
        hadolint
        # markup
        yaml-language-server
        marksman
        markdownlint-cli
        markdownlint-cli2
        # tex
        texlab
        # toml
        taplo
      ];
    }

    (lib.mkIf config.my.languages.haskell.enable {
      home.packages = [ pkgs.haskell-language-server ];
    })

    (lib.mkIf config.my.languages.java.enable {
      home.packages = [ pkgs.jdt-language-server ];
    })

    (lib.mkIf config.my.languages.kotlin.enable {
      home.packages = with pkgs; [
        kotlin-language-server
        ktlint
      ];
    })
  ];
}
