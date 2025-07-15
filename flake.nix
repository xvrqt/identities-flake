{
  inputs = {
    secrets.url = "git+https://git.irlqt.net/crow/secrets-flake";
  };

  outputs = { secrets, ... }:
    let
      userInfo = import ./users.nix;
    in
    {
      # If other flakes want to use this as an input, for coherency
      inherit userInfo;
      nixosModules = {
        # This module is always required, and then import individual users
        default = { lib, config, ... }: {
          imports = [
            # Import a preconfigure Agenix
            secrets.nixosModules.default
            # Enable SSH and configure it with sane defaults
            (import ./ssh.nix { inherit userInfo; })
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
          crow = { lib, pkgs, config, ... }: {
            imports = [
              (import ./crow { inherit lib pkgs config secrets userInfo; })
            ];
          };
        };
        # For other Flakes that might need user details
        inherit userInfo;
      };
    };
}
