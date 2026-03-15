{
  pkgs,
  config,
  username,
  homeDirectory,
  ...
}:

{
  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    packages = with pkgs; [
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
    sessionPath = [
      "${homeDirectory}/.local/bin"
    ];
  };

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  systemd.user.sessionVariables = config.home.sessionVariables;
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
}
