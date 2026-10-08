{
  inputs = {
    # System + most packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Stable channel for selected packages (e.g. gh)
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

        ({ ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              # Don't pass prev.config — unstable options break 26.05 evaluation.
              stable = import inputs.nixpkgs-stable {
                inherit system;
                config.allowUnfreePredicate = pkg:
                  builtins.elem (prev.lib.getName pkg) [
                    "cursor-cli"
                  ];
              };
            })
          ];
        })
      ];
    };
  };
}
