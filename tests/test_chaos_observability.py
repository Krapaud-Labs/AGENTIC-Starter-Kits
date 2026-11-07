import json
import sys
import tempfile
from pathlib import Path
import unittest

sys.path.insert(0, str(Path(__file__).parents[1] / "scripts"))
from chaos_observability import MetricsSink, SCENARIOS, run_all, run_scenario


class ChaosObservabilityTests(unittest.TestCase):
    def test_all_faults_recover_in_isolated_workspaces(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "metrics.jsonl"
            results = run_all(sink=MetricsSink(path))
            self.assertEqual(SCENARIOS, {result.scenario for result in results})
            self.assertTrue(all(result.status == "success" for result in results))
            self.assertTrue(all(result.attempts <= 3 for result in results))
            self.assertEqual(len(results), len(path.read_text(encoding="utf-8").splitlines()))

    def test_concurrency_and_resume_are_repeatable(self):
        results = run_all(parallel=True)
        self.assertEqual(sorted(SCENARIOS), [result.scenario for result in results])
        self.assertEqual(run_scenario("resume").resumes, 0)
        self.assertEqual(run_scenario("crash").resumes, 1)

    def test_metrics_are_aggregated_and_anonymous(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "nested" / "metrics.jsonl"
            run_scenario("network_unavailable", sink=MetricsSink(path))
            record = json.loads(path.read_text(encoding="utf-8"))
            self.assertEqual(12, len(record["event_id"]))
            self.assertNotIn("/Users/", json.dumps(record))
            self.assertNotIn("agentic-chaos-", json.dumps(record))
            self.assertNotIn("network_unavailable", record["event_id"])

    def test_unknown_scenario_is_rejected(self):
        with self.assertRaises(ValueError):
            run_scenario("real-production")


if __name__ == "__main__":
    unittest.main()
