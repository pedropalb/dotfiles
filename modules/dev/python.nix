{ pkgs, ... }:

{
  home.packages = with pkgs; [
    uv
    ty
    ruff
    python3Packages.debugpy # For Python DAP
  ];
}
