{ ... }:

{
  home.sessionVariables = {
    STNOUPGRADE = "1";
  };

  programs.zsh.envExtra = ''
    if [[ -n ''${SSH_CONNECTION:-} ]]; then
      export PLANNOTATOR_GLIMPSE=0
      export PLANNOTATOR_PORT=19432
      export PLANNOTATOR_REMOTE=0
      export PLANNOTATOR_SKIP_BROWSER_OPEN=1
    fi
  '';

  services.syncthing = {
    enable = true;
  };
}
