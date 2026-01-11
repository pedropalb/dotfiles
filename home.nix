{ config, pkgs, username, lib, ... }:
let
  homeDirectory = "/home/${username}";
  configDirectory = "${homeDirectory}/.config";
  zshDotDir = "${configDirectory}/zsh";
in
{
  home.stateVersion = "25.11"; 
  home.username = username;
  home.homeDirectory = homeDirectory;
  
  home.packages = with pkgs; [
    paru

    ripgrep
    fzf
    meslo-lgs-nf

    rustup
    gcc
  ];
  
  home.file."${zshDotDir}/.p10k.zsh".source = ./.p10k.zsh;
  home.file."${configDirectory}/wezterm/wezterm.lua".source = ./wezterm.lua;

  programs.zsh = {
    enable = true;
    dotDir = zshDotDir;
    
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
        [[ ! -f ${zshDotDir}/.p10k.zsh ]] || source ${zshDotDir}/.p10k.zsh
      '')
    ];

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      l = "ls -lah";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
	"sudo"
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  fonts.fontconfig = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
