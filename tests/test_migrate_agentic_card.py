import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts/migrate_agentic_card.py"
FIXTURE = ROOT / "tests/fixtures/agentic-card-v1-project/agentic-card.json"


class MigrationTests(unittest.TestCase):
    def copy_fixture(self, directory):
        target = Path(directory) / "agentic-card.json"
        target.write_bytes(FIXTURE.read_bytes())
        return target

    def run_migration(self, directory, *args):
        return subprocess.run([sys.executable, str(SCRIPT), directory, *args], capture_output=True, text=True)

    def test_dry_run_does_not_write(self):
        with tempfile.TemporaryDirectory() as directory:
            target = self.copy_fixture(directory)
            before = target.read_bytes()
            result = self.run_migration(directory, "--dry-run")
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(before, target.read_bytes())
            self.assertEqual(json.loads(result.stdout)["status"], "dry_run")

    def test_migration_backup_checksum_and_rollback(self):
        with tempfile.TemporaryDirectory() as directory:
            target = self.copy_fixture(directory)
            original = target.read_bytes()
            result = self.run_migration(directory)
            self.assertEqual(result.returncode, 0, result.stderr)
            card = json.loads(target.read_text())
            self.assertEqual(card["schema_version"], "2.0")
            self.assertEqual(Path(directory, ".migration-backups/agentic-card.json").read_bytes(), original)
            rollback = self.run_migration(directory, "--rollback")
            self.assertEqual(rollback.returncode, 0, rollback.stderr)
            self.assertEqual(target.read_bytes(), original)

    def test_negative_cases_are_non_destructive(self):
        with tempfile.TemporaryDirectory() as directory:
            target = self.copy_fixture(directory)
            target.write_text('{"schema_version":"2.0"}\n', encoding="utf-8")
            result = self.run_migration(directory)
            self.assertEqual(result.returncode, 2)
            self.assertFalse(Path(directory, ".migration-backups").exists())

            target.write_text('{"schema_version":"1.0","id":"x"}\n', encoding="utf-8")
            result = self.run_migration(directory, "--dry-run")
            self.assertEqual(result.returncode, 2)


if __name__ == "__main__":
    unittest.main()
