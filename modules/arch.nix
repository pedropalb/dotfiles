{ pkgs, ... }:

{
  home.packages = with pkgs; [
    paru
  ];
}
