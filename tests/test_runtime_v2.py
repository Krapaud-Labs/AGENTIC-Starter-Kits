import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from starter_kit_codex_runtime import Runtime, RuntimeStatus


class RuntimeV2Tests(unittest.TestCase):
    def test_canonical_state_and_idempotent_replay(self):
        runtime = Runtime("run-1")
        started = runtime.start("op-1")
        self.assertEqual(started.status, RuntimeStatus.RUNNING)
        finished = runtime.finish("op-1", {"ok": True})
        self.assertEqual(runtime.finish("op-1", {"different": True}), finished)
        self.assertEqual(runtime.state.revision, 2)

    def test_cancel_is_cooperative_and_resumable(self):
        runtime = Runtime("run-2")
        runtime.start("op-1")
        runtime.cancel("op-1")
        with self.assertRaises(RuntimeError):
            runtime.checkpoint("op-1")
        self.assertEqual(runtime.state.status, RuntimeStatus.CANCELLED)
        self.assertEqual(runtime.start("op-2").status, RuntimeStatus.RUNNING)

    def test_expired_lock_is_recoverable_and_token_bound(self):
        now = [10.0]
        runtime = Runtime("run-3", clock=lambda: now[0])
        runtime.acquire("worker-a", "token-a", ttl=5)
        with self.assertRaises(RuntimeError):
            runtime.acquire("worker-b", "token-b", ttl=5)
        runtime.release("worker-a", "wrong-token")
        now[0] = 16.0
        self.assertTrue(runtime.recover_expired_lock())
        runtime.acquire("worker-b", "token-b", ttl=5)


if __name__ == "__main__":
    unittest.main()
