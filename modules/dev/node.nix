{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    bun
    nodejs
    vtsls
    # nodePackages.prettier # Shared formatter
    prettier
    vscode-langservers-extracted # Provides jsonls, eslint
    pnpm
  ];

  xdg.configFile."npm/npmrc".text = ''
    prefix=${config.home.homeDirectory}/.local
    cache=${config.xdg.cacheHome}/npm
    init-module=${config.xdg.configHome}/npm/config/npm-init.js
  '';

  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NODE_PATH = "${config.home.homeDirectory}/.local/lib/node_modules";
    BUN_INSTALL_CACHE_DIR = "${config.xdg.cacheHome}/bun";
    BUN_INSTALL_GLOBAL_DIR = "${config.xdg.dataHome}/bun/global";
    BUN_INSTALL_BIN = "${config.home.homeDirectory}/.local/bin";
  };
}
