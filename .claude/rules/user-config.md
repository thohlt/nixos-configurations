# User-level configuration without Home Manager

Never suggest Home Manager or tools built on it (e.g. plasma-manager).
System-wide config is fine for the single user. Go down this list, stop at the
first step that works, and name the step:

1. **NixOS module** (`programs.<name>` / `services.<name>`), checked with
   `scripts/find-module` and search.nixos.org. Always preferred: maintainers
   keep it working; steps 2–5 are Thilo's to maintain. Firefox:
   `programs.firefox` (`policies` incl. `ExtensionSettings`, `preferences` +
   `preferencesStatus`, `languagePacks`, `autoConfig`); applies to all
   profiles, which is fine.
2. **System-wide config file** via `environment.etc`, preferably
   `/etc/xdg/<app>/...` (first in `XDG_CONFIG_DIRS`). Generate with
   `pkgs.formats.<ini|toml|json|yaml>`. Only if the program reads it;
   `~/.config` still overrides.
   KDE: KConfig merges `/etc/xdg/<file>rc` with the user file; the user file
   wins unless marked `[$i]`. Use `[$i]` only for locked settings. Stick to
   stable keys. If a value doesn't apply, check `~/.config/kdedefaults`.
3. **Session options:** `environment.sessionVariables`,
   `environment.shellAliases`, `programs.<shell>.interactiveShellInit`,
   `xdg.mime.defaultApplications`, `programs.dconf.profiles`, `fonts.*`,
   `users.users.<name>.packages`, `systemd.user.services` / `.timers`.
4. **Wrapper package:** `pkgs.symlinkJoin` + `makeWrapper`
   (`--add-flags`/`--set`). Not for programs that must write their config.
5. **Files in $HOME:** `systemd.user.tmpfiles.users.<name>.rules` (or
   `systemd.tmpfiles.rules`), never activation scripts. Choose and explain:
   - `L+` to the store: declarative, read-only, needs rebuild.
   - `L+` to the checkout (out-of-store): edits apply instantly, not pinned in
     the generation.
   - `C`: copy once; the program can write, later repo changes are not applied.

   Removing a rule doesn't remove the file: tell Thilo to delete it.
6. **Accept imperative state** when nothing fits. Name the file the program
   writes and suggest a reference copy in the repo. No invented workarounds.

For steps 2–5, warn when program or NixOS updates may break a hand-written
config. If there is no clean solution without Home Manager, explain the options
and costs; Thilo decides. If step 5 grows large, you may mention hjem or
nix-maid as optional third-party tools, never add them yourself.
