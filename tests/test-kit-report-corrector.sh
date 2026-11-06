#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for kit in codex claude; do
  hidden=".$kit"
  source="$root/starter-kit-$kit/$hidden"
  target="$tmp/$kit/$hidden"
  mkdir -p "$target/scripts"
  cp "$source/RUNTIME-STATE.md" "$target/RUNTIME-STATE.md"
  cp "$source/scripts/auto-remediate-kit-report.sh" "$target/scripts/auto-remediate-kit-report.sh"
  cp "$source/scripts/reconcile-runtime.sh" "$target/scripts/reconcile-runtime.sh"
  cp "$source/scripts/validate-runtime-schema.sh" "$target/scripts/validate-runtime-schema.sh"
  chmod +x "$target/scripts"/*.sh
  sed -i.bak \
    -e 's/^- native_goal_status: .*/- native_goal_status: active/' \
    -e 's/^- goal_status: .*/- goal_status: active/' \
    -e 's/^- required_action_status: .*/- required_action_status: none/' \
    -e 's/^- goal_budget: .*/- goal_budget: 100000/' \
    "$target/RUNTIME-STATE.md"
  rm -f "$target/RUNTIME-STATE.md.bak"
  output="$(cd "$tmp/$kit" && bash "$hidden/scripts/auto-remediate-kit-report.sh")"
  printf '%s\n' "$output" | grep -Fq 'Correction locale appliquée'
  sed -i.bak 's/^- pending_request_id: .*/- pending_request_id: pending-test/' "$target/RUNTIME-STATE.md"
  if (cd "$tmp/$kit" && bash "$hidden/scripts/auto-remediate-kit-report.sh") >/dev/null 2>&1; then
    echo "ÉCHEC: une demande utilisateur pending a été auto-corrigée pour $kit" >&2
    exit 1
  fi
done

echo 'Correcteur local des rapports Codex/Claude: OK'
