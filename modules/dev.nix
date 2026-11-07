{
  pkgs,
  config,
  lib,
  fenix,
  llmAgents,
  dotfilesDir,
  ...
}:

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

      programs.lazygit = {
        enable = true;
        settings.git.diffRenderers = [
          {
            command = "delta --dark --paging=never";
          }
        ];
      };

      # ---- Bun (JS runtime, tracks nixpkgs) ----
      programs.bun = {
        enable = true;
        settings = {
          install = {
            globalDir = "${config.xdg.dataHome}/bun/install/global";
            globalBinDir = "${config.home.homeDirectory}/.local/bin";
            cache = {
              dir = "${config.xdg.cacheHome}/bun/install/cache";
            };
          };
        };
      };

      # ---- Node/npm environment ----
      programs.npm = {
        enable = true;
        settings = {
          prefix = "${config.home.homeDirectory}/.local";
          cache = "${config.xdg.cacheHome}/npm";
          init-module = "${config.xdg.configHome}/npm/config/npm-init.js";
        };
      };

      # ---- Editor ----
      # ---- Coding agents ----
      xdg.configFile = {
        "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/nvim";
        "herdr/config.toml".source =
          config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/herdr/config.toml";
      };

      home.file.".omp/agent/config.yml".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/omp/config.yml";

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
        NODE_PATH = "${config.home.homeDirectory}/.local/lib/node_modules";
        BUN_INSTALL = "${config.xdg.dataHome}/bun";
        PI_FORCE_IMAGE_PROTOCOL = "kitty";
        PI_KITTY_PLACEHOLDERS = "1";
      };

      home.packages = with pkgs; [
        # tools
        delta
        neovim
        llmAgents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
        # llmAgents.packages.${pkgs.stdenv.hostPlatform.system}.omp
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
        vtsls
        prettier
        vscode-langservers-extracted # Provides jsonls, eslint
        pnpm
        # python
        uv
        ty
        ruff
        python3Packages.debugpy # For Python DAP
        # nix
        statix
        nixd
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

    (lib.mkIf config.my.languages.java.enable (
      let
        sdkmanDir = "${config.home.homeDirectory}/.sdkman";
        javaHome = "${sdkmanDir}/candidates/java/current";
      in
      {
        home.packages = [ pkgs.jdt-language-server ];

        # SDKMAN is not in nixpkgs: run the upstream installer once and let it
        # self-manage ~/.sdkman. rcupdate=false stops it from editing the
        # Home Manager-owned .zshrc. The installer bails if the dir exists, so
        # a broken install needs `rm -rf ~/.sdkman` before re-switching.
        home.activation.installSdkman = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [[ ! -d "${sdkmanDir}" ]]; then
            run env \
              PATH="${
                lib.makeBinPath (
                  with pkgs;
                  [
                    bash
                    curl
                    coreutils
                    findutils
                    gnugrep
                    gnused
                    gnutar
                    gzip
                    unzip
                    zip
                    which
                  ]
                )
              }" \
              SDKMAN_DIR="${sdkmanDir}" \
              bash -c 'curl -fsSL "https://get.sdkman.io?rcupdate=false" | bash' \
              || warnEcho "SDKMAN install failed; remove ${sdkmanDir} and re-run home-manager switch"
          fi
        '';

        # Default JDK (`sdk default java ...`) for non-interactive tools
        # (Gradle wrapper, IDEs); interactive zsh also gets the `sdk` function.
        home.sessionVariables = {
          SDKMAN_DIR = sdkmanDir;
          JAVA_HOME = javaHome;
        };
        home.sessionPath = [ "${javaHome}/bin" ];
        programs.zsh.initContent = lib.mkAfter ''
          [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
        '';
      }
    ))

    (lib.mkIf config.my.languages.kotlin.enable {
      home.packages = with pkgs; [
        kotlin-language-server
        ktlint
      ];
    })
  ];
}
