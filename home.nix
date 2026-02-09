{ config, pkgs, username, lib, ... }:
let
  homeDirectory = "/home/${username}";
  configDirectory = "${homeDirectory}/.config";
  zshDotDir = "${configDirectory}/zsh";
  dotDirectory = "${homeDirectory}/workspace/dotfiles";
  dotConfigDirectory = "${dotDirectory}/config";
in
{
  home.stateVersion = "25.11"; 
  home.username = username;
  home.homeDirectory = homeDirectory;
  
  home.packages = with pkgs; [
    paru

    ripgrep
    fd
    fzf
    atuin

    nerd-fonts.meslo-lg

    rustup
    gcc

    uv

    nodejs
  ];
  
  xdg.configFile."zsh/.p10k.zsh".source = ./.p10k.zsh;
  xdg.configFile."wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotConfigDirectory}/wezterm.lua";
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotConfigDirectory}/nvim";

  xdg.configFile."npm/npmrc".text = ''
    prefix=${config.home.homeDirectory}/.local
    cache=${config.xdg.cacheHome}/npm
    init-module=${config.xdg.configHome}/npm/config/npm-init.js
  '';

  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    
    # Optional: Ensure the cache folder is also clean (XDG compliant)
    # This prevents npm from creating ~/.npm
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

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
