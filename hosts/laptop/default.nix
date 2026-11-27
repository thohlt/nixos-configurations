# ThinkPad T480s: only what is specific to this machine.
{
  imports = [ ./hardware-configuration.nix ];

  my.desktop.plasma.enable = true;

  hardware.bluetooth.enable = true;

  # Release of the first install. Never change it on an existing system.
  # https://nixos.org/manual/nixos/unstable/options#opt-system.stateVersion
  system.stateVersion = "26.11";
}
