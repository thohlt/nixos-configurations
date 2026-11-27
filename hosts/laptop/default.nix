# ThinkPad T480s: only what is specific to this machine.
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  my.desktop.plasma.enable = true;
  my.apps.enable = true;
  my.dev.enable = true;
  my.printing.enable = true;

  hardware.bluetooth.enable = true;

  # Hardware video decoding (VA-API) on the UHD 620 (Kaby Lake R).
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

  # Release of the first install. Never change it on an existing system.
  # https://nixos.org/manual/nixos/unstable/options#opt-system.stateVersion
  system.stateVersion = "26.11";
}
