from pathlib import Path


DOCUMENT = Path(__file__).parents[1] / "docs/policies/GITHUB-PROJECT-WORKFLOW.md"


def test_github_project_convention_is_complete() -> None:
    content = DOCUMENT.read_text(encoding="utf-8")
    for value in ("Backlog", "In progress", "Review", "Done", "P0", "P1", "P2", "P3"):
        assert f"`{value}`" in content
    for value in (
        "Feature",
        "Bug",
        "Documentation",
        "Frontend",
        "Backend",
        "Security",
        "QA",
        "DevOps",
    ):
        assert f"`{value}`" in content
    assert "Contrôle obligatoire avant création et clôture" in content
    assert "titre réellement enregistré" in content
    assert "contenu complet réellement enregistré" in content
    assert "labels réellement attachés" in content
