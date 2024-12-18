{
  description = "Appservers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    arion.url = "github:hercules-ci/arion";
    arion.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, arion, ... }:
    let
      makeMyConfigurations = conflist: builtins.foldl' (a: b: a // b) { } (builtins.map
        ({ host, system, extraModules? [ ], apps? [ ], enableUser? false }: {
          ${host} =
            let
              basicModules = [ ./hosts/${host}.nix
                               ./basics.nix
                               { networking.hostName = host; }
                               arion.nixosModules.arion
                             ];
            in nixpkgs.lib.nixosSystem rec {
              inherit system;
              specialArgs = { inherit inputs system host; };
              modules = basicModules
                        ++ extraModules
                        ++ builtins.map (name: ./apps/${name}.nix) apps
                        ++ (if enableUser then [ ./user.nix ] else [ ]);
            };
        }) conflist);

    in {
      nixosConfigurations = makeMyConfigurations [
        {
          host = "ctvp";
          system = "x86_64-linux";
          enableUser = true;
          apps = [
            "matrix"
            "mautrix-bridges"
            "reverse"
            "headscale"
          ];
        }
      ];
    };
}
