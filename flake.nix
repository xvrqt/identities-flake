{
  inputs = {
    secrets.url = "git+https://git.irlqt.net/crow/secrets-flake";
    networking.url = "git+https://git.irlqt.net/crow/wireguard-flake";
  };

  outputs = { secrets, networking, ... }:
    let
      userInfo = import ./users.nix;
      machines = networking.config.machines;
    in
    {
      # If other flakes want to use this as an input, for coherency
      inherit userInfo;
      nixosModules = rec {
        # This module is always required, and then import individual users
        default = { lib, name, config, machines, ... }: {
          imports = [
            # Import a preconfigure Agenix
            secrets.nixosModules.default
            # Enable SSH and configure it with sane defaults
            (import ./ssh.nix { inherit lib name config machines userInfo; })
          ];
          options = {
            identities = {
              autoLogin = lib.mkOption
                {
                  type = lib.types.enum [ "crow" ];
                  default = "crow";
                  description = "Which user should be autologged in. Leave null to disable autologin";
                };
            };
          };
          config = {
            # For this to work, users should not be mutable
            users.mutableUsers = false;
            # Login the default user
            services.getty.autologinUser = config.identities.autoLogin;
          };
        };
        # List of user configurations 
        users = {
          crow = { lib, pkgs, config, ... }:
            let
              name = "crow";
            in
            {
              imports = [
                (default { inherit lib name config machines; })
                (import ./crow { inherit lib pkgs config userInfo; })
              ];
            };
        };
        # For other Flakes that might need user details
        inherit userInfo;
      };
    };
}
