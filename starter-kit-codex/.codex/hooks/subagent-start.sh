#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
event="$(cat)"
id="$(printf '%s' "$event" | jq -r '.agent_id // "unknown"' 2>/dev/null || echo unknown)"
type="$(printf '%s' "$event" | jq -r '.agent_type // "unknown"' 2>/dev/null || echo unknown)"
printf '%s | subagent_start | id=%s | type=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$id" "$type" >> "$root/.codex/runtime-events.log"
printf '{"systemMessage":"Sous-agent enregistré avec identifiant réel %s et type %s. Son périmètre et son livrable doivent être vérifiés par le Coordinateur."}\n' "$id" "$type"
