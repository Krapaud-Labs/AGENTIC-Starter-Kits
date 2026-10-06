#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
event="$(cat)"
id="$(printf '%s' "$event" | jq -r '.agent_id // "unknown"' 2>/dev/null || echo unknown)"
printf '%s | subagent_stop | id=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$id" >> "$root/.codex/runtime-events.log"
printf '{"systemMessage":"Sous-agent %s terminé. Vérifier son livrable, les fichiers touchés et la preuve indépendante avant de cocher sa tâche."}\n' "$id"
