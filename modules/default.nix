# Shared modules imported by every host (see flake.nix).
# Base modules apply unconditionally; feature modules have an
# `my.<feature>.enable` option that hosts switch on.
{
  imports = [
    ./nix.nix
    ./base.nix
    ./users.nix
    ./unfree.nix
    ./plasma.nix
    ./apps.nix
    ./dev.nix
    ./printing.nix
  ];
}
