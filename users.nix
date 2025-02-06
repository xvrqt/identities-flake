{
  crow = {
    name = "crow";
    password = "$y$j9T$aclS.QcZOPfxXBn3pa7aN/$cjLpl6MrpmGmCzQRWQxLW9HDEKxhOnWLPCqMSvFqUR.";
    # There has got to be a way to get Agenix to import this from "secrets-flake"
    # Or maybe it can provide a command that will re-generate them from that flake to
    # ease key rotation?
    agenix = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTsYcLV5djsXoISRIysYrbHOnPHt3SIqtXdiWIJ+m0Y crow@agenix";
      #   privateKeyFile = "crow.agenix";
    };
    ssh = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBmS29bR+UuD0LZPXu+KuGiny4Lnf8s/bnhZBWDb7Q9H crow@xvrqt";
    };
  };
}
