"""Test-only import adapter for the isolated .codex runtime directory."""

import importlib.util
from pathlib import Path
import sys

_path = Path(__file__).parents[1] / "starter-kit-codex/.codex/runtime_v2/core.py"
_spec = importlib.util.spec_from_file_location("runtime_v2_core", _path)
_module = importlib.util.module_from_spec(_spec)
sys.modules[_spec.name] = _module
_spec.loader.exec_module(_module)
Runtime = _module.Runtime
RuntimeStatus = _module.RuntimeStatus
