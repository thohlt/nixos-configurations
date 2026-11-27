# Nix daemon and store settings shared by all hosts.
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@wheel" ];
    };

    # No channels: the flake's nixpkgs is put into the registry and
    # NIX_PATH automatically (nixpkgs.flake.setFlakeRegistry/setNixPath).
    channel.enable = false;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };
}
