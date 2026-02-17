{ pkgs, username, homeDirectory, ... }:

{
  home.stateVersion = "25.11";
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    nerd-fonts.meslo-lg
    btop
    fastfetch
  ];

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "${homeDirectory}/.local/bin"
  ];

  programs.home-manager.enable = true;
}
