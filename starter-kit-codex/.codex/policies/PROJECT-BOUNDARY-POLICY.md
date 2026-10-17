# Politique de frontière projet

Le projet livré doit rester indépendant et professionnel. Ne jamais exposer dans le produit ou ses livrables les détails internes de l'outillage d'orchestration.

## Interdictions

- Ne pas mentionner `Agentic`, `AGENTIC Starter Kits`, `starter kit`, `.codex`, `.claude`, les noms internes des agents, skills, policies ou scripts dans le code métier, l'interface, les textes utilisateur, le README produit, la documentation fonctionnelle/API, les changelogs produit, les issues, les cartes Trello, les commits ou les notes de livraison.
- Ne pas ajouter de marque, badge, lien ou commentaire expliquant que le projet est piloté par cet outillage.
- Ne pas copier dans les livrables les consignes internes, prompts, journaux, métriques, états runtime ou détails de synchronisation du kit.

## Règle de séparation

Les fichiers internes nécessaires au fonctionnement de l'orchestrateur peuvent rester dans leur répertoire technique privé. Ils ne doivent jamais être référencés par les artefacts produit ni inclus dans un paquet, une image, une extension ou une documentation publiée.

Avant chaque livraison, l'agent vérifie les fichiers modifiés et retire toute trace accidentelle. La preuve reste dans l'espace de contrôle interne et le résultat publié reste neutre et orienté métier.

## Suivi Git du kit et des projets consommateurs

- Dans un projet consommateur, `.codex/` ou `.claude/` est une installation locale et doit être ignoré par Git. Ne pas le retirer du disque ni créer une PR pour ses changements automatiques.
- Dans le dépôt source des kits, `starter-kit-codex/.codex/` et `starter-kit-claude/.claude/` sont des livrables distribués et doivent rester suivis par Git. Ne jamais les ajouter au `.gitignore` du dépôt source ni les désindexer.
- Avant de déclarer des fichiers en attente, exécuter `git status --short`, `git check-ignore -v` et `git ls-files`. Distinguer les artefacts locaux ignorables des livrables suivis attendus.
- Il est interdit d’utiliser `git add -f`, `git add -A` ou une procédure équivalente pour faire entrer `.codex/` dans l’index d’un projet consommateur. Le contrôle `verify-consumer-index.sh` doit réussir avant tout push.
- Si `.codex/` est déjà suivi par erreur, exécuter uniquement `git rm -r --cached -- .codex/` puis vérifier que les fichiers restent présents sur disque et ignorés. L’ajout forcé est réservé au dépôt source du kit.
