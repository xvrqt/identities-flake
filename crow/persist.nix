{ lib, user, config, ... }:
let
  # If this identity is enabled
  identityEnabled = config.identities.${user.name}.enable;
  persistCheck = config.environment?persistence;
  cfgCheck = persistCheck && identityEnabled;
in
{
  # TODO: Make the '/persist' part of the path a parameter
  environment = lib.mkIf cfgCheck {
    persistence."/persist".users."${user.name}" =  {
    directories = [
      "dev"
      "docs"
      "media"
      "projects"
      "downloads"
      # TODO: Include this with the web bundle ?
      # Or check if installed ?
      ".librewolf"
      ".local/share/direnv"
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".local/share/keyring";
        mode = "0700";
      }
    ];
    # TODO: Make this depend on if hyfetch is installed
    files = [
      ".config/hyfetch.json"
    ];
  };
  };
}
