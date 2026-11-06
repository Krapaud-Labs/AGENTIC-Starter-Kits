#!/usr/bin/env python3
"""Sanitize and validate untrusted kit reports before publication."""
from __future__ import annotations
import argparse, json, re, sys
from pathlib import Path
from typing import Any

REDACTIONS = [
    (re.compile(r"(?i)\b(?:sk|gh[pousr]|xox[baprs]-)[A-Za-z0-9_-]{8,}\b"), "[REDACTED_TOKEN]"),
    (re.compile(r"(?i)\b(?:bearer\s+[^\s,;]+|token|api[_ -]?key|secret|password)\s*[:=]?\s*[^\s,;]+"), "[REDACTED_CREDENTIAL]"),
    (re.compile(r"(?i)-----BEGIN [A-Z ]+-----.*?-----END [A-Z ]+-----"), "[REDACTED_KEY]"),
    (re.compile(r"(?<![\w.-])/(?:Users|home|private|var|tmp)/[^\s\n`\"]+"), "[REDACTED_PATH]"),
    (re.compile(r"(?i)\b[\w.+-]+@[\w.-]+\.[a-z]{2,}\b"), "[REDACTED_EMAIL]"),
]
FORBIDDEN = [re.compile(r"(?i)\b(?:sk-[A-Za-z0-9]|gh[pousr]_[A-Za-z0-9]|xox[baprs]-)"), re.compile(r"(?i)\b(?:bearer|api[_ -]?key|password|secret)\b\s*(?:[:=]\s*)?\S+"), re.compile(r"-----BEGIN [A-Z ]+-----"), re.compile(r"(?<![\w.-])/(?:Users|home|private)/"), re.compile(r"(?i)\b[\w.+-]+@[\w.-]+\.[a-z]{2,}\b")]

def sanitize(value: Any) -> Any:
    if isinstance(value, dict): return {str(k): sanitize(v) for k, v in value.items()}
    if isinstance(value, list): return [sanitize(v) for v in value]
    if isinstance(value, str):
        for pattern, replacement in REDACTIONS: value = pattern.sub(replacement, value)
    return value

def validate(report: Any) -> list[str]:
    if not isinstance(report, dict): return ["report must be an object"]
    errors = [f"missing field: {field}" for field in sorted({"schema_version", "kit", "project_id", "generated_at", "findings"} - report.keys())]
    if report.get("kit") not in {"codex", "claude"}: errors.append("kit must be codex or claude")
    if not isinstance(report.get("findings"), list): errors.append("findings must be a list")
    text = json.dumps(report, ensure_ascii=False)
    errors.extend(f"forbidden sensitive value pattern: {p.pattern}" for p in FORBIDDEN if p.search(text))
    return errors

def build_report(kit: str, project_id: str, findings: list[dict[str, Any]], generated_at: str) -> dict[str, Any]:
    return sanitize({"schema_version": 1, "kit": kit, "project_id": project_id, "generated_at": generated_at, "findings": findings})

def main() -> int:
    parser = argparse.ArgumentParser(); parser.add_argument("input", type=Path); parser.add_argument("output", type=Path); args = parser.parse_args()
    try:
        raw = json.loads(args.input.read_text(encoding="utf-8")); report = build_report(raw["kit"], raw["project_id"], raw["findings"], raw["generated_at"])
    except (OSError, json.JSONDecodeError, KeyError, TypeError) as exc:
        print(f"REPORT_SECURITY: input rejected: {exc}", file=sys.stderr); return 2
    errors = validate(report)
    if errors:
        print("\n".join(f"REPORT_SECURITY: {e}" for e in errors), file=sys.stderr); return 1
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"); return 0

if __name__ == "__main__": raise SystemExit(main())
