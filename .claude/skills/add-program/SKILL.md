---
name: add-program
description: Add a program, service or app to this NixOS flake (e.g. "install X", "add Y to the laptop", "I want Z"). Use it whenever a change would add a package or enable a program or service.
---

# Add a program

Follow these steps in order. Name the step you stopped at in your answer.

1. **Find the module.** Run `scripts/find-module <name>` (try the package
   attribute and the program's common name). Also grep the locked nixpkgs for
   the package attribute, since modules are not always named like the package:
   `grep -rln 'pkgs.<attr>\b\|"<attr>"' "$(scripts/nixpkgs-path)/nixos/modules"`.
   Confirm with mcp-nixos (third-party, queries the search.nixos.org index;
   `mcp__nixos__nix` tool, or `scripts/nixos-mcp '<json>'` where the tool is
   missing): `{"action":"search","type":"options","query":"<name>"}`,
   `{"action":"info","query":"<attr>"}` and, for a command name,
   `{"action":"search","type":"programs","query":"<binary>"}`. Pass the
   channel from `flake.lock` if it is not unstable. If it disagrees with the
   locked nixpkgs, the locked nixpkgs wins; mention the difference.
2. **Check it is current.** Read the module source at the locked rev. Look for
   `mkRenamedOptionModule`/`mkRemovedOptionModule`/`lib.warn`, check
   `nixos/modules/rename.nix`, the newest release notes
   (`nixos/doc/manual/release-notes/rl-*.section.md`), and what
   `nixos/modules/profiles/`, `installer/cd-dvd/` and `nixos/tests/` use. If
   there is a successor, use it.
3. **Pick the place.** Every host → a module in `modules/` (feature modules get
   `options.my.<feature>.enable`). One host → `hosts/<host>/default.nix`.
   Desktop apps that belong to Plasma → `modules/plasma.nix`.
4. **Write it.**
   - Module exists: `programs.<name>.enable = true;` (or `services.`) and
     configure it there. Don't set options to their defaults.
   - No module: add the package with the comment, one item per line:
     ```nix
     environment.systemPackages = [
       pkgs.<attr> # no NixOS module
     ];
     ```
     Use `users.users.thohlt.packages` only for user-only tools.
   - User settings: follow the ladder in `.claude/rules/user-config.md`
     (no Home Manager).
   - A module exists but a plain package is really needed: add the name to
     `packageExceptions` in `checks/default.nix` with the reason.
5. **Verify.** `git add` new files, `nix fmt`, `scripts/check`. Fix every
   failure and warning.
6. **Review.** Delegate to the `nix-reviewer` subagent, fix its findings, then
   open the PR. In the summary, list the modules used, what you checked, and
   what you could not confirm.
