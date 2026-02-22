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
}
