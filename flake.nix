{
  description = "My personal home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Bun releases land in nixpkgs late; track upstream directly.
    # Bump: edit the version in this URL, then `nix flake update bun-src`.
    bun-src = {
      type = "tarball";
      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.14/bun-linux-x64.zip";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      flake = {
        homeConfigurations =
          let
            # Single source of truth for the bun version: the locked input URL.
            bunVersion =
              let
                lock = builtins.fromJSON (builtins.readFile ./flake.lock);
                match = builtins.match ".*/bun-v([^/]+)/.*" lock.nodes.bun-src.locked.url;
              in
              if match == null then
                throw "cannot parse bun version from the bun-src input URL in flake.lock"
              else
                builtins.head match;
            mkHome =
              {
                username,
                isArch ? false,
                extraLanguages ? [ ], # subset of [ "haskell" "java" "kotlin" ]
              }:
              let
                homeDirectory = "/home/${username}";
              in
              inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
                modules = [
                  ./home.nix
                  {
                    my.languages = inputs.nixpkgs.lib.genAttrs extraLanguages (_: {
                      enable = true;
                    });
                  }
                ]
                ++ (if isArch then [ ./modules/arch.nix ] else [ ]);
                extraSpecialArgs = {
                  inherit (inputs) fenix;
                  inherit bunVersion;
                  bunSrc = inputs.bun-src;
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
      };
    };

}
