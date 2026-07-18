{
  pkgs,
  config,
  dotfilesDir,
  ...
}:

{
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/wezterm/wezterm.lua";

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g extended-keys on
    '';
  };

  home.packages = [ pkgs.nerd-fonts.meslo-lg ];

  fonts.fontconfig.enable = true;
}
