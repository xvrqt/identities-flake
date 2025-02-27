{ pkgs, user, ... }:
{
  users.users."${user.name}" = {
    uid = 1000;
    description = "Social, intelligent member of the Corvidae family";

    # Start user services at boot, not at login
    linger = true;
    # Enable 'sudo' for the user
    # Add the groups that are used by the 'arr' stack for convenience
    extraGroups = [ "wheel" "pirates" "media-players" "dialout" ];
    # i.e. is *not* a daemon wearing human skin
    isNormalUser = true;

    # Set the shell
    # This will likely be configured by CLI-Flake
    shell = pkgs.zsh;
    # Need to include our shell for it to work
    packages = [ pkgs.zsh ];

    # Set the password via hash
    hashedPassword = user.password;
    initialHashedPassword = user.password;
  };
} 
