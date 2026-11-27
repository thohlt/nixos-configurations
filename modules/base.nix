# Settings every machine shares: boot, firmware, networking, locale, audio.
{ pkgs, ... }:
{
  # UEFI + systemd-boot. LUKS devices come from hardware-configuration.nix.
  boot.loader = {
    systemd-boot = {
      enable = true;
      # Keep /boot (the ESP) from filling up with old generations.
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  # Wi-Fi, GPU and CPU microcode firmware (linux-firmware).
  hardware.enableRedistributableFirmware = true;

  zramSwap.enable = true;

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # TODO: confirm timezone, locale and keyboard layout.
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "de";
  console.useXkbConfig = true;

  # Audio via PipeWire, with the PulseAudio and ALSA layers most apps expect.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # git is needed to work with this flake.
  environment.systemPackages = [ pkgs.git ];
}
