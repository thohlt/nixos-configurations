# Printing and scanning over the network (IPP Everywhere / eSCL, driverless).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.printing;
in
{
  options.my.printing.enable = lib.mkEnableOption "network printing and scanning";

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;

    # mDNS discovery of network printers and scanners. cups-browsed follows
    # services.avahi.enable and adds discovered printers automatically.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };

    # Plasma adds Skanpage (successor of Skanlite) when SANE is enabled.
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };
}
