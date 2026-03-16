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
    packages = with pkgs; [
      nerd-fonts.meslo-lg
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
