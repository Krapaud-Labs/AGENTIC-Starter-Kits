import tempfile
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from pathlib import Path
from audit_context_tokens import audit

class ContextTokenAuditTests(unittest.TestCase):
    def make_root(self, codex: str, claude: str = "") -> Path:
        holder = tempfile.TemporaryDirectory()
        self.addCleanup(holder.cleanup)
        root = Path(holder.name)
        path = root / "starter-kit-codex" / ".codex" / "policies" / "policy.md"
        path.parent.mkdir(parents=True)
        path.write_text(codex, encoding="utf-8")
        if claude:
            other = root / "starter-kit-claude" / ".claude" / "policies" / "policy.md"
            other.parent.mkdir(parents=True)
            other.write_text(claude, encoding="utf-8")
        return root

    def test_hard_limit(self):
        messages, failed = audit(self.make_root("x" * 32001))
        self.assertTrue(failed)
        self.assertTrue(any("OVER HARD LIMIT" in message for message in messages))

    def test_duplicate_and_wide_loading(self):
        repeated = "Instruction importante " * 8
        messages, failed = audit(self.make_root("Read all files in the repository.\n\n" + repeated, repeated))
        self.assertFalse(failed)
        self.assertTrue(any("contexte trop large" in message for message in messages))
        self.assertTrue(any("duplique" in message for message in messages))

    def test_strict_mode_fails_on_review(self):
        messages, failed = audit(self.make_root("x" * 16001), strict=True)
        self.assertTrue(failed)
        self.assertTrue(any("REVIEW" in message for message in messages))

    def test_empty_tree_is_informational(self):
        with tempfile.TemporaryDirectory() as directory:
            messages, failed = audit(Path(directory))
        self.assertFalse(failed)
        self.assertIn("Aucun document d'instructions trouvé sous starter-kit-*", messages)

if __name__ == "__main__":
    unittest.main()
