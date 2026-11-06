"""Executable AGENTIC 2.0 orchestration contract.

The coordinator is deliberately small and deterministic: policy decisions are
made before delegation, budgets are shared with children, and reports contain
only sanitized logical evidence.
"""
from __future__ import annotations

from dataclasses import dataclass, field
import re
from typing import Any


class ContractViolation(ValueError):
    """Raised when an orchestration request is outside the contract."""


@dataclass(frozen=True)
class ModelSpec:
    name: str
    strengths: frozenset[str]
    max_context: int
    allowed_roles: frozenset[str]


@dataclass(frozen=True)
class RoleSpec:
    name: str
    capabilities: frozenset[str]
    allowed_models: frozenset[str]
    can_delegate: bool = False


@dataclass
class Limits:
    max_depth: int = 1
    max_children: int = 3
    max_steps: int = 40
    max_tokens: int = 50_000
    children_used: int = 0
    steps_used: int = 0
    tokens_used: int = 0

    def consume(self, *, tokens: int = 0, step: bool = True) -> None:
        if tokens < 0:
            raise ContractViolation("tokens must be non-negative")
        if step and self.steps_used + 1 > self.max_steps:
            raise ContractViolation("step budget exhausted")
        if self.tokens_used + tokens > self.max_tokens:
            raise ContractViolation("token budget exhausted")
        if step:
            self.steps_used += 1
        self.tokens_used += tokens


@dataclass(frozen=True)
class DelegationRequest:
    role: str
    model: str
    task: str
    requested_capabilities: frozenset[str] = frozenset()
    depth: int = 0
    tokens: int = 0


@dataclass
class OrchestrationReport:
    status: str
    role: str
    model: str
    task_id: str
    findings: list[dict[str, Any]] = field(default_factory=list)
    limits: dict[str, int] = field(default_factory=dict)


SECRET_RE = re.compile(r"(?i)(bearer\s+\S+|(?:api[_-]?key|token|password|secret)\s*[=:]\s*\S+)")


class Orchestrator:
    def __init__(self, roles: dict[str, RoleSpec], models: dict[str, ModelSpec], limits: Limits | None = None):
        self.roles, self.models, self.limits = roles, models, limits or Limits()

    def validate(self, request: DelegationRequest) -> None:
        role = self.roles.get(request.role)
        model = self.models.get(request.model)
        if role is None:
            raise ContractViolation("unknown role")
        if model is None:
            raise ContractViolation("unknown model")
        if request.depth > self.limits.max_depth:
            raise ContractViolation("delegation depth exceeded")
        if request.depth > 0 and not role.can_delegate:
            raise ContractViolation("role cannot delegate")
        if request.role not in model.allowed_roles or request.model not in role.allowed_models:
            raise ContractViolation("role/model combination is not allowed")
        if not request.requested_capabilities <= role.capabilities:
            raise ContractViolation("capability is not granted to role")
        if not request.task.strip():
            raise ContractViolation("task must not be empty")
        if SECRET_RE.search(request.task):
            raise ContractViolation("task contains sensitive material")

    def delegate(self, request: DelegationRequest) -> OrchestrationReport:
        self.validate(request)
        if self.limits.children_used >= self.limits.max_children:
            raise ContractViolation("child-agent budget exhausted")
        self.limits.consume(tokens=request.tokens)
        self.limits.children_used += 1
        return OrchestrationReport("accepted", request.role, request.model, f"task-{self.limits.children_used}", limits={
            "children_used": self.limits.children_used,
            "steps_used": self.limits.steps_used,
            "tokens_used": self.limits.tokens_used,
        })

    @staticmethod
    def safe_report(report: OrchestrationReport) -> dict[str, Any]:
        data = {"status": report.status, "role": report.role, "model": report.model,
                "task_id": report.task_id, "findings": report.findings, "limits": report.limits}
        text = repr(data)
        if SECRET_RE.search(text) or "/Users/" in text or "\\Users\\" in text:
            raise ContractViolation("report contains sensitive material")
        return data


DEFAULT_ROLES = {
    "coordinator": RoleSpec("coordinator", frozenset({"orchestrate", "review"}), frozenset({"reasoning"}), True),
    "security": RoleSpec("security", frozenset({"security-audit", "review"}), frozenset({"reasoning"})),
    "reporter": RoleSpec("reporter", frozenset({"report"}), frozenset({"compact"})),
}
DEFAULT_MODELS = {
    "reasoning": ModelSpec("reasoning", frozenset({"security", "planning"}), 100_000, frozenset({"coordinator", "security"})),
    "compact": ModelSpec("compact", frozenset({"reporting"}), 32_000, frozenset({"reporter"})),
}
