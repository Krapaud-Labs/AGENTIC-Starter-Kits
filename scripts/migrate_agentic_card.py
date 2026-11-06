#!/usr/bin/env python3
"""Migrate an AGENTIC card from schema 1.x to 2.0 safely."""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path


class MigrationError(Exception):
    pass


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_card(path: Path) -> dict:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise MigrationError(f"invalid JSON: {exc}") from exc
    if not isinstance(data, dict):
        raise MigrationError("card must be a JSON object")
    version = str(data.get("schema_version", data.get("version", "")))
    if not version.startswith("1."):
        raise MigrationError(f"expected schema 1.x, found {version or 'missing'}")
    for field in ("id", "title"):
        if not isinstance(data.get(field), str) or not data[field].strip():
            raise MigrationError(f"missing required field: {field}")
    return data


def migrate(data: dict, source_checksum: str) -> dict:
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
    return {
        "schema_version": "2.0",
        "id": data["id"],
        "title": data["title"],
        "description": data.get("description", ""),
        "workflow": {
            "status": data.get("status", "Backlog"),
            "priority": data.get("priority", "P2"),
            "labels": list(data.get("labels", [])),
        },
        "execution": {
            "tasks": list(data.get("tasks", [])),
            "acceptance_criteria": list(data.get("acceptance_criteria", [])),
        },
        "evidence": list(data.get("evidence", [])),
        "migration": {
            "from_schema": str(data.get("schema_version", data.get("version"))),
            "migrated_at": now,
            "source_sha256": source_checksum,
        },
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("project", type=Path, help="isolated project directory")
    parser.add_argument("--dry-run", action="store_true", help="validate and report without changing files")
    parser.add_argument("--rollback", action="store_true", help="restore the most recent backup")
    args = parser.parse_args(argv)
    source = args.project / "agentic-card.json"
    backup = args.project / ".migration-backups" / "agentic-card.json"
    try:
        if not source.is_file():
            raise MigrationError(f"missing input: {source}")
        if args.rollback:
            if not backup.is_file():
                raise MigrationError(f"no backup available: {backup}")
            shutil.copy2(backup, source)
            print(json.dumps({"status": "rolled_back", "restored_sha256": sha256(source)}, indent=2))
            return 0
        original_checksum = sha256(source)
        migrated = migrate(read_card(source), original_checksum)
        if args.dry_run:
            print(json.dumps({"status": "dry_run", "would_write": str(source), "source_sha256": original_checksum, "target_schema": "2.0"}, indent=2))
            return 0
        backup.parent.mkdir(mode=0o700, exist_ok=True)
        with tempfile.NamedTemporaryFile("w", encoding="utf-8", dir=source.parent, delete=False) as stream:
            json.dump(migrated, stream, indent=2, ensure_ascii=False)
            stream.write("\n")
            temporary = Path(stream.name)
        shutil.copy2(source, backup)
        temporary.replace(source)
        print(json.dumps({"status": "migrated", "source_sha256": original_checksum, "backup": str(backup), "target_sha256": sha256(source)}, indent=2))
        return 0
    except MigrationError as exc:
        print(f"migration error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
