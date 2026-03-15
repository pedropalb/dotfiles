{
  pkgs,
  config,
  username,
  homeDirectory,
  ...
}:

{
  home.stateVersion = "25.11";
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  systemd.user.sessionVariables = config.home.sessionVariables;

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
    unzip
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
