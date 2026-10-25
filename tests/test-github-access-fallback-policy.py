from pathlib import Path

POLICY = Path(__file__).parents[1] / "docs/policies/GITHUB-ACCESS-FALLBACK-POLICY.md"


def test_cli_failure_is_not_global_github_failure():
    text = POLICY.read_text(encoding="utf-8")
    assert "gh auth status" in text
    assert "cli_unavailable" in text
    assert "Un échec `cli_unavailable` ne doit jamais bloquer" in text


def test_api_and_project_capability_are_checked_first():
    text = POLICY.read_text(encoding="utf-8")
    assert "Connecteur GitHub" in text
    assert "Project V2" in text
    assert "relire la ressource" in text
