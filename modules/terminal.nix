{ config, dotfilesDir, ... }:

{
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/wezterm/wezterm.lua";
}
