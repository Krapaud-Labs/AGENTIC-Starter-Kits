#!/usr/bin/env python3
"""Validate a connector evidence manifest without exposing credentials."""

from __future__ import annotations

import json
import re
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

REQUIRED = {"github", "trello", "browser", "agents"}
SECRET = re.compile(r"(token|secret|password|authorization|cookie|bearer|private[_-]?key)", re.I)
SHA = re.compile(r"^[0-9a-f]{40}$")
EVIDENCE_ID = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._/-]{2,127}$")
PLACEHOLDER = re.compile(r"^(now|test|fake|dummy|abc|unknown|null|[-_]?\d+)$", re.I)


def fail(message: str) -> "NoReturn":
    print(f"EVIDENCE: invalid: {message}", file=sys.stderr)
    raise SystemExit(2)


def main() -> int:
    if len(sys.argv) != 2:
        print(f"usage: {sys.argv[0]} <evidence.json>", file=sys.stderr)
        return 2
    path = Path(sys.argv[1])
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(str(exc))
    if not isinstance(document, dict) or not isinstance(document.get("connectors"), dict):
        fail("connectors object missing")
    connectors = document["connectors"]
    if set(connectors) != REQUIRED:
        fail(f"connectors must be exactly {sorted(REQUIRED)}")
    for name, record in connectors.items():
        if not isinstance(record, dict):
            fail(f"{name} record must be an object")
        if record.get("status") != "real":
            fail(f"{name} is not real")
        for key in ("evidence_id", "checked_at", "source_sha"):
            value = record.get(key)
            if not isinstance(value, str) or not value.strip():
                fail(f"{name}.{key} missing")
        if not EVIDENCE_ID.fullmatch(record["evidence_id"]) or PLACEHOLDER.fullmatch(record["evidence_id"]):
            fail(f"{name}.evidence_id is not a real reference")
        if not SHA.fullmatch(record["source_sha"]):
            fail(f"{name}.source_sha must be a full Git SHA")
        try:
            checked_at = datetime.fromisoformat(record["checked_at"].replace("Z", "+00:00"))
        except ValueError:
            fail(f"{name}.checked_at is not ISO-8601")
        if checked_at.tzinfo is None:
            fail(f"{name}.checked_at must include a timezone")
        if datetime.now(timezone.utc) - checked_at > timedelta(minutes=10):
            fail(f"{name} evidence is expired")
        if PLACEHOLDER.fullmatch(str(record.get("resource_ref", ""))) or not record.get("resource_ref"):
            fail(f"{name}.resource_ref must identify the observed remote resource")
        if record.get("read_back") is not True:
            fail(f"{name}.read_back must be true")
        if record.get("verification_method") not in {"connector-readback", "browser-readback", "agent-runtime"}:
            fail(f"{name}.verification_method is invalid")
        if SECRET.search(json.dumps(record, ensure_ascii=False)):
            fail(f"{name} contains a sensitive field")
    print("EVIDENCE: valid connectors=github,trello,browser,agents")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
