let
  crow = publicKeys.users.crow;
  publicKeys = (builtins.getFlake "github:xvrqt/secrets-flake").publicKeys;
in
{
  # Crow's private SSH key, only accessible to Crow
  "secrets/ssh/crow.key".publicKeys = [ crow ];
}
