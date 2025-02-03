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
      # If other flakes want to use this as an input, for coherency
      inherit userInfo;
      nixosModules = rec {
        # List of user configurations 
        users = {
          # Me :]
          crow = { lib, pkgs, config, ... }: {
            imports = [
              # User file itself
              (import ./crow { inherit lib pkgs config agenix userInfo; })
              # All users should import this
              (import ./common.nix { inherit pkgs agenix; })
              # Needed for secret keeping
              agenix.nixosModules.default
            ];
          };
        };
        default = users.crow;
      };
    };
}
