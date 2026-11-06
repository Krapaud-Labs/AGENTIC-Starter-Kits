"""Deterministic, isolated chaos scenarios for AGENTIC 2.0 observability.

The harness never operates on the caller's checkout. Every scenario receives a
temporary workspace and emits only aggregate, non-identifying metrics.
"""
from __future__ import annotations

from dataclasses import dataclass, asdict
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import tempfile
import threading
import time
from typing import Callable


SCENARIOS = frozenset({"crash", "interruption", "network_unavailable", "slow_ci",
                       "git_index_locked", "concurrency", "resume"})


class TransientFault(RuntimeError):
    """A fault that may be retried safely."""


@dataclass(frozen=True)
class ChaosResult:
    scenario: str
    status: str
    attempts: int
    resumes: int
    duration_ms: int


def _anonymous_id(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()[:12]


class MetricsSink:
    """Append-only JSONL sink with atomic line writes and no raw identifiers."""

    def __init__(self, path: Path):
        self.path = path
        self._lock = threading.Lock()

    def write(self, result: ChaosResult) -> None:
        record = {"event_id": _anonymous_id(f"{result.scenario}:{result.attempts}:{result.resumes}"),
                  "observed_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
                  **asdict(result)}
        line = json.dumps(record, sort_keys=True) + "\n"
        self.path.parent.mkdir(parents=True, exist_ok=True)
        with self._lock:
            with self.path.open("a", encoding="utf-8") as stream:
                stream.write(line)
                stream.flush()


def _operation(scenario: str, state: dict[str, int]) -> None:
    if scenario in {"crash", "interruption", "network_unavailable", "git_index_locked"} and state["attempt"] == 1:
        raise TransientFault(scenario)
    if scenario == "slow_ci":
        time.sleep(0.001)
    state["completed"] += 1


def run_scenario(scenario: str, *, max_retries: int = 2, sink: MetricsSink | None = None) -> ChaosResult:
    if scenario not in SCENARIOS:
        raise ValueError(f"unknown scenario: {scenario}")
    started = time.monotonic()
    with tempfile.TemporaryDirectory(prefix="agentic-chaos-") as directory:
        workspace = Path(directory)
        state = {"attempt": 0, "completed": 0}
        # A lock is represented as a file in the isolated workspace only.
        if scenario == "git_index_locked":
            (workspace / "index.lock").write_text("simulated", encoding="utf-8")
        attempts = 0
        resumes = 0
        while True:
            attempts += 1
            state["attempt"] = attempts
            try:
                _operation(scenario, state)
                break
            except TransientFault:
                if attempts > max_retries + 1:
                    result = ChaosResult(scenario, "failed", attempts, resumes, int((time.monotonic() - started) * 1000))
                    if sink: sink.write(result)
                    return result
                resumes += 1
                # Recovery removes only the synthetic fault marker.
                if scenario == "git_index_locked":
                    (workspace / "index.lock").unlink(missing_ok=True)
        result = ChaosResult(scenario, "success", attempts, resumes, int((time.monotonic() - started) * 1000))
        if sink: sink.write(result)
        return result


def run_all(*, sink: MetricsSink | None = None, parallel: bool = False) -> list[ChaosResult]:
    if not parallel:
        return [run_scenario(name, sink=sink) for name in sorted(SCENARIOS)]
    results: list[ChaosResult] = []
    lock = threading.Lock()
    def worker(name: str) -> None:
        result = run_scenario(name, sink=sink)
        with lock: results.append(result)
    threads = [threading.Thread(target=worker, args=(name,)) for name in sorted(SCENARIOS)]
    for thread in threads: thread.start()
    for thread in threads: thread.join()
    return sorted(results, key=lambda item: item.scenario)
