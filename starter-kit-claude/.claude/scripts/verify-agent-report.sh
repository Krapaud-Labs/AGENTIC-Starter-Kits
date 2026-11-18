#!/usr/bin/env bash
set -euo pipefail
role="${1:-}"
agent_id="${2:-}"
report="${3:-}"
[ -n "$role" ] && [ -n "$agent_id" ] && [ -n "$report" ] || { echo "RAPPORT: rôle, identifiant et chemin requis" >&2; exit 1; }
[[ "$agent_id" =~ ^[A-Za-z0-9][A-Za-z0-9._-]{0,127}$ ]] || { echo "RAPPORT: identifiant invalide" >&2; exit 1; }
report_copy=""
safe_copy=""
cleanup() {
  [ -z "$report_copy" ] || rm -f "$report_copy"
  [ -z "$safe_copy" ] || rm -f "$safe_copy"
}
trap cleanup EXIT
if [ "$report" = "/dev/stdin" ]; then report_copy="$(mktemp)"; cat > "$report_copy"; report="$report_copy"; fi
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
kit_name="$(basename "$config" | sed 's/^\.//')"
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
root="$(cd "$root" && pwd -P)"
archive="$root/.$kit_name/reports/agents/$agent_id.md"
if [ ! -s "$report" ]; then
  report_copy="${report_copy:-$(mktemp)}"
  if python3 - "$root" ".$kit_name" "$agent_id.md" "$report_copy" <<'PY'
import os, stat, sys
from pathlib import Path

root, kit, name, target = sys.argv[1:]
directory = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW
try:
    root_fd = os.open(str(Path(root).resolve(strict=True)), directory)
    kit_fd = os.open(kit, directory, dir_fd=root_fd)
    reports_fd = os.open("reports", directory, dir_fd=kit_fd)
    agents_fd = os.open("agents", directory, dir_fd=reports_fd)
    source_fd = os.open(name, os.O_RDONLY | os.O_NOFOLLOW, dir_fd=agents_fd)
    if not stat.S_ISREG(os.fstat(source_fd).st_mode):
        raise OSError("archive is not a regular file")
    with os.fdopen(source_fd, "rb") as source, open(target, "wb") as output:
        output.write(source.read())
finally:
    for descriptor in (locals().get("agents_fd"), locals().get("reports_fd"), locals().get("kit_fd"), locals().get("root_fd")):
        if descriptor is not None:
            os.close(descriptor)
PY
  then
    report="$report_copy"
  else
    echo "RAPPORT: livrable absent ou vide pour $role@$agent_id" >&2
    exit 1
  fi
fi
[ -s "$report" ] || { echo "RAPPORT: livrable absent ou vide pour $role@$agent_id" >&2; exit 1; }
safe_copy="$(mktemp)"
python3 - "$script_dir" "$report" "$safe_copy" "$kit_name" <<'PY'
from pathlib import Path
import sys
sys.path.insert(0, sys.argv[1])
from report_security import sanitize, validate

source, target, kit = Path(sys.argv[2]), Path(sys.argv[3]), sys.argv[4]
safe = sanitize(source.read_text(encoding="utf-8"))
if not isinstance(safe, str):
    raise SystemExit("RAPPORT: format de texte invalide")
errors = validate({"schema_version": 1, "kit": kit, "project_id": "local-kit", "generated_at": "local", "findings": [{"report": safe}]})
if errors:
    raise SystemExit("RAPPORT: contenu sensible résiduel: " + ", ".join(errors))
target.write_text(safe, encoding="utf-8")
PY
report="$safe_copy"
grep -Eq '^agent_role:[[:space:]]*' "$report" || { echo "RAPPORT: agent_role manquant" >&2; exit 1; }
grep -Eq '^agent_id:[[:space:]]*' "$report" || { echo "RAPPORT: agent_id manquant" >&2; exit 1; }
grep -Eq '^status:[[:space:]]*(accepted|rework|blocked)$' "$report" || { echo "RAPPORT: status accepted, rework ou blocked requis" >&2; exit 1; }
grep -Eq '^scope:[[:space:]]*[^[:space:]].*' "$report" || { echo "RAPPORT: scope manquant" >&2; exit 1; }
grep -Eq '^evidence:[[:space:]]*[^[:space:]].*' "$report" || { echo "RAPPORT: evidence manquante" >&2; exit 1; }
grep -Eq '^next_action:[[:space:]]*[^[:space:]].*' "$report" || { echo "RAPPORT: next_action manquante" >&2; exit 1; }
actual_role="$(sed -n 's/^agent_role:[[:space:]]*//p' "$report" | head -1)"
actual_id="$(sed -n 's/^agent_id:[[:space:]]*//p' "$report" | head -1)"
[ "$actual_role" = "$role" ] || { echo "RAPPORT: rôle incohérent ($actual_role != $role)" >&2; exit 1; }
[ "$actual_id" = "$agent_id" ] || { echo "RAPPORT: identifiant incohérent ($actual_id != $agent_id)" >&2; exit 1; }
python3 - "$root" ".$kit_name" "$agent_id.md" "$agent_id" "$report" <<'PY'
import os, secrets, stat, sys
from pathlib import Path

root, kit, name, agent_id, source = sys.argv[1:]
directory = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW
no_follow = os.O_RDONLY | os.O_NOFOLLOW
def open_child(parent, component, create=False):
    if component in ("", ".", "..") or "/" in component:
        raise OSError("unsafe archive path component")
    if create:
        try:
            os.mkdir(component, mode=0o700, dir_fd=parent)
        except FileExistsError:
            pass
    return os.open(component, directory, dir_fd=parent)
def atomic_write(parent, filename, content):
    temporary = f".{filename}.{os.getpid()}.{secrets.token_hex(8)}.tmp"
    descriptor = os.open(temporary, os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW, 0o600, dir_fd=parent)
    try:
        view = memoryview(content)
        while view:
            view = view[os.write(descriptor, view):]
        os.fsync(descriptor)
    finally:
        os.close(descriptor)
    try:
        os.replace(temporary, filename, src_dir_fd=parent, dst_dir_fd=parent)
    finally:
        try:
            os.unlink(temporary, dir_fd=parent)
        except FileNotFoundError:
            pass

fds = []
try:
    root_fd = os.open(str(Path(root).resolve(strict=True)), directory); fds.append(root_fd)
    kit_fd = open_child(root_fd, kit); fds.append(kit_fd)
    reports_fd = open_child(kit_fd, "reports", create=True); fds.append(reports_fd)
    agents_fd = open_child(reports_fd, "agents", create=True); fds.append(agents_fd)
    data = Path(source).read_bytes()
    atomic_write(agents_fd, name, data)
    try:
        pending_fd = os.open("pending.tsv", no_follow, dir_fd=agents_fd)
    except FileNotFoundError:
        pending_fd = None
    if pending_fd is not None:
        fds.append(pending_fd)
        if not stat.S_ISREG(os.fstat(pending_fd).st_mode):
            raise OSError("pending list is not a regular file")
        with os.fdopen(os.dup(pending_fd), "rb") as pending_file:
            rows = pending_file.read().splitlines(keepends=True)
        filtered = b"".join(row for row in rows if row.split(b"\t", 1)[0].decode("utf-8", "replace") != agent_id)
        atomic_write(agents_fd, "pending.tsv", filtered)
except OSError as exc:
    raise SystemExit(f"RAPPORT: archive path rejected or write failed: {exc}")
finally:
    for descriptor in reversed(fds):
        os.close(descriptor)
PY
echo "Rapport spécialiste vérifié: $role@$agent_id"
