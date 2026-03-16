{ pkgs, ... }:

{
  home.packages = with pkgs; [
    statix
    nil
    nixfmt
  ];
}
