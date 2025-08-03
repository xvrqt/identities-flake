{ lib, user, config, ... }:
let
  # If this identity is enabled
  identityEnabled = config.identities.${user.name}.enable;
  persistCheck = config.identities.impermanence;
  cfgCheck = persistCheck && identityEnabled;
in
{
  environment.persistence."/persist".users."${user.name}" = lib.mkIf cfgCheck {
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
}
