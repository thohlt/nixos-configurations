# Desktop apps used on every machine with a desktop.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.apps;
in
{
  options.my.apps.enable = lib.mkEnableOption "the desktop apps";

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;
    programs.zoom-us.enable = true;
    programs.onlyoffice.enable = true;
    programs.vlc.enable = true;
    # Also opens LocalSend's port (53317) for receiving files.
    programs.localsend.enable = true;
    # German eID. Set openFirewall to use a smartphone as card reader.
    programs.ausweisapp.enable = true;

    environment.systemPackages = [
      pkgs.blender # no NixOS module
      pkgs.darktable # no NixOS module
      pkgs.spotify # no NixOS module
      pkgs.remmina # no NixOS module
      pkgs.prismlauncher # no NixOS module
      pkgs.tutanota-desktop # no NixOS module
      pkgs.camunda-modeler # no NixOS module
      pkgs.sox # no NixOS module
    ];
  };
}
