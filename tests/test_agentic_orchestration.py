import sys
from pathlib import Path
import unittest

sys.path.insert(0, str(Path(__file__).parents[1] / "scripts"))
from agentic_orchestration import (ContractViolation, DelegationRequest, Limits, Orchestrator,
                                   DEFAULT_MODELS, DEFAULT_ROLES)


class AgenticOrchestrationTests(unittest.TestCase):
    def setUp(self):
        self.o = Orchestrator(DEFAULT_ROLES, DEFAULT_MODELS, Limits(max_children=2, max_tokens=10))

    def test_valid_specialized_delegation_selects_allowed_model(self):
        report = self.o.delegate(DelegationRequest("security", "reasoning", "audit auth", frozenset({"security-audit"}), tokens=3))
        self.assertEqual("accepted", report.status)
        self.assertEqual("reasoning", report.model)

    def test_rejects_wrong_model_and_ungranted_capability(self):
        with self.assertRaises(ContractViolation):
            self.o.delegate(DelegationRequest("security", "compact", "audit auth"))
        with self.assertRaises(ContractViolation):
            self.o.delegate(DelegationRequest("reporter", "compact", "audit", frozenset({"security-audit"})))

    def test_rejects_recursive_or_unauthorized_delegation(self):
        with self.assertRaisesRegex(ContractViolation, "depth"):
            self.o.delegate(DelegationRequest("coordinator", "reasoning", "child", depth=2))
        with self.assertRaisesRegex(ContractViolation, "cannot delegate"):
            self.o.delegate(DelegationRequest("security", "reasoning", "child", depth=1))

    def test_shared_child_and_token_limits_are_enforced(self):
        for _ in range(2):
            self.o.delegate(DelegationRequest("security", "reasoning", "audit"))
        with self.assertRaisesRegex(ContractViolation, "child-agent"):
            self.o.delegate(DelegationRequest("security", "reasoning", "audit"))

    def test_security_rejects_secret_input_and_output(self):
        with self.assertRaisesRegex(ContractViolation, "sensitive"):
            self.o.delegate(DelegationRequest("security", "reasoning", "use api_key=abc"))
        report = self.o.delegate(DelegationRequest("security", "reasoning", "audit"))
        report.findings.append({"evidence": "password=abc"})
        with self.assertRaisesRegex(ContractViolation, "sensitive"):
            self.o.safe_report(report)


if __name__ == "__main__":
    unittest.main()
