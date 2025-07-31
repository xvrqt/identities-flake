# Enable SSH and configure it with safe defaults for all users
{ lib, name, machines, userInfo, ... }:
let
  userName = name;
  listOfAllUsers = builtins.attrNames userInfo;
  generateSSHConfigEntry = { hostName, ip, userName }: ''
    Host ${hostName}
      Hostname ${ip}
      User ${userName}
      Port 22
    	IdentityFile /key/secrets/ssh/crow.key
    	SetEnv TERM=xterm-256color
  '';

  generateSSHConfig = machines:
    let
      # Reduce the Cfg Machine Attr Set a list of attr sets with only salient
      # keys and values
      machinesList = map
        ({ name, value }: {
          inherit userName;
          hostName = name;
          ip = value.ip.v4.tailnet;
        })
        (lib.attrsToList machines);
      # Generate an SSH Config entry for each machine
      # TODO make this depend on if the user is in the tailnet or not
      # They are all in the tailnet but still
      entries = map generateSSHConfigEntry machinesList;

      # Add in an entry to use Git
      # TODO make this dependent on the Git service
      git = generateSSHConfigEntry { hostName = "forgejo"; ip = machines.archive.ip.v4.wg; inherit userName; };
      with_git = entries ++ [ git ];
    in
    # Glue the strings together
    lib.concatStringsSep "\n\n" with_git;

in
{
  # Configure SSH
  # Setup a basic config to make it easier to connect to all things
  programs.ssh.extraConfig = generateSSHConfig machines;
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
