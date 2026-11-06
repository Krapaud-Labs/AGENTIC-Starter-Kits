import sys
import unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / "scripts"))
from report_security import build_report, sanitize, validate

class ReportSecurityTests(unittest.TestCase):
    def test_sanitize_removes_sensitive_values(self):
        result = sanitize("token=ghp_1234567890abc /Users/alice/work a@b.example")
        self.assertNotIn("ghp_", result); self.assertNotIn("/Users/", result); self.assertNotIn("@b.example", result)
    def test_both_kits_are_valid(self):
        for kit in ("codex", "claude"):
            self.assertEqual([], validate(build_report(kit, "demo", [{"message": "ok"}], "2026-11-06T00:00:00Z")))
    def test_unsanitized_credential_is_rejected(self):
        report = build_report("codex", "demo", [], "now"); report["findings"].append({"evidence": "Bearer abc123"})
        self.assertTrue(validate(report))
    def test_invalid_contract_is_rejected(self):
        errors = validate({"kit": "other", "findings": []})
        self.assertIn("missing field: generated_at", errors); self.assertIn("kit must be codex or claude", errors)

if __name__ == "__main__": unittest.main()
