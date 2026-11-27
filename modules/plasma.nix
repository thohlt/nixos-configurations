# KDE Plasma 6 on Wayland with SDDM.
{ config, lib, ... }:
let
  cfg = config.my.desktop.plasma;
in
{
  options.my.desktop.plasma.enable = lib.mkEnableOption "the KDE Plasma desktop";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    programs.firefox.enable = true;
  };
}
