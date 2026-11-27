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

  time.timeZone = "Europe/Berlin";

  # English language, German date and currency formats.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
  };

  # US and German keyboard layouts (Plasma and the login screen).
  # The console keeps its default US keymap.
  services.xserver.xkb.layout = "us,de";

  # OpenConnect VPN (AnyConnect-compatible) in NetworkManager.
  networking.networkmanager.plugins = [ pkgs.networkmanager-openconnect ];

  # Audio via PipeWire, with the PulseAudio and ALSA layers most apps expect.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # git is needed to work with this flake.
  programs.git.enable = true;

  programs.vim.enable = true;
  programs.htop.enable = true;

  # Disk health monitoring (SMART).
  services.smartd.enable = true;

  environment.systemPackages = [
    pkgs.wget # no NixOS module
    pkgs.fastfetch # no NixOS module
    pkgs.vifm # no NixOS module
  ];
}
