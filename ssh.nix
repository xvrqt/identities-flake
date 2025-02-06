# Enable SSH and configure it with safe defaults for all users
{ userInfo, ... }:
let
  listOfAllUsers = builtins.attrNames userInfo;
in
{
  # Configure SSH
  services = {
    openssh = {
      enable = true;
      settings = {
        # Allows hostnames to be FQDN (sshd will check their DNS record matches)
        UseDns = true;
        # Only allow identites specified in this flake
        AllowUsers = listOfAllUsers;
        # SSH should check the permissions of the identity files and directories
        StrictModes = true;
        # We don't need to log in as root
        PermitRootLogin = "no";
        # SSH Keys Only
        PasswordAuthentication = false;
      };
    };
  };
}
