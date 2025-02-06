{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # agenix.url = "github:ryantm/agenix";
    secrets.url = "github:xvrqt/secrets-flake";
  };

  outputs = { secrets, ... }:
    let
      userInfo = import ./users.nix;
    in
    {
      # If other flakes want to use this as an input, for coherency
      inherit userInfo;
      nixosModules = rec {
        # This module is always required, and then import individual users
        default = {
          imports = [
            # Import a preconfigure Agenix
            secrets.nixosModules.default
            # Enable SSH and configure it with sane defaults
            (import ./ssh.nix { inherit userInfo; })
          ];
          # For this to work, users should not be mutable
          users.mutableUsers = false;
        };
        # List of user configurations 
        users = {
          crow = { lib, pkgs, config, ... }: {
            imports = [
              (import ./crow { inherit lib pkgs config secrets userInfo; })
            ];
          };
        };
      };
    };
}
