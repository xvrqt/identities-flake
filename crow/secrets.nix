let
  crow = publicKeys.users.crow;
  publicKeys = (builtins.getFlake "git+https://git.irlqt.net/crow/secrets-flake").publicKeys;
in
{
  # Crow's private SSH key, only accessible to Crow
  "secrets/ssh/crow.key".publicKeys = [ crow ];
}
