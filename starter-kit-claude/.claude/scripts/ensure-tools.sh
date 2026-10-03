#!/usr/bin/env bash
set -euo pipefail
state_dir="${AGENTIC_TOOLS_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/agentic-starter-kit}"
mkdir -p "$state_dir"
log_file="$state_dir/tools.log"
failed=0
for tool in "${@:-git rg jq gh shellcheck}"; do
  path="$(command -v "$tool" 2>/dev/null || true)"
  if [ -z "$path" ]; then
    case "$tool" in
      rg|jq|gh|shellcheck) command -v brew >/dev/null 2>&1 && brew install "$tool" >>"$log_file" 2>&1 || { command -v apt-get >/dev/null 2>&1 && sudo apt-get update >>"$log_file" 2>&1 && sudo apt-get install -y "$tool" >>"$log_file" 2>&1; } || true ;;
    esac
    path="$(command -v "$tool" 2>/dev/null || true)"
  fi
  [ -n "$path" ] && printf '%s\t%s\t%s\n' "$tool" "$path" "$($tool --version 2>&1 | head -1 || true)" | tee -a "$log_file" || { echo "Outil indisponible: $tool" >&2; failed=1; }
done
exit "$failed"
