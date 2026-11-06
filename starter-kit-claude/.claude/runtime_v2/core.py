"""Small, deterministic runtime state machine with safe recovery primitives."""

from __future__ import annotations

from dataclasses import dataclass, replace
from enum import Enum
from threading import RLock
from time import monotonic
from typing import Callable, Optional


class RuntimeStatus(str, Enum):
    IDLE = "idle"
    RUNNING = "running"
    CANCELLING = "cancelling"
    CANCELLED = "cancelled"
    SUCCEEDED = "succeeded"
    FAILED = "failed"


class InvalidTransition(RuntimeError):
    pass


class CancellationRequested(RuntimeError):
    pass


class LockUnavailable(RuntimeError):
    pass


@dataclass(frozen=True)
class RuntimeState:
    run_id: str
    status: RuntimeStatus = RuntimeStatus.IDLE
    revision: int = 0
    operation_id: Optional[str] = None
    result: object = None
    error: Optional[str] = None


@dataclass(frozen=True)
class _Lease:
    owner: str
    token: str
    expires_at: float


class Runtime:
    """Thread-safe state machine; all mutations produce a new canonical state."""

    _allowed = {
        RuntimeStatus.IDLE: {RuntimeStatus.RUNNING},
        RuntimeStatus.RUNNING: {
            RuntimeStatus.CANCELLING,
            RuntimeStatus.SUCCEEDED,
            RuntimeStatus.FAILED,
        },
        RuntimeStatus.CANCELLING: {RuntimeStatus.CANCELLED},
        RuntimeStatus.CANCELLED: {RuntimeStatus.RUNNING},
        RuntimeStatus.SUCCEEDED: set(),
        RuntimeStatus.FAILED: {RuntimeStatus.RUNNING},
    }

    def __init__(self, run_id: str, *, clock: Callable[[], float] = monotonic):
        self._lock = RLock()
        self._clock = clock
        self._state = RuntimeState(run_id=run_id)
        self._operations: dict[str, RuntimeState] = {}
        self._lease: Optional[_Lease] = None

    @property
    def state(self) -> RuntimeState:
        with self._lock:
            return self._state

    def _transition(self, status: RuntimeStatus, *, operation_id: str | None = None,
                    result: object = None, error: str | None = None) -> RuntimeState:
        if status not in self._allowed[self._state.status]:
            raise InvalidTransition(f"{self._state.status.value} -> {status.value}")
        self._state = replace(
            self._state, status=status, revision=self._state.revision + 1,
            operation_id=operation_id, result=result, error=error,
        )
        return self._state

    def start(self, operation_id: str) -> RuntimeState:
        with self._lock:
            previous = self._operations.get(operation_id)
            if previous is not None:
                return previous
            state = self._transition(RuntimeStatus.RUNNING, operation_id=operation_id)
            self._operations[operation_id] = state
            return state

    def finish(self, operation_id: str, result: object = None) -> RuntimeState:
        with self._lock:
            previous = self._operations.get(operation_id)
            if previous is not None and previous.status == RuntimeStatus.SUCCEEDED:
                return previous
            if self._state.operation_id != operation_id:
                raise InvalidTransition("operation is not the active run")
            state = self._transition(RuntimeStatus.SUCCEEDED, operation_id=operation_id, result=result)
            self._operations[operation_id] = state
            return state

    def fail(self, operation_id: str, error: str) -> RuntimeState:
        with self._lock:
            if self._state.operation_id != operation_id:
                raise InvalidTransition("operation is not the active run")
            state = self._transition(RuntimeStatus.FAILED, operation_id=operation_id, error=error)
            self._operations[operation_id] = state
            return state

    def cancel(self, operation_id: str) -> RuntimeState:
        with self._lock:
            if self._state.operation_id != operation_id:
                raise InvalidTransition("operation is not the active run")
            if self._state.status == RuntimeStatus.CANCELLED:
                return self._state
            return self._transition(RuntimeStatus.CANCELLING, operation_id=operation_id)

    def checkpoint(self, operation_id: str) -> None:
        with self._lock:
            if self._state.operation_id == operation_id and self._state.status in {
                RuntimeStatus.CANCELLING, RuntimeStatus.CANCELLED,
            }:
                if self._state.status == RuntimeStatus.CANCELLING:
                    self._transition(RuntimeStatus.CANCELLED, operation_id=operation_id)
                raise CancellationRequested(operation_id)

    def acquire(self, owner: str, token: str, ttl: float) -> None:
        with self._lock:
            now = self._clock()
            if self._lease and self._lease.expires_at > now and self._lease.owner != owner:
                raise LockUnavailable("runtime lock is held")
            self._lease = _Lease(owner, token, now + ttl)

    def release(self, owner: str, token: str) -> None:
        with self._lock:
            if self._lease and (self._lease.owner, self._lease.token) == (owner, token):
                self._lease = None

    def recover_expired_lock(self) -> bool:
        with self._lock:
            if self._lease and self._lease.expires_at <= self._clock():
                self._lease = None
                return True
            return False
