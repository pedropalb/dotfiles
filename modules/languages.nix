{ pkgs, fenix, config, ... }:

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
    ])
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
