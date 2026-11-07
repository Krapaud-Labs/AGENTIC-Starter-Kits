import importlib.util
import os
import stat
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).parents[1]
SPEC = importlib.util.spec_from_file_location("compat", ROOT / "scripts/check-kit-compatibility.py")
compat = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(compat)

class CompatibilityReleaseTests(unittest.TestCase):
    def test_repo_passes_all_supported_platform_overrides(self):
        for name in ("darwin", "linux", "windows"):
            self.assertEqual(compat.check(ROOT, name), [], name)

    def test_missing_shared_tool_is_reported(self):
        with tempfile.TemporaryDirectory() as directory:
            fixture = Path(directory)
            for relative in compat.KIT_FILES + compat.KIT_SCRIPTS:
                path = fixture / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("x")
                if relative.endswith(".sh"):
                    path.chmod(path.stat().st_mode | stat.S_IXUSR)
            (fixture / "VERSION").write_text("2.0.0")
            (fixture / "docs").mkdir()
            (fixture / "docs/COMPATIBILITY-RELEASE-MATRIX.md").write_text("matrix")
            uninstall = fixture / "scripts/uninstall-kit.sh"
            uninstall.parent.mkdir(parents=True, exist_ok=True)
            uninstall.write_text("#!/bin/sh\n")
            uninstall.chmod(uninstall.stat().st_mode | stat.S_IXUSR)
            self.assertIn("missing required file: scripts/agentic_orchestration.py", compat.check(fixture, "linux"))

    def test_uninstall_defaults_to_dry_run_and_refuses_home(self):
        script = ROOT / "scripts/uninstall-kit.sh"
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory)
            (target / ".codex").mkdir()
            result = subprocess.run([script, "--target", target], text=True, capture_output=True)
            self.assertEqual(result.returncode, 0)
            self.assertTrue((target / ".codex").exists())
            self.assertIn("dry-run", result.stdout)
        result = subprocess.run([script, "--target", os.environ["HOME"], "--apply"], text=True, capture_output=True)
        self.assertNotEqual(result.returncode, 0)

if __name__ == "__main__":
    unittest.main()
