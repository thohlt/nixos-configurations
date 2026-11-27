# Unfree packages allowed by name, so nothing unfree slips in unnoticed.
{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "spotify"
      "steam"
      "steam-unwrapped"
      "vscode"
      "zoom"
    ];
}
