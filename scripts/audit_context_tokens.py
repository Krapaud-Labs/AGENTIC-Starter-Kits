#!/usr/bin/env python3
"""Audit indicatif des coûts de contexte des documents d'instructions."""
from __future__ import annotations
import argparse
from collections import defaultdict
from pathlib import Path
import re
import sys

SOFT_CHARS = 16_000
HARD_CHARS = 32_000
MIN_DUPLICATE_CHARS = 120
WIDE_REFERENCE = re.compile(r"(?:read|load|include|inspect|review|consult)\s+(?:all|every|the entire)\s+(?:files|folder|directory|repository|repo|codebase)", re.I)

def documents(root: Path) -> list[Path]:
    paths = []
    for kit in sorted(root.glob("starter-kit-*")):
        for path in kit.rglob("*.md"):
            if any(part in {"node_modules", ".git", "vendor"} for part in path.parts):
                continue
            if {".codex", ".claude", ".agents"}.intersection(path.parts) or path.name in {"AGENTS.md", "CLAUDE.md"}:
                paths.append(path)
    return sorted(paths)

def paragraphs(content: str) -> set[str]:
    return {re.sub(r"\s+", " ", block).strip() for block in re.split(r"\n\s*\n", content) if len(re.sub(r"\s+", " ", block).strip()) >= MIN_DUPLICATE_CHARS}

def audit(root: Path, strict: bool = False) -> tuple[list[str], bool]:
    files = documents(root)
    if not files:
        return ["Aucun document d'instructions trouvé sous starter-kit-*"], False
    messages: list[str] = []
    owners: dict[str, list[Path]] = defaultdict(list)
    failed = False
    for path in files:
        content = path.read_text(encoding="utf-8")
        chars = len(content)
        relative = path.relative_to(root)
        if chars > HARD_CHARS:
            messages.append(f"OVER HARD LIMIT: {relative} - {chars} caracteres (~{(chars + 3) // 4} tokens)")
            failed = True
        elif chars > SOFT_CHARS:
            messages.append(f"REVIEW: {relative} - {chars} caracteres (~{(chars + 3) // 4} tokens)")
            if strict:
                failed = True
        for paragraph in paragraphs(content):
            owners[paragraph].append(relative)
        for line_no, line in enumerate(content.splitlines(), 1):
            if WIDE_REFERENCE.search(line):
                messages.append(f"REVIEW: {relative}:{line_no} - chargement de contexte trop large")
                if strict:
                    failed = True
    for paths in owners.values():
        unique = sorted(set(paths))
        if len(unique) > 1:
            messages.append("REVIEW: paragraphe duplique dans " + ", ".join(map(str, unique)))
            if strict:
                failed = True
    messages.append("Estimation indicative uniquement: caracteres divises par quatre")
    return messages, failed

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", nargs="?", type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument("--strict", action="store_true", help="échoue aussi sur les alertes REVIEW")
    args = parser.parse_args()
    messages, failed = audit(args.root.resolve(), strict=args.strict)
    print("\n".join(messages))
    return 1 if failed else 0

if __name__ == "__main__":
    sys.exit(main())
