{ ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/cli.nix
    ./modules/shell.nix
    ./modules/editors.nix
    ./modules/git.nix
    ./modules/terminal.nix
    ./modules/services.nix
    ./modules/dev
  ];
}
