# Repository checks, run by `nix flake check` (locally, in CI and by Claude).
# Each check is a tiny derivation that fails with a readable message.
{
  self,
  pkgs,
  lib,
}:
let
  # Packages that may be listed although a programs.<name> / services.<name>
  # module exists. Every entry needs a reason.
  packageExceptions = {
    # example = "only the CLI is wanted, the module would also start a daemon";
  };

  mkCheck =
    {
      name,
      failures,
      env ? { },
    }:
    pkgs.runCommandLocal name (env // { failures = lib.concatStringsSep "\n" failures; }) ''
      if [ -n "$failures" ]; then
        echo "$failures" >&2
        exit 1
      fi
      touch $out
    '';

  isInRepo = def: lib.hasPrefix (toString self) (toString def.file);

  # NixOS modules (with an `enable` option) that could replace a package.
  modulesFor =
    options: pkg:
    let
      names = lib.unique [
        (lib.getName pkg)
        (pkg.meta.mainProgram or (lib.getName pkg))
      ];
      hasModule = ns: n: options.${ns} ? ${n} && options.${ns}.${n} ? enable;
      found = lib.concatMap (ns: map (n: "${ns}.${n}") (lib.filter (hasModule ns) names)) [
        "programs"
        "services"
      ];
    in
    lib.optionals (!(packageExceptions ? ${lib.getName pkg})) found;

  # Hard rule: never list a package that has a NixOS module.
  modulesOverPackages =
    host: system:
    let
      inherit (system) options config;
      systemPkgs = lib.concatMap (def: def.value) (
        lib.filter isInRepo options.environment.systemPackages.definitionsWithLocations
      );
      # No NixOS module adds to users.users.<name>.packages, so all of it is ours.
      userPkgs = lib.concatMap (user: user.packages) (lib.attrValues config.users.users);
      failures = lib.concatMap (
        pkg:
        let
          modules = modulesFor options pkg;
        in
        lib.optional (modules != [ ])
          "${host}: package '${lib.getName pkg}' is listed, but a NixOS module exists: ${lib.concatStringsSep ", " modules}. Enable the module instead (or add a reasoned entry to packageExceptions in checks/default.nix)."
      ) (systemPkgs ++ userPkgs);
    in
    mkCheck {
      name = "${host}-modules-over-packages";
      inherit failures;
    };

  # Zero warnings: NixOS module warnings (renamed/removed options etc.) fail.
  # Referencing the toplevel drvPath also forces a full evaluation of the
  # host (plain `nix flake check` only checks that it is a derivation), so
  # eval errors and `lib.warn` traces surface here without building anything.
  noWarnings =
    host: system:
    mkCheck {
      name = "${host}-no-warnings";
      failures = map (w: "${host}: warning: ${w}") system.config.warnings;
      env.toplevel = builtins.unsafeDiscardStringContext system.config.system.build.toplevel.drvPath;
    };
in
{
  formatting = pkgs.nixfmt-tree.check self;

  # Every item in a systemPackages / users.users.<name>.packages list must
  # say why it is a package: `# no NixOS module` on its line or the line above.
  package-comments =
    pkgs.runCommandLocal "package-comments"
      {
        nativeBuildInputs = [ pkgs.gawk ];
        src = self;
      }
      ''
        cd "$src"
        find . -name '*.nix' -not -path './checks/*' -print0 \
          | xargs -0 awk -f ${./package-comments.awk}
        touch $out
      '';
}
// lib.concatMapAttrs (host: system: {
  "${host}-modules-over-packages" = modulesOverPackages host system;
  "${host}-no-warnings" = noWarnings host system;
}) self.nixosConfigurations
