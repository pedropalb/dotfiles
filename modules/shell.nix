{
  pkgs,
  config,
  lib,
  dotfilesDir,
  ...
}:

let
  zshConfigDir = "${config.xdg.configHome}/zsh";
in
{
  xdg.configFile = {
    "zsh/.p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.p10k.zsh";
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion.enable = true;
    enableCompletion = true;
    history.append = true;
    syntaxHighlighting.enable = true;

    # Some terminals (Tern 0.9.x) spawn shells with a trimmed environment that
    # drops XAUTHORITY, so X11/Xwayland clients (AWT, Compose Desktop) fail with
    # "Authorization required". KWin randomizes the cookie path per login, so
    # restore it from the systemd user session instead of hardcoding it.
    envExtra = ''
      if [[ -n $DISPLAY && -z $XAUTHORITY ]]; then
        export XAUTHORITY="$(systemctl --user show-environment 2>/dev/null | sed -n 's/^XAUTHORITY=//p')"
        [[ -n $XAUTHORITY ]] || unset XAUTHORITY
      fi
    '';

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Powerlevel10k instant prompt
        # The check for XDG_CACHE_HOME ensures it works even if the variable isn't set yet.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      (lib.mkAfter ''
        [[ ! -f ${zshConfigDir}/.p10k.zsh ]] || source ${zshConfigDir}/.p10k.zsh
      '')
    ];

    shellAliases = {
      ls = "eza";
      ll = "ls -l";
      la = "ls -la";
      l = "ls -lah";
      y = "yazi";
      ff = "fastfetch";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidget.command = "";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = false;
      style = "full";
      enter_accept = false;
    };
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    btop
    fastfetch
    yazi
    dust
    eza
    unzip
    tree-sitter
    mosh
    speedtest-cli
    zip
  ];
}
