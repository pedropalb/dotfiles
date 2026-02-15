{ pkgs, fenix, config, homeDirectory, configDirectory, ... }:

{
  home.packages = with pkgs; [
    gcc
    uv
    nodejs

    (fenix.packages.${pkgs.system}.stable.withComponents [
      "cargo"
      "rustc"
      "rust-src"
      "clippy"
      "rustfmt"
    ])
  ];

  xdg.configFile."npm/npmrc".text = ''
    prefix=${homeDirectory}/.local
    cache=${config.xdg.cacheHome}/npm
    init-module=${configDirectory}/npm/config/npm-init.js
  '';

  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${configDirectory}/npm/npmrc";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
  };
}
