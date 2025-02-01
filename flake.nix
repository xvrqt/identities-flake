{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { agenix, ... }:
    let
      userInfo = import ./users.nix;
    in
    {
      # inherit lib pkgs users;
      nixosModules = rec {
        # List of user configurations 
        users = {
          # Me :]
          crow = { lib, pkgs, config, ... }: {
            imports = [
              (import ./crow { inherit lib pkgs config agenix userInfo; })
              (import ./common.nix { inherit pkgs agenix; })
              agenix.nixosModules.default
            ];
          };
        };
        default = users.crow;
      };
    };
}
