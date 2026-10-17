#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
fail=0

# Une installation partielle reste récupérable avant le premier contrôle.
for local_file in PROJECT-BRIEF.md project-profile.toml RUNTIME-STATE.md; do
  template_file="$local_file"
  [ "$local_file" = "PROJECT-BRIEF.md" ] && template_file="project-brief.md"
  if [ ! -f "$config/$local_file" ] && [ -f "$config/templates/$template_file" ]; then
    cp "$config/templates/$template_file" "$config/$local_file"
  fi
done

for file in KIT.toml START-HERE.md ORCHESTRATION.md CONVERSATION-MODES.md PROJECT-CONTEXT.md PROJECT-DATA-BOUNDARY.md FILE-MANIFEST.md GOVERNANCE.md RISK-MATRIX.md COST-AND-EVALUATION.md ADAPTERS.md MODEL-POLICY.md models.toml project-profile.toml PROJECT-BRIEF.md; do
  [ -f "$config/$file" ] || { echo "MANQUANT: .claude/$file"; fail=1; }
done

if rg -n --hidden --glob '!.git/**' --glob '!node_modules/**' -- '-----BEGIN (RSA|OPENSSH|EC|PRIVATE) KEY-----|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}' "$root"; then
  echo "SECRET POTENTIEL DETECTE"; fail=1
fi

if "$script_dir/python.sh" - "$root" <<'PY'
import pathlib, re, sys, tomllib
root = pathlib.Path(sys.argv[1])
config = root / '.claude'
found = []
for path in root.rglob('*'):
    if path.is_file() and '.git' not in path.parts and 'node_modules' not in path.parts:
        if chr(0x2014) in path.read_text(errors='ignore'):
            found.append(str(path))
if found:
    print('\n'.join(found))
    raise SystemExit(1)
kit = config / 'KIT.toml'
try:
    kit_data = tomllib.loads(kit.read_text())
    if kit_data.get('kit_name') != 'claude-premium-starter':
        print('KIT INVALIDE: nom inattendu')
        raise SystemExit(1)
except Exception as exc:
    print(f'KIT INVALIDE: {exc}')
    raise SystemExit(1)
profile = config / 'project-profile.toml'
brief = config / 'PROJECT-BRIEF.md'
if not brief.is_file():
    print('CAHIER DES CHARGES MANQUANT: PROJECT-BRIEF.md')
    raise SystemExit(1)
if not profile.is_file():
    print('PROFIL MANQUANT: project-profile.toml')
    raise SystemExit(1)
if '## Statut\n\naccepted' not in brief.read_text(errors='ignore'):
    print('CAHIER DES CHARGES INCOMPLET: PROJECT-BRIEF.md doit être accepted')
    raise SystemExit(1)
try:
    data = tomllib.loads(profile.read_text())
    for field in ('schema_version', 'project_name', 'project_type', 'integration_branch'):
        if field not in data:
            print(f'PROFIL INCOMPLET: {field}')
            raise SystemExit(1)
    if data['project_name'] == 'à compléter' or data['project_type'] == 'unknown':
        print('PROFIL INCOMPLET: appliquer le Skill project-onboarding')
        raise SystemExit(1)
    if not isinstance(data.get('stack'), dict):
        print('PROFIL INCOMPLET: section stack absente')
        raise SystemExit(1)
except Exception as exc:
    print(f'PROFIL INVALIDE: {exc}')
    raise SystemExit(1)
tracking_data = data.get("tracking", {})
github_projects_choice = tracking_data.get("github_projects_choice", "pending")
if github_projects_choice not in ("enabled", "disabled"):
    print("CHOIX GITHUB PROJECTS MANQUANT: répondre oui ou non dans le profil")
    raise SystemExit(1)
if github_projects_choice == "enabled" and not str(tracking_data.get("github_project_name", "")).strip():
    print("PROFIL INCOMPLET: github_project_name requis si GitHub Projects est activé")
    raise SystemExit(1)
if github_projects_choice == "enabled":
    members = tracking_data.get("github_members", [])
    if not isinstance(members, list) or not members:
        print("PROFIL INCOMPLET: github_members requis si GitHub Projects est activé")
        raise SystemExit(1)
    for index, member in enumerate(members, 1):
        if not isinstance(member, dict) or not str(member.get("name", "")).strip() or not str(member.get("role", "")).strip():
            print(f"PROFIL INCOMPLET: membre GitHub {index} doit avoir name et role")
            raise SystemExit(1)
design_files = (
    "docs/README.md", "docs/product/vision-and-scope.md", "docs/product/user-stories.md",
    "docs/product/user-flows.md", "docs/design/architecture.md", "docs/design/data-model.md",
    "docs/design/api-contracts.md", "docs/design/security-design.md", "docs/delivery/roadmap.md",
    "docs/delivery/decision-log.md", "docs/diagrams/README.md", "docs/quality/quality-journal.md",
)
design_readiness = root / "docs/design/design-readiness.md"
design_files = design_files + ("docs/design/design-readiness.md",)
if data.get("tracking", {}).get("github_projects_choice") == "enabled":
    design_files = design_files + ("docs/project-management/github-project.md",)
missing_design = [path for path in design_files if not (root / path).is_file()]
if missing_design:
    print(f"CONCEPTION INCOMPLETE: initialiser et compléter docs/: {chr(44).join(missing_design)}")
    raise SystemExit(1)
