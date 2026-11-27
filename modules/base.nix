# Settings every machine shares: boot, firmware, networking, locale, audio.
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

  time.timeZone = "Europe/Berlin";

  # English language, German date and currency formats.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
  };

  # US keyboard layout, also used on the console.
  services.xserver.xkb.layout = "us";
  console.useXkbConfig = true;

  # Audio via PipeWire, with the PulseAudio and ALSA layers most apps expect.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # git is needed to work with this flake.
  programs.git.enable = true;
}
