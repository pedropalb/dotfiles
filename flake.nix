{
  description = "My personal home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-on-droid.url = "github:nix-community/nix-on-droid/master";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid.inputs.home-manager.follows = "home-manager";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      flake = {
        homeConfigurations =
          let
            mkHome =
              {
                username,
                isArch ? false,
              }:
              let
                homeDirectory = "/home/${username}";
              in
              inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
                modules = [
                  ./home.nix
                ]
                ++ (if isArch then [ ./modules/arch.nix ] else [ ]);
                extraSpecialArgs = {
                  inherit (inputs) fenix;
                  inherit username homeDirectory;
                  dotfilesDir = "${homeDirectory}/.config/home-manager";
                };
              };
          in
          {
            "default" = mkHome { username = "pedro"; };
            "arch" = mkHome {
              username = "pedro";
              isArch = true;
            };
          };

        nixOnDroidConfigurations = {
          "default" = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
            pkgs = import inputs.nixpkgs { system = "aarch64-linux"; };
            modules = [
              ./nix-on-droid.nix
              {
                home-manager = {
                  config = ./home.nix;
                  backupFileExtension = "hm-bak";
                  useGlobalPkgs = true;
                  extraSpecialArgs = {
                    inherit (inputs) fenix;
                    username = "nix-on-droid";
                    homeDirectory = "/data/data/com.termux.nix/files/home";
                    dotfilesDir = "/data/data/com.termux.nix/files/home/.config/home-manager";
                  };
                };
              }
            ];
          };
        };
      };
    };

}
