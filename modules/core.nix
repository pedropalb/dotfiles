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
  };

  # xdg.enable exports the XDG_* variables (and their systemd user session
  # counterparts); the directories themselves default to the standard paths.
  xdg = {
    enable = true;
    # Adds ~/.local/bin to home.sessionPath.
    localBinInPath = true;
  };

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  systemd.user.sessionVariables = config.home.sessionVariables;
  programs.home-manager.enable = true;
}
