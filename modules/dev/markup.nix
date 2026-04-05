{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yaml-language-server
    marksman
    markdownlint-cli
    markdownlint-cli2
  ];
}
