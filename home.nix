{ config, pkgs, username, lib, fenix, ... }:

let
  dotfiles = "${config.home.homeDirectory}/workspace/dotfiles";
  repoConfig = "${dotfiles}/config";
  zshConfigDir = "${config.xdg.configHome}/zsh";
in
{
  home.stateVersion = "25.11"; 
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  home.packages = with pkgs; [
    paru

    ripgrep
    fd
    fzf
    atuin

    nerd-fonts.meslo-lg

    gcc

    uv

    nodejs

    (fenix.packages.${pkgs.system}.stable.withComponents [
      "cargo"
      "rustc"
      "rust-src"
      "clippy"
      "rustfmt"
    ])
  ];
  
  xdg.configFile = {
    "zsh/.p10k.zsh".source = ./.p10k.zsh;
    "wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${repoConfig}/wezterm/wezterm.lua";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${repoConfig}/nvim";

    "npm/npmrc".text = ''
      prefix=${config.home.homeDirectory}/.local
      cache=${config.xdg.cacheHome}/npm
      init-module=${config.xdg.configHome}/npm/config/npm-init.js
    '';
  };

  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.zsh = {
    enable = true;
    dotDir = zshConfigDir;
    
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
    flags = ["--disable-up-arrow"];
    settings = {
      auto_sync = false;
      style = "full";
      enter_accept = false;
    };
  };

  fonts.fontconfig = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
