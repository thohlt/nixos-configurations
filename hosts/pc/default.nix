# Ryzen 7 7700X, Radeon RX 6950 XT: only what is specific to this machine.
{
  imports = [ ./hardware-configuration.nix ];

  my.desktop.plasma.enable = true;
  my.apps.enable = true;
  my.dev.enable = true;
  my.printing.enable = true;

  # Release of the first install. Never change it on an existing system.
  # https://nixos.org/manual/nixos/unstable/options#opt-system.stateVersion
  system.stateVersion = "26.11";
}
