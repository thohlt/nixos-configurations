# Flags package list items without a "# no NixOS module" comment.
# Relies on nixfmt's one-item-per-line layout.
FNR == 1 { inlist = 0; prev = "" }
inlist && /^[[:space:]]*\]/ { inlist = 0 }
inlist {
  line = $0
  sub(/^[[:space:]]+/, "", line)
  if (line != "" && line !~ /^#/ && $0 !~ /# no NixOS module/ && prev !~ /^[[:space:]]*#.*no NixOS module/) {
    printf "%s:%d: package without \"# no NixOS module\" comment: %s\n", FILENAME, FNR, line > "/dev/stderr"
    bad = 1
  }
}
# One-line list: `packages = [ pkgs.foo ];`
/(systemPackages|[^a-zA-Z]packages)[[:space:]]*=.*\[.*[^[:space:]].*\]/ {
  if ($0 !~ /\[[[:space:]]*\]/ && $0 !~ /# no NixOS module/ && prev !~ /^[[:space:]]*#.*no NixOS module/) {
    printf "%s:%d: package without \"# no NixOS module\" comment: %s\n", FILENAME, FNR, $0 > "/dev/stderr"
    bad = 1
  }
}
/(systemPackages|[^a-zA-Z]packages)[[:space:]]*=.*\[[[:space:]]*$/ { inlist = 1 }
{ prev = $0 }
END { exit bad }
