{ lib, user, config, ... }:
let
  # If this identity is enabled
  identityEnabled = config.identities.${user.name}.enable;

  # List of directories to create
  directories = [ "dev" "docs" "media" "projects" ];

  username = user.name;
in
{
  # Create common directories - clean up 'downloads' on restart
  systemd.tmpfiles.rules = lib.mkIf identityEnabled ((map (dir: "d /home/${username}/${dir} 0770 ${username} users -") directories) ++ [ "d /home/${username}/downloads 0770 ${username} users" ]);
}

