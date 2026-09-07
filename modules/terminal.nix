{
  pkgs,
  config,
  dotfilesDir,
  ...
}:

{
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/wezterm/wezterm.lua";

  xdg.configFile."ghostty/config.ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/ghostty/config.ghostty";

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g extended-keys on
    '';
  };

  home.packages = [ pkgs.nerd-fonts.meslo-lg ];

  fonts.fontconfig.enable = true;
}
