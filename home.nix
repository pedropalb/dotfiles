{ ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/services.nix
    ./modules/dev.nix
  ];
}
