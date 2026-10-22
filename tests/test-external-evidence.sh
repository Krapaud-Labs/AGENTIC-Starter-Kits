#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cat > "$tmp/valid.json" <<'JSON'
{"connectors":{"github":{"status":"real","evidence_id":"gh-readback-20261022-01","checked_at":"2099-10-22T10:00:00Z","source_sha":"0123456789abcdef0123456789abcdef01234567","resource_ref":"github:Krapaud-Labs/AGENTIC-Starter-Kits","read_back":true,"verification_method":"connector-readback"},"trello":{"status":"real","evidence_id":"trello-readback-20261022-01","checked_at":"2099-10-22T10:00:00Z","source_sha":"0123456789abcdef0123456789abcdef01234567","resource_ref":"trello:board/test-card","read_back":true,"verification_method":"connector-readback"},"browser":{"status":"real","evidence_id":"browser-readback-20261022-01","checked_at":"2099-10-22T10:00:00Z","source_sha":"0123456789abcdef0123456789abcdef01234567","resource_ref":"browser:https://example.invalid/test","read_back":true,"verification_method":"browser-readback"},"agents":{"status":"real","evidence_id":"agent-runtime-20261022-01","checked_at":"2099-10-22T10:00:00Z","source_sha":"0123456789abcdef0123456789abcdef01234567","resource_ref":"agent:run/01a1634e","read_back":true,"verification_method":"agent-runtime"}}}
JSON
python3 "$root/scripts/validate-external-evidence.py" "$tmp/valid.json" >/dev/null

cat > "$tmp/fake.json" <<'JSON'
{"connectors":{"github":{"status":"real","evidence_id":"gh-1","checked_at":"now","source_sha":"abc"},"trello":{"status":"simulated","evidence_id":"tr-1","checked_at":"now","source_sha":"abc"},"browser":{"status":"real","evidence_id":"br-1","checked_at":"now","source_sha":"abc"},"agents":{"status":"real","evidence_id":"ag-1","checked_at":"now","source_sha":"abc"}}}
JSON
if python3 "$root/scripts/validate-external-evidence.py" "$tmp/fake.json" >/dev/null 2>&1; then
  echo "ECHEC: une preuve simulée a été acceptée" >&2
  exit 1
fi

sed 's/"read_back":true/"read_back":false/' "$tmp/valid.json" > "$tmp/no-readback.json"
if python3 "$root/scripts/validate-external-evidence.py" "$tmp/no-readback.json" >/dev/null 2>&1; then
  echo "ECHEC: une preuve sans relecture a été acceptée" >&2
  exit 1
fi

if CONNECTOR_EVIDENCE_FILE="$tmp/valid.json" bash "$root/scripts/test-integration-preflight.sh" --require-real >/dev/null; then
  echo "external_evidence=passed"
else
  echo "ECHEC: preflight réel refusé" >&2
  exit 1
fi
