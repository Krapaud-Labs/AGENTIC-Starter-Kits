# Politique du registre central des outils

Le registre central est la source de vérité des outils réutilisables par les kits Codex et Claude.

## Règles

- Les outils CLI, runtimes, npm et Python partagés sont déclarés dans `tool-manifest.tsv` des deux distributions.
- Les chemins d installation sont fournis par `tool-env.sh` et utilisent `AGENTIC_TOOLS_HOME`.
- Les dépendances verrouillées d un projet restent dans son environnement local.
- Une vérification doit distinguer outil absent, outil présent hors registre et outil installé dans le registre.
- Une installation manquante est proposée ou réalisée dans le registre central, jamais dans le projet consommateur par défaut.
- Toute erreur d installation ou de vérification reste explicite et récupérable.

## Contrôle obligatoire

`bash scripts/verify-central-tool-registry.sh` vérifie les deux manifestes, les doublons, les commandes déclarées et la parité Codex/Claude. La CI exécute ce contrôle avant toute livraison.
