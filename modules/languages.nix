{
  pkgs,
  fenix,
  config,
  ...
}:

{
  home.packages = with pkgs; [
    gcc
    uv
    nodejs

    (fenix.packages.${pkgs.stdenv.hostPlatform.system}.stable.withComponents [
      "cargo"
      "rustc"
      "rust-src"
      "clippy"
      "rustfmt"
      "rust-analyzer"
    ])

    # Nix
    statix
    nil
    nixfmt

    # --- Core / Neovim Defaults ---
    lua-language-server
    stylua
    shfmt

    # --- lang.docker ---
    docker-compose-language-service
    dockerfile-language-server
    hadolint

    # --- lang.haskell ---
    haskell-language-server

    # --- lang.java ---
    jdt-language-server

    # --- lang.json, lang.yaml, lang.markdown, lang.typescript ---
    nodePackages.prettier # Shared formatter
    vscode-langservers-extracted # Provides jsonls, eslint
    yaml-language-server
    marksman # Markdown LSP
    markdownlint-cli

    # --- lang.kotlin ---
    kotlin-language-server
    ktlint

    # --- lang.python ---
    ty
    ruff

    # --- lang.tex ---
    texlab

    # --- lang.toml ---
    taplo

    # --- lang.typescript ---
    vtsls

    # --- Debug Adapters (DAP) ---
    python3Packages.debugpy # For Python DAP
    lldb # Provides lldb-vscode / codelldb for Rust
  ];

  xdg.configFile."npm/npmrc".text = ''
    prefix=${config.home.homeDirectory}/.local
    cache=${config.xdg.cacheHome}/npm
    init-module=${config.xdg.configHome}/npm/config/npm-init.js
  '';

  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
  };
}
