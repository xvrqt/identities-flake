{ pkgs, agenix, userInfo, ... }:
let
  listOfAllUsers = builtins.attrNames userInfo;
in
{
  # Install tools for secret management
  environment.systemPackages = [
    # age key generation and management
    pkgs.age
    agenix.packages.${pkgs.system}.default
    # GNU Privacy Guard key generation and management
    pkgs.gnupg
  ];

  # Configure agenix
  age = {
    # Where to decrypt secrets by default, and where to store secret per generation
    secretsDir = "/key/secrets";
    secretsMountPoint = "/key/agenix/generations";
  };

  # Enable SSH
  services = {
    openssh = {
      enable = true;
      settings = {
        # Allows hostnames to be FQDN (sshd will check their DNS record matches)
        UseDns = true;
        # SSH should check the permissions of the identity files and directories
        StrictModes = true;
        # We don't need to log in as root
        PermitRootLogin = "no";
        # SSH Keys Only
        PasswordAuthentication = false;
        # Only allow identites specified in this flake
        AllowUsers = listOfAllUsers;
      };
    };
  };
}
