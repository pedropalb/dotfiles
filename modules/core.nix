{ pkgs, username, homeDirectory, configDirectory, ... }:

{
  home.stateVersion = "25.11";
  home.username = username;
  home.homeDirectory = homeDirectory;

  xdg.configHome = configDirectory;

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    nerd-fonts.meslo-lg
  ];

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "${homeDirectory}/.local/bin"
  ];

  programs.home-manager.enable = true;
}
