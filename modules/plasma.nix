# KDE Plasma 6 with Plasma Login Manager.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.plasma;
in
{
  options.my.desktop.plasma.enable = lib.mkEnableOption "the KDE Plasma desktop";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.plasma-login-manager.enable = true;

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };

    environment.systemPackages = [
      pkgs.kdePackages.kcalc # no NixOS module
    ];
  };
}
