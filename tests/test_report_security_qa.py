import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class ReportSecurityQATests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.scenarios = json.loads((ROOT / "tests/fixtures/report-security-qa-scenarios.json").read_text())

    def test_all_recovery_scenarios_are_unique_and_named(self):
        ids = [item["id"] for item in self.scenarios]
        self.assertEqual(len(ids), len(set(ids)))
        self.assertEqual({"valid-input", "secrets", "malformed-input", "duplicate", "resolved-report", "interruption", "resume"}, set(ids))

    def test_fixture_contains_no_real_secret_pattern(self):
        self.assertNotRegex(json.dumps(self.scenarios), re.compile(r"(?:ghp_|sk-|AIza|Bearer)"))

    def test_recovery_and_deduplication_are_explicit(self):
        expected = {item["id"]: item["expected"] for item in self.scenarios}
        self.assertEqual(expected["duplicate"]["created_count"], 1)
        self.assertEqual(expected["resume"]["repeated_effects"], [])
        self.assertFalse(expected["resolved-report"]["reopened"])

if __name__ == "__main__":
    unittest.main()
