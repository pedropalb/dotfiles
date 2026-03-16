{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core / Neovim Defaults
    lua-language-server
    stylua
    shfmt

    # lang.docker
    docker-compose-language-service
    dockerfile-language-server
    hadolint

    # lang.haskell
    haskell-language-server

    # lang.java
    jdt-language-server

    # lang.json, lang.yaml, lang.markdown
    yaml-language-server
    marksman
    markdownlint-cli

    # lang.kotlin
    kotlin-language-server
    ktlint

    # lang.tex
    texlab

    # lang.toml
    taplo
  ];
}
