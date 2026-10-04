#!/usr/bin/env bash
set -euo pipefail

for candidate in python3.13 python3.12 python3.11 python3 py; do
  command -v "$candidate" >/dev/null 2>&1 || continue
  if [ "$candidate" = "py" ]; then
    version="$(py -3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || true)"
    case "$version" in 3.11|3.12|3.13) exec py -3 "$@" ;; esac
  else
    version="$($candidate -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || true)"
    case "$version" in 3.11|3.12|3.13) exec "$candidate" "$@" ;; esac
  fi
done
echo "Python 3 requis. Installer Python 3.11 ou supérieur." >&2
exit 1
