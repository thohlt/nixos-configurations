# Development tools. Project-specific toolchains belong in `nix develop` shells.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.dev;
in
{
  options.my.dev.enable = lib.mkEnableOption "the development tools";

  config = lib.mkIf cfg.enable {
    programs.vscode.enable = true;
    programs.java.enable = true;

    environment.systemPackages = [
      pkgs.claude-code # no NixOS module
      pkgs.go # no NixOS module
      pkgs.gopls # no NixOS module
      pkgs.rustup # no NixOS module
      pkgs.zola # no NixOS module
      pkgs.jq # no NixOS module
    ];
  };
}
