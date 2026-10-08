#!/usr/bin/env bash
set -euo pipefail

hook_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(git -C "$hook_root/../.." rev-parse --show-toplevel 2>/dev/null || (cd "$hook_root/../.." && pwd))"
event_log="$project_root/.claude/runtime-events.log"
max_log_bytes=1048576

rotate_log() {
  [ -f "$event_log" ] || return 0
  local size
  size="$(wc -c < "$event_log")"
  if [ "$size" -ge "$max_log_bytes" ]; then
    mv "$event_log" "$event_log.1"
    : > "$event_log"
  fi
}

log_event() {
  local line="$1"
  rotate_log
  local lock="$event_log.lock"
  if mkdir "$lock" 2>/dev/null; then
    printf '%s\n' "$line" >> "$event_log"
    rmdir "$lock"
  fi
}

run_with_timeout() {
  local seconds="$1"; shift
  if command -v timeout >/dev/null 2>&1; then timeout "$seconds" "$@"
  elif command -v gtimeout >/dev/null 2>&1; then gtimeout "$seconds" "$@"
  else "$@"
  fi
}
