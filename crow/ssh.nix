# Adds the other users as authorized keys for this machine
# Uses Agenix to decrypt the SSH private key to the 'key'
{ lib, config, userInfo, ... }:
let
  user = userInfo.crow;
  # The SSH public keys of every user in users.nix
  allPublicKeys = lib.attrsets.mapAttrsToList (_: value: value.ssh.publicKey) userInfo;
  # Check if this user is enabled
  cfgCheck = config.identities.${user.name}.enable;
in
{
  config = lib.mkIf cfgCheck {
    # Allow this user to be logged in by all users
    users.users."${user.name}".openssh.authorizedKeys.keys = allPublicKeys;

    # Recrypt private key to: /key/secrets/ssh
    age.secrets.sshPrivateKey = {
      # Which file to decrypt and assign to this config key
      file = ./secrets/ssh/crow.key;
      # Folder to decrypt into (config.age.secretDir/'path')
      name = "ssh/${user.name}.key";

      # File Permissions
      mode = "400";
      owner = "${user.name}";

      # Symlink from the secretDir to the 'path'
      # Doesn't matter since both are in the same partition
      symlink = true;
    };
  };
}
