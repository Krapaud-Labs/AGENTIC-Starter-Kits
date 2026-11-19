#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  root="$(cd "$config/.." && pwd)"
fi
project_config="$root/.codex"
session_lock="$project_config/.session-start.lock"
lock_owner="$session_lock/pid"
for lock_attempt in $(seq 1 100); do
  if [ -d "$session_lock" ] && [ ! -s "$lock_owner" ]; then
    if lock_mtime="$(stat -f %m "$session_lock" 2>/dev/null || stat -c %Y "$session_lock" 2>/dev/null)" && [ $(( $(date +%s) - lock_mtime )) -gt 120 ]; then
      rmdir "$session_lock" 2>/dev/null || true
    fi
  elif [ -s "$lock_owner" ]; then
    lock_pid="$(cat "$lock_owner" 2>/dev/null || true)"
    if [ -n "$lock_pid" ] && ! kill -0 "$lock_pid" 2>/dev/null; then
      rmdir "$session_lock" 2>/dev/null || true
    fi
  fi
  if mkdir "$session_lock" 2>/dev/null; then
    printf '%s\n' "$$" > "$lock_owner"
    trap 'rmdir "$session_lock" 2>/dev/null || true' EXIT
    break
  fi
  sleep 0.05
  if [ "$lock_attempt" -eq 100 ]; then
    echo "KIT-SESSION: une autre session initialise déjà ce projet" >&2
    exit 4
  fi
done
if [ -x "$script_dir/archive-project-brief.sh" ]; then
  bash "$script_dir/archive-project-brief.sh"
fi
if [ ! -s "$project_config/RUNTIME-STATE.md" ] && [ -x "$script_dir/bootstrap-runtime-state.sh" ]; then
  bash "$script_dir/bootstrap-runtime-state.sh"
fi
entry="$root/AGENTS.md"
kit_version="$(sed -n 's/^kit_version = "\([^\"]*\)"/\1/p' "$config/KIT.toml")"
if [ -f "$entry" ] && grep -q '^<!-- ENTRYPOINT-CONTRACT:' "$entry"; then
  if [ -L "$entry" ]; then
    local_entry="$(mktemp "$root/.AGENTS.md.XXXXXX")"
    cp "$entry" "$local_entry"
    rm "$entry"
    mv "$local_entry" "$entry"
  fi
  sed -i.bak "s/^<!-- ENTRYPOINT-CONTRACT:.*-->$/<!-- ENTRYPOINT-CONTRACT: $kit_version -->/" "$entry"
  rm -f "$entry.bak"
fi
mode="$(sed -n 's/^kit_mode = "\([^"]*\)"/\1/p' "$root/.workspace.toml" 2>/dev/null || echo native)"
tool_status=0
bash "$script_dir/ensure-tools.sh" --bootstrap >/dev/null 2>"$project_config/.tool-bootstrap-error" || tool_status=$?
if [ "$tool_status" -eq 4 ]; then echo "KIT-SESSION: waiting-for-user" >&2; exit 4; elif [ "$tool_status" -ne 0 ]; then echo "KIT-SESSION: bootstrap des outils impossible" >&2; exit "$tool_status"; fi
rm -f "$project_config/.tool-bootstrap-error"
if [ -x "$script_dir/flush-kit-report-outbox.sh" ]; then
  bash "$script_dir/flush-kit-report-outbox.sh" >> "$project_config/kit-report-sync.log" 2>&1 || true
fi
status=0
verification_mode=remote-verified
bash "$script_dir/check-kit-update.sh" >/dev/null 2>"$project_config/.kit-update-error" || status=$?
if [ "$status" -ne 0 ]; then
  if [ "$status" -eq 3 ] && [ -x "$script_dir/sync-workspace-kit.sh" ]; then bash "$script_dir/sync-workspace-kit.sh"; status=0; verification_mode=remote-updated
  elif [ "$status" -eq 2 ]; then echo "KIT-SESSION: source distante indisponible; utilisation contrôlée du kit local" >&2; status=0; verification_mode=local-fallback
  else echo "KIT-SESSION: mise à jour requise ou vérification distante impossible" >&2; exit 1; fi
fi
if [ -s "$project_config/RUNTIME-STATE.md" ] && [ -x "$script_dir/normalize-runtime-state.sh" ]; then
  bash "$script_dir/normalize-runtime-state.sh" "$project_config/RUNTIME-STATE.md" >/dev/null
fi
bash "$script_dir/validate-agentic-contract.sh" >/dev/null
cached_kit_mtime="$(sed -n 's/^kit_mtime=//p' "$project_config/.session-kit-validated" 2>/dev/null | head -1 || true)"
cached_kit_hash="$(sed -n 's/^kit_sha256=//p' "$project_config/.session-kit-validated" 2>/dev/null | head -1 || true)"
printf 'kit_version=%s\nvalidated_at=%s\nmode=%s\n' "$(sed -n 's/^kit_version = "\([^"]*\)"/\1/p' "$config/KIT.toml")" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$mode" > "$project_config/.session-kit-validated"
manifest_hash="missing"
[ -f "$root/.workspace.toml" ] && manifest_hash="$(shasum -a 256 "$root/.workspace.toml" | awk '{print $1}')"
if stat -f %m "$config/KIT.toml" >/dev/null 2>&1; then kit_mtime="$(stat -f %m "$config/KIT.toml")"; else kit_mtime="$(stat -c %Y "$config/KIT.toml")"; fi
if [ "$kit_mtime" = "$cached_kit_mtime" ] && [ -n "$cached_kit_hash" ]; then
  kit_hash="$cached_kit_hash"
else
  kit_hash="$(find "$config" -type f ! -name 'RUNTIME-STATE.md' ! -name '*.log' ! -name '.session-kit-validated' | sort | while IFS= read -r file; do shasum -a 256 "$file"; done | shasum -a 256 | awk '{print $1}')"
fi
printf 'verification_mode=%s\nmanifest_sha256=%s\nkit_sha256=%s\n' "$verification_mode" "$manifest_hash" "$kit_hash" >> "$project_config/.session-kit-validated"
printf 'kit_mtime=%s\n' "$kit_mtime" >> "$project_config/.session-kit-validated"
if [ "$verification_mode" = "remote-updated" ]; then
  printf 'kit_update_requires_reload=true\nkit_update_reloaded=false\nkit_update_read_order=AGENTS.md,.codex/START-HERE.md,.codex/ORCHESTRATION.md,.codex/policies,.codex/skills,.codex/agents,.codex/models.toml,.codex/RUNTIME-STATE.md\n' >> "$project_config/.session-kit-validated"
else
  printf 'kit_update_requires_reload=false\nkit_update_reloaded=true\n' >> "$project_config/.session-kit-validated"
fi
rm -f "$project_config/.kit-update-error"
echo "KIT-SESSION: porte de démarrage validée"
