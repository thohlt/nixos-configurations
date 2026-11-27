# Modern defaults and Nix style

Always the current idiomatic way. Legacy only on request, labelled LEGACY.

## Flakes and CLI

- `nix.settings.experimental-features = [ "nix-command" "flakes" ];` Don't
  lecture about experimental status.
- `nix.channel.enable = false;`; the flake provides nixpkgs to the registry and
  `NIX_PATH`.
- New CLI only (`nix shell`, `nix develop`, `nix flake update/check/show`,
  `nix search`, `nix repl`). Never `nix-env -i` or `nix-shell -p`.
- New files must be `git add`ed for the flake to see them (`scripts/check`
  fails on untracked `.nix` files).
- `inputs.<x>.inputs.nixpkgs.follows = "nixpkgs";` where applicable.
  `nix.gc` and `nix.optimise` enabled.

## Repository structure

- `nixosConfigurations.<host>` per machine; `hosts/<host>/`, `modules/`,
  `overlays/`, `pkgs/`, `checks/`. Host folders only hold what is truly
  machine-specific. Shared settings go in modules; optional features get an
  `options.my.<feature>.enable` + `config = lib.mkIf ...`, enabled per host.
- `inputs` via `specialArgs`. Never change `system.stateVersion` on existing
  systems.
- No dead or duplicated code: don't set options to their default value.

## Style

- Format with `nixfmt` (`nix fmt`); `formatter.<system> = pkgs.nixfmt-tree;`.
- No file-wide `with pkgs;`/`with lib;` (short lists OK). Explicit `lib.` prefixes.
- `let ... in` over `rec`; `stdenv.mkDerivation (finalAttrs: { ... })`;
  overlays as `final: prev:`.
- Module helpers: `lib.mkEnableOption`, `mkPackageOption`, `mkOption` with
  precise types, `mkIf`, `mkMerge`, `mkDefault`, `mkForce`, `optionals`,
  `getExe`.
- SRI `hash = "sha256-...";` (`lib.fakeHash` to discover).
  `pkgs.stdenv.hostPlatform.system`, not `pkgs.system`.
