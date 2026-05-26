{ pkgs, ... }:

{
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
  ];

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g extended-keys on
    '';
  };
}
