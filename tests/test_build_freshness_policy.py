from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class BuildFreshnessTests(unittest.TestCase):
    def test_policy_mentions_target_branches_and_sha(self):
        text = (ROOT / "docs/policies/BUILD-FRESHNESS-POLICY.md").read_text()
        self.assertIn("origin/dev", text)
        self.assertIn("origin/main", text)
        self.assertIn("SHA", text)

    def test_scripts_accept_matching_clean_checkout_and_reject_stale_image(self):
        with tempfile.TemporaryDirectory() as directory:
            subprocess.run(["git", "init", "-q", directory], check=True)
            for key, value in (("user.email", "test@example.invalid"), ("user.name", "Kit Test"), ("commit.gpgsign", "false")):
                subprocess.run(["git", "-C", directory, "config", key, value], check=True)
            Path(directory, "README.md").write_text("test\n")
            subprocess.run(["git", "-C", directory, "add", "README.md"], check=True)
            subprocess.run(["git", "-C", directory, "commit", "-q", "-m", "test"], check=True)
            sha = subprocess.check_output(["git", "-C", directory, "rev-parse", "HEAD"], text=True).strip()
            for relative in ("starter-kit-codex/.codex/scripts/verify-build-freshness.sh", "starter-kit-claude/.claude/scripts/verify-build-freshness.sh"):
                script = ROOT / relative
                self.assertEqual(subprocess.run(["bash", str(script), directory, sha, sha]).returncode, 0)
                self.assertNotEqual(subprocess.run(["bash", str(script), directory, sha, "stale"]).returncode, 0)


if __name__ == "__main__":
    unittest.main()
