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
    ./modules/dev/rust.nix
    ./modules/dev/node.nix
    ./modules/dev/python.nix
    ./modules/dev/nix.nix
    ./modules/dev/lsp.nix
  ];
}
