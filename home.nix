{ config, pkgs, username, ... }:
let
  homeDirectory = "/home/${username}";
  configDirectory = "${homeDirectory}/.config";
#   p10k = {
#     name = "powerlevel10k/powerlevel10k";
#     src = builtins.fetchGit {
#       url = "https://github.com/romkatv/powerlevel10k.git"; 
#       rev = "36f3045d69d1ba402db09d09eb12b42eebe0fa3b";
#     };
#   };
in
{
  home.stateVersion = "25.11"; 
  home.username = username;
  home.homeDirectory = homeDirectory;
  
  home.packages = [
    pkgs.ripgrep
    pkgs.fzf
    pkgs.zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    dotDir = "${configDirectory}/zsh";
    
    autosuggestion.enable = true;
    enableCompletion = true;
    history.append = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      l = "ls -lah";
    };

    oh-my-zsh = {
      enable = true;
      theme = "powerlevel10k/powerlevel10k";
      plugins = [
        "git"
	"sudo"
      ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.home-manager.enable = true;
}
