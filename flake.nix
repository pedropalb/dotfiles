{
  description = "My personal home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents.url = "github:numtide/llm-agents.nix";
    # NOTE: llm-agents' nixpkgs is deliberately NOT followed to this flake's
    # nixpkgs so that numtide's binary cache keeps providing omp/herdr builds.
  };

  outputs =
    inputs:
    let
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
            llmAgents = inputs.llm-agents;
            inherit username homeDirectory;
            dotfilesDir = "${homeDirectory}/.config/home-manager";
          };
        };
    in
    {
      homeConfigurations = {
        "default" = mkHome { username = "pedro"; };
        "arch" = mkHome {
          username = "pedro";
          isArch = true;
        };
      };
    };
}
