#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for kit in codex claude; do
  hidden=".${kit}"
  source="$root/starter-kit-$kit/$hidden"
  project="$tmp/$kit"
  mkdir -p "$project/$hidden"
  git init -q "$project"
  git -C "$project" config user.email sandbox@example.invalid
  git -C "$project" config user.name sandbox
  printf 'existing project data\n' > "$project/KEEP-ME.txt"
  printf '.codex/\nAGENTS.md\n' > "$project/.gitignore"
  cp -R "$source/." "$project/$hidden/"
  [ "$kit" = codex ] && cp "$root/starter-kit-codex/AGENTS.md" "$project/AGENTS.md" || cp "$root/starter-kit-claude/CLAUDE.md" "$project/CLAUDE.md"
  rm -f "$project/$hidden/RUNTIME-STATE.md" "$project/$hidden/project-profile.toml" "$project/$hidden/PROJECT-BRIEF.md"

  bash "$project/$hidden/scripts/init-project.sh" --updates off >/dev/null
  if [ -d "$project/docs" ]; then
    before="$(find "$project/docs" -type f -print | sort | shasum -a 256 | awk '{print $1}')"
  else
    before=empty-docs-tree
  fi
  bash "$project/$hidden/scripts/init-project.sh" --updates off >/dev/null
  if [ -d "$project/docs" ]; then
    after="$(find "$project/docs" -type f -print | sort | shasum -a 256 | awk '{print $1}')"
  else
    after=empty-docs-tree
  fi
  test "$before" = "$after"
  test "$(cat "$project/KEEP-ME.txt")" = "existing project data"

  bash "$project/$hidden/scripts/bootstrap-runtime-state.sh" >/dev/null
  bash "$project/$hidden/scripts/normalize-runtime-state.sh" "$project/$hidden/RUNTIME-STATE.md" >/dev/null
  bash "$project/$hidden/scripts/validate-runtime-schema.sh" "$project/$hidden/RUNTIME-STATE.md" >/dev/null

  perl -0pi -e 's/^- native_goal_status:.*$/- native_goal_status: unavailable/m; s/^- native_goal_id:.*$/- native_goal_id: active-goal-test/m; s/^- goal_status:.*$/- goal_status: active/m; s/^- next_action:.*$/- next_action: /m' "$project/$hidden/RUNTIME-STATE.md"
  bash "$project/$hidden/scripts/normalize-runtime-state.sh" "$project/$hidden/RUNTIME-STATE.md" >/dev/null
  (cd "$project" && bash "$hidden/scripts/reconcile-runtime.sh") >/dev/null
  grep -q '^- native_goal_status: active$' "$project/$hidden/RUNTIME-STATE.md"
  grep -q '^- execution_status: running$' "$project/$hidden/RUNTIME-STATE.md"
  grep -q '^- next_action: resume-after-runtime-reconciliation$' "$project/$hidden/RUNTIME-STATE.md"
done

echo "Scénarios initialisation et reprise Codex/Claude: OK"
