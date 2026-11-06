#!/usr/bin/env python3
"""Validate the Codex/Claude, OS, shared-tool and release contract."""
from __future__ import annotations
import argparse
import platform
import re
import stat
import sys
from pathlib import Path

SEMVER_2 = re.compile(r"^2\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$")
SHARED_TOOLS = ("scripts/agentic_orchestration.py", "scripts/migrate_agentic_card.py", "scripts/audit_context_tokens.py")
KIT_FILES = ("starter-kit-codex/.codex/runtime_v2/core.py", "starter-kit-claude/.claude/policies/KIT-UPDATE-PAUSE-POLICY.md")
KIT_SCRIPTS = ("starter-kit-codex/.codex/scripts/pause-for-kit-update.sh", "starter-kit-codex/.codex/scripts/resume-kit-update.sh", "starter-kit-claude/.claude/scripts/pause-for-kit-update.sh", "starter-kit-claude/.claude/scripts/resume-kit-update.sh")

def check(root: Path, os_name: str | None = None) -> list[str]:
    failures = []
    version = root / "VERSION"
    if not version.is_file() or not SEMVER_2.fullmatch(version.read_text().strip()):
        failures.append("VERSION must contain SemVer 2.x")
    for relative in KIT_FILES + SHARED_TOOLS + KIT_SCRIPTS:
        if not (root / relative).is_file():
            failures.append(f"missing required file: {relative}")
    for relative in KIT_SCRIPTS:
        path = root / relative
        if path.is_file() and not (path.stat().st_mode & stat.S_IXUSR):
            failures.append(f"shell script is not executable: {relative}")
    if not (root / "docs/COMPATIBILITY-RELEASE-MATRIX.md").is_file():
        failures.append("missing compatibility and release matrix")
    uninstall = root / "scripts/uninstall-kit.sh"
    if not uninstall.is_file() or not (uninstall.stat().st_mode & stat.S_IXUSR):
        failures.append("missing executable uninstall control")
    if os_name and os_name.lower() not in {"darwin", "linux", "windows"}:
        failures.append(f"unsupported platform override: {os_name}")
    return failures

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--platform")
    args = parser.parse_args()
    detected = args.platform or platform.system().lower()
    failures = check(args.root.resolve(), detected)
    print(f"compatibility platform={detected} release=2.x")
    for failure in failures:
        print(f"FAIL: {failure}")
    if failures:
        return 1
    print("PASS: Codex/Claude, shared tools, OS contract, uninstall and release matrix")
    return 0

if __name__ == "__main__":
    sys.exit(main())
