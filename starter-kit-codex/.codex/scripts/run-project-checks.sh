#!/usr/bin/env bash
set -euo pipefail

mode="preview"
if [ "${1:-}" = "--execute" ]; then mode="execute"; fi
if [ "${1:-}" != "" ] && [ "${1:-}" != "--execute" ]; then echo "Usage: $0 [--execute]"; exit 2; fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
source "$script_dir/tool-env.sh"

if [ "$mode" = "execute" ]; then
  bash "$script_dir/security-baseline.sh" --execute
else
  bash "$script_dir/security-baseline.sh"
fi

"$script_dir/python.sh" - "$config/project-profile.toml" "$root" "$mode" <<'PY'
import pathlib, subprocess, sys, tomllib
profile = pathlib.Path(sys.argv[1])
root = pathlib.Path(sys.argv[2])
mode = sys.argv[3]
commands = tomllib.loads(profile.read_text()).get('commands', {})
failed = False
for name in ('install', 'lint', 'test', 'build'):
    command = commands.get(name, '').strip()
    if not command:
        print(f'SKIP: {name} non configuré')
        continue
    print(f'CHECK: {name}: {command}')
    if mode == 'execute':
        result = subprocess.run(command, shell=True, cwd=root)
        if result.returncode:
            failed = True
            print(f'ECHEC: {name}: {result.returncode}')
if failed: raise SystemExit(1)
PY
