{ lib, pkgs, config, userInfo, ... }:
let
  user = userInfo.crow;

  # Makes an option that defaults to 'true'
  mkEnabled = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };
in
{
  imports = [
    # Setup NixOS user
    (import ./user.nix { inherit pkgs user; })
    # Setup SSH Keys
    (import ./ssh.nix { inherit lib config userInfo; })
    # Configures which files & directories to persist for this user
    (import ./persist.nix { inherit lib user config; })
  ];

  options = {
    # Pre-configured user account - this one is also the default user account
    identities = {
      crow = {
        enable = mkEnabled;
      };
    };
  };
}
