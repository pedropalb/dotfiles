{
  config,
  username,
  homeDirectory,
  ...
}:

{
  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";
    sessionPath = [
      "${homeDirectory}/.local/bin"
    ];
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
    cacheHome = "${homeDirectory}/.cache";
    dataHome = "${homeDirectory}/.local/share";
  };

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  systemd.user.sessionVariables = config.home.sessionVariables;
  programs.home-manager.enable = true;
}
