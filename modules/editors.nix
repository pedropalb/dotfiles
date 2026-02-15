{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/workspace/dotfiles";
  repoConfig = "${dotfiles}/config";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${repoConfig}/nvim";
}
