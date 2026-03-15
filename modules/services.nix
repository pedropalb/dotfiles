{ ... }:

{
  home.sessionVariables = {
    STNOUPGRADE = "1";
  };

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
}
