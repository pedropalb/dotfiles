{
  pkgs,
  username,
  homeDirectory,
  ...
}:

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
    yazi
    dust
    lazygit
    eza
  ];

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "${homeDirectory}/.local/bin"
  ];

  programs.home-manager.enable = true;

  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;
}
