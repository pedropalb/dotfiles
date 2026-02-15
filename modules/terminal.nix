{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/workspace/dotfiles";
  repoConfig = "${dotfiles}/config";
in
{
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${repoConfig}/wezterm/wezterm.lua";
}
