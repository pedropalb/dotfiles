{ config, pkgs, username, ... }:
let
  homeDirectory = "/home/${username}";
  configDirectory = "${homeDirectory}/.config";
in
{
  home.stateVersion = "25.11"; 
  home.username = username;
  home.homeDirectory = homeDirectory;
  
  home.packages = [
    pkgs.ripgrep
    pkgs.fzf
    pkgs.neovim
  ];

  programs.zsh = {
    enable = true;
    dotDir = "${configDirectory}/zsh";
    
    autosuggestion.enable = true;
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      l = "ls -lah";
    };
  };

  programs.home-manager.enable = true;
}
