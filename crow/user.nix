{ pkgs, user, ... }:
{
  users.mutableUsers = false;
  users.users."${user.name}" = {
    uid = 1000;
    description = "Social, intelligent member of the Corvidae family";

    # Start user services at boot, not at login
    linger = true;
    # Enable 'sudo' for the user
    extraGroups = [ "wheel" ];
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
