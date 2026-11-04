#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
state="${1:-$(cd "$script_dir/.." && pwd)/RUNTIME-STATE.md}"
[ -s "$state" ] || { echo "RUNTIME: fichier absent" >&2; exit 1; }
tmp="$state.normalize.$$"
input="$state.normalize-input.$$"
cp "$state" "$input"
if ! grep -Eq '^- native_goal_status:' "$input"; then
  goal_status="$(sed -n 's/^- goal_status:[[:space:]]*//p' "$input" | head -1)"
  native_goal_id="$(sed -n 's/^- native_goal_id:[[:space:]]*//p' "$input" | head -1)"
  case "$goal_status" in
    active|running) native_status=active ;;
    blocked) native_status=blocked ;;
    paused) native_status=paused ;;
    *) [ -n "$native_goal_id" ] && [ "$native_goal_id" != "none" ] && native_status=active || native_status=unavailable ;;
  esac
  printf '%s\n' "- native_goal_status: $native_status" >> "$input"
fi
if ! grep -Eq '^- next_action:[[:space:]]*[^[:space:]].*' "$input"; then
  printf '%s\n' '- next_action: resume-after-runtime-reconciliation' >> "$input"
fi
awk '
  /^- [A-Za-z0-9_]+:/ { key=$2; sub(/:$/, "", key); count[key]++; last[key]=NR }
  { lines[NR]=$0 }
  END {
    for (i=1; i<=NR; i++) {
      if (lines[i] ~ /^- [A-Za-z0-9_]+:/) {
        key=lines[i]; sub(/^- /, "", key); sub(/:.*/, "", key)
        if (count[key] > 1 && last[key] != i) continue
      }
      print lines[i]
    }
  }
' "$input" > "$tmp"
rm -f "$input"
if cmp -s "$state" "$tmp"; then
  rm -f "$tmp"
  printf 'RUNTIME: état déjà canonique\n'
  exit 0
fi
backup="$state.backup-$(date -u '+%Y%m%dT%H%M%SZ')"
cp "$state" "$backup"
mv "$tmp" "$state"
bash "$script_dir/validate-runtime-schema.sh" "$state"
printf 'RUNTIME: état canonisé, sauvegarde=%s\n' "$backup"
