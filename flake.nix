{
  description = "Appservers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }: let
    makeMyConfigurations = conflist: builtins.foldl' (a: b: a // b) { } (builtins.map
      ({ host, system, extraModules? [ ], extraLocalModules? [ ], enableUser? false }: {
        ${host} = let
          basicModules = [ ./hosts/${host}.nix
                           ./basics.nix
                           { networking.hostName = host; } ];
        in nixpkgs.lib.nixosSystem rec {
          inherit system;
          specialArgs = { inherit inputs system host; };
          modules = basicModules
                    ++ extraModules
                    ++ builtins.map (name: ./local-modules/${name}.nix) extraLocalModules
                    ++ (if enableUser then [ ./user.nix ] else [ ]);
        };
      }) conflist);
  in {
    nixosConfigurations = makeMyConfigurations [
      {
        host = "ctvp";
        system = "x86_64-linux";
        enableUser = true;
        extraLocalModules = [ ];
      }
    ];
  };
}