incomplete_design = [path for path in design_files if "[[A_COMPLETER" in (root / path).read_text(errors="ignore")]
if incomplete_design:
    print(f"CONCEPTION INCOMPLETE: remplacer les marqueurs de modèle dans : {chr(44).join(incomplete_design)}")
    raise SystemExit(1)
readiness = design_readiness.read_text(errors="ignore")
if "Status: approved" not in readiness:
    print("CONCEPTION INCOMPLETE: docs/design/design-readiness.md doit avoir Status: approved")
    raise SystemExit(1)
if "- [ ]" in readiness or re.search(r"(?m)^\s*(TODO|FIXME)(?:[:\s]|$)", readiness):
    print("CONCEPTION INCOMPLETE: design-readiness contient une case ouverte ou une dette non traitée")
    raise SystemExit(1)
models = tomllib.loads((config / 'models.toml').read_text())
allowed_models = {'opus', 'sonnet'}
for profile_name, profile_data in models.get('profiles', {}).items():
    for field in ('model', 'reasoning_effort', 'fallback_model', 'fallback_reasoning_effort', 'purpose'):
        if not profile_data.get(field):
            print(f'MODELE INCOMPLET: {profile_name}: {field}')
            raise SystemExit(1)
    if profile_data['model'] not in allowed_models or profile_data['fallback_model'] not in allowed_models:
        print(f'MODELE INTERDIT: {profile_name}')
        raise SystemExit(1)
required_sections = ('## Objectif', '## Entrées', '## Procédure', '## Sortie', '## Mesures', '## Arrêt')
for skill in (config / 'skills').glob('*/SKILL.md'):
    content = skill.read_text(errors='ignore')
    if not content.startswith('---\n'):
        print(f'SKILL INCOMPLET: frontmatter absent: {skill}')
        raise SystemExit(1)
    frontmatter = content.split('---\n', 2)[1]
    metadata = {}
    for line in frontmatter.splitlines():
        if ': ' in line:
            key, value = line.split(': ', 1)
            metadata[key] = value
    if not metadata.get('name') or not metadata.get('description'):
        print(f'SKILL INCOMPLET: name ou description absent: {skill}')
        raise SystemExit(1)
    for section in required_sections:
        if section not in content:
            print(f'SKILL INCOMPLET: {skill}: {section}')
            raise SystemExit(1)
required_agents = {'coordinateur', 'concepteur', 'frontend', 'backend', 'cybersecurite', 'auditeur'}
seen = set()
for agent in (config / 'agents').glob('*.md'):
    content = agent.read_text(errors='ignore')
    if not content.startswith('---\n'):
        print(f'AGENT INCOMPLET: frontmatter absent: {agent}')
        raise SystemExit(1)
    frontmatter = content.split('---\n', 2)[1]
    data = {}
    for line in frontmatter.splitlines():
        if ': ' in line:
            key, value = line.split(': ', 1)
            data[key] = value
    for field in ('name', 'description', 'model'):
        if not data.get(field):
            print(f'AGENT INCOMPLET: {agent}: {field}')
            raise SystemExit(1)
    if data['model'] not in allowed_models:
        print(f'MODELE AGENT INTERDIT: {agent}')
        raise SystemExit(1)
    if len(content) < 400:
        print(f'AGENT INSUFFISANT: {agent}')
        raise SystemExit(1)
    seen.add(data['name'])
if not required_agents.issubset(seen):
    print(f'AGENTS INCOMPLETS: attendus={sorted(required_agents)} obtenus={sorted(seen)}')
    raise SystemExit(1)
for prompt in ('coordinateur', 'concepteur', 'implementation', 'cybersecurite', 'auditeur'):
    prompt_path = config / 'prompts' / f'{prompt}.md'
    if not prompt_path.is_file():
        print(f'PROMPT MANQUANT: {prompt}')
        raise SystemExit(1)
    if len(prompt_path.read_text(errors='ignore')) < 300:
        print(f'PROMPT INSUFFISANT: {prompt}')
        raise SystemExit(1)
for path in (
    config / 'policies' / 'QUALITY-GATES.md',
    config / 'policies' / 'CONTEXT-POLICY.md',
    config / 'policies' / 'INCIDENT-POLICY.md',
    config / 'policies' / 'VALIDATION-POLICY.md',
    config / 'policies' / 'GIT-FLOW.md',
    config / 'templates' / 'project-brief.md',
    config / 'templates' / 'project-profile.toml',
    config / 'templates' / 'work-item.md',
    config / 'templates' / 'decision.md',
    config / 'templates' / 'delivery-report.md',
):
    if not path.is_file():
        print(f'COMPOSANT MANQUANT: {path.relative_to(config)}')
        raise SystemExit(1)
active = 0
for brief in (config / 'work-items').glob('*/brief.md'):
    if '| Statut | in-progress |' in brief.read_text(errors='ignore'):
        active += 1
if active > 1:
    print(f'PLUSIEURS WORK ITEMS ACTIFS: {active}')
    raise SystemExit(1)
PY
then :; else
  echo "CONTROLE PYTHON ECHEC: style, profil, Skills ou agents"; fail=1
fi

if [ "$fail" -eq 0 ]; then echo "Preflight OK"; fi
exit "$fail"
