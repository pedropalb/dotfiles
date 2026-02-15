{ pkgs, username, ... }:

{
  home.stateVersion = "25.11";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    paru
    ripgrep
    fd
    bat
    nerd-fonts.meslo-lg
  ];

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "/home/${username}/.local/bin"
  ];

  programs.home-manager.enable = true;
}
