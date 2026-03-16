{ pkgs, fenix, ... }:

{
  home.packages = with pkgs; [
    gcc
    (fenix.packages.${pkgs.stdenv.hostPlatform.system}.stable.withComponents [
      "cargo"
      "rustc"
      "rust-src"
      "clippy"
      "rustfmt"
      "rust-analyzer"
    ])
    lldb # Provides lldb-vscode / codelldb for Rust
  ];
}
