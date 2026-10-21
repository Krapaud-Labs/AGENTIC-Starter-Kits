#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for kit in codex claude; do
  hidden="$root/starter-kit-$kit/.${kit}"
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/.${kit}/hooks" "$tmp/.${kit}/scripts"
  cp "$hidden/hooks/hook-runtime.sh" "$hidden/hooks/subagent-stop.sh" "$tmp/.${kit}/hooks/"
  cp "$hidden/scripts/verify-agent-report.sh" "$tmp/.${kit}/scripts/"
  git -C "$tmp" init -q
  event='{"agent_id":"agent-recovery","agent_role":"qa"}'
  pending_output="$(cd "$tmp" && printf '%s' "$event" | bash ".${kit}/hooks/subagent-stop.sh")"
  printf '%s' "$pending_output" | grep -q 'pending'
  test "$(wc -l < "$tmp/.${kit}/reports/agents/pending.tsv" | tr -d ' ')" -eq 1
  printf '%s\n' \
    'agent_role: qa' \
    'agent_id: agent-recovery' \
    'status: accepted' \
    'scope: recovery test' \
    'evidence: sandbox evidence' \
    'next_action: none' > "$tmp/report.md"
  (cd "$tmp" && bash ".${kit}/scripts/verify-agent-report.sh" qa agent-recovery "$tmp/report.md") >/dev/null
  test ! -s "$tmp/.${kit}/reports/agents/pending.tsv"
  rm -rf "$tmp"
done
echo "Récupération idempotente des rapports pending Codex/Claude: OK"
