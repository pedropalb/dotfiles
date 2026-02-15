{
  description = "My personal home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      flake = {
        homeConfigurations = {
          "pedro" = let
            username = "pedro";
            homeDirectory = "/home/${username}";
            configDirectory = "${homeDirectory}/.config";
          in inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            modules = [ ./home.nix ];
            extraSpecialArgs = {
              inherit (inputs) fenix;
              inherit username homeDirectory configDirectory;
              dotfilesDir = inputs.self;
            };
          };
        };
      };
    };
}
