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
    lazygit
    eza
    unzip
  ];
}
