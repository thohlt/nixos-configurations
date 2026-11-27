# PLACEHOLDER: replace this whole file during installation.
#
# It only exists so the flake evaluates before the machine is installed.
# Generate the real one on the target machine with
#   nixos-generate-config --root /mnt --show-hardware-config > hosts/laptop/hardware-configuration.nix
# and commit it (see INSTALL.md). The UUIDs below are fake.
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.kernelModules = [ "kvm-intel" ];

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/11111111-1111-1111-1111-111111111111";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2222-2222";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
