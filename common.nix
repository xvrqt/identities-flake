{ pkgs, agenix, ... }:
{
  environment.systemPackages = [
    # age key generation and management
    pkgs.age
    agenix.packages.${pkgs.system}.default
    # Manage secrets with Nix & SOPs
    pkgs.sops
    # GNU Privacy Guard key generation and management
    pkgs.gnupg
  ];

  age = {
    # Where to decrypt secrets by default, and where to store secret per generation
    secretsDir = "/key/secrets";
    secretsMountPoint = "/key/agenix/generations";
  };
}
