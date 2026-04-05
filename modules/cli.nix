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
  ];
}
