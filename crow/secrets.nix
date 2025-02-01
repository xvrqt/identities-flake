let
  userInfo = import ../users.nix;
  crow = userInfo.crow.agenix.publicKey;
in
{
  # Crow's private SSH key, only accessible to Crow
  "secrets/ssh/crow.key".publicKeys = [ crow ];
}
