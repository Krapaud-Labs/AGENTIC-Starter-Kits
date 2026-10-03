# Documentation Language and Code Comment Policy

## Langue obligatoire

Toute la documentation technique du dépôt doit être rédigée en français clair et professionnel, sauf si le profil du projet déclare explicitement une autre langue. Cela s'applique aux README, documents d'architecture, documentations API, changelogs, notes de migration, runbooks, ADR, work items, rapports d'audit, notes de version, exemples et guides techniques destinés aux utilisateurs.

Le français est également la langue par défaut des commentaires de code, docstrings, TODO, FIXME, avis de dépréciation, descriptions de tests, explications de fixtures, commentaires de configuration, scripts et messages CI. Les identifiants techniques, commandes, noms d'API et extraits de logs conservent leur forme originale lorsque leur traduction les rendrait ambigus.

## Structure documentaire obligatoire

Every README must use a predictable structure when relevant: purpose, scope, prerequisites, installation, configuration, usage, project structure, commands, testing, troubleshooting, security, contribution rules, versioning and license.

Every substantial document must include a title, scope, status, last-updated date, owner or responsible agent, assumptions, verified facts, limitations, validation evidence and references when applicable.

## Séparateurs de sections

Les fichiers source et scripts longs doivent utiliser des séparateurs de section cohérents en français. Utiliser systématiquement le style du projet, par exemple :

```text
# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
```

Ne pas utiliser de séparateurs décoratifs, ambigus ou mélangeant les langues. Un séparateur doit décrire la section qui le suit.

## Qualité des commentaires

Comments must explain intent, constraints, security considerations or non-obvious tradeoffs. Do not narrate obvious syntax, leave stale comments, duplicate the code or hide unfinished work. Every TODO or FIXME must include an owner, a reason, a reference to a work item and a clear completion condition.

## Règle de synchronisation

After every meaningful code, architecture, security, API, CI or deployment change, the Documentation agent must inspect and update every affected README, comment, example, changelog, ADR, work item and release note. A change is not complete while the documentation contradicts the implementation.

## Validation

Avant un commit ou une Pull Request, l'agent Documentation doit vérifier la cohérence française, les titres, les liens, les exemples de code, les commandes, les séparateurs, les références obsolètes, les versions, les métadonnées TODO et la documentation générée. Le Coordinateur doit refuser toute documentation incomplète ou contradictoire.

Si le produit exige une autre langue, créer des documents localisés explicitement nommés selon le profil du projet. Ne jamais mélanger silencieusement plusieurs langues dans un même document technique.
