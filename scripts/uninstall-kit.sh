#!/usr/bin/env bash
set -euo pipefail
usage() { echo "Usage: $0 --target PATH [--apply]"; }
target=""
apply=false
while (($#)); do
  case "$1" in
    --target) [[ $# -ge 2 ]] || { usage >&2; exit 2; }; target="$2"; shift 2 ;;
    --apply) apply=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done
[[ -n "$target" ]] || { usage >&2; exit 2; }
target="$(cd -- "$target" 2>/dev/null && pwd)" || { echo "Target does not exist" >&2; exit 1; }
[[ "$target" != "/" && "$target" != "$HOME" ]] || { echo "Refusing broad target" >&2; exit 1; }
for item in .codex .claude; do
  if [[ -e "$target/$item" ]]; then
    if "$apply"; then rm -rf -- "$target/$item"; echo "removed $target/$item"; else echo "would remove $target/$item"; fi
  fi
done
if "$apply"; then echo "uninstall complete"; else echo "dry-run complete; pass --apply to remove"; fi
