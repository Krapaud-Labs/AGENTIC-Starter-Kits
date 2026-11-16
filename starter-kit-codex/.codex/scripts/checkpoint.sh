#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
state="$config/RUNTIME-STATE.md"
events="$config/runtime-events.log"
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <étape> <statut> <message>"
  exit 2
fi
stage="$1"
status="$2"
shift 2
message="$*"
case "$stage" in intake|questionnaire|onboarding|conception|planning|implementation|validation|audit|delivery|maintenance|blocked) ;; *) echo "Étape invalide: $stage"; exit 2 ;; esac
case "$status" in started|completed|failed|blocked|waiting|resumed) ;; *) echo "Statut invalide: $status"; exit 2 ;; esac
now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
[ -f "$state" ] || { echo "ECHEC CHECKPOINT: RUNTIME-STATE.md absent" >&2; exit 1; }
runtime_status=running
case "$status" in completed) runtime_status=complete;; blocked) runtime_status=blocked;; waiting) runtime_status=waiting-ci;; failed) runtime_status=needs-review;; esac
python3 - "$state" "$events" "$now" "$stage" "$status" "$runtime_status" "$message" <<'PY'
from pathlib import Path
import os
import stat
import sys

state_path, events_path, now, stage, status, runtime_status, message = sys.argv[1:]
# Runtime fields are single-line; preserve user text literally without treating it
# as Perl, sed, or shell source. Keep a visible marker for embedded newlines.
single_line = " ".join(message.replace("\\r", "\\n").splitlines())
state = Path(state_path)
try:
    mode = stat.S_IMODE(state.stat().st_mode)
except FileNotFoundError:
    mode = 0o600
content = state.read_text(encoding="utf-8")
replacements = {
    "- Dernière mise à jour : ": f"- Dernière mise à jour : {now}",
    "- Étape : ": f"- Étape : {stage}",
    "- Dernière action réalisée : ": f"- Dernière action réalisée : {single_line}",
    "- execution_status: ": f"- execution_status: {runtime_status}",
    "- current_action: ": f"- current_action: {single_line}",
    "- last_observable_evidence: ": f"- last_observable_evidence: {now} | {single_line}",
}
lines = content.splitlines()
for prefix, replacement in replacements.items():
    for index, line in enumerate(lines):
        if line.startswith(prefix):
            lines[index] = replacement
            break
    else:
        raise SystemExit(f"ECHEC CHECKPOINT: champ runtime absent: {prefix}")
temporary = state.with_name(state.name + f".tmp.{os.getpid()}")
temporary.write_text("\n".join(lines) + "\n", encoding="utf-8")
os.chmod(temporary, mode)
temporary.replace(state)
with Path(events_path).open("a", encoding="utf-8") as events:
    events.write(f"{now} | stage={stage} | status={status} | message={single_line}\n")
PY
echo "Checkpoint enregistré: $stage/$status"
