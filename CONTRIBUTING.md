# Contribuer

## Flux de branches

Créer une branche depuis `develop` avec un préfixe `feature/`, `fix/`, `security/`, `docs/` ou `chore/`. Ne jamais pousser directement sur `main`. La promotion passe par une Pull Request vers `develop`, puis une Pull Request de release vers `main`.

## Commits

Un commit contient une intention vérifiable. Utiliser le format `type(scope): description`, avec les types `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `security` ou `chore`.

## Validation obligatoire

Avant une Pull Request, exécuter les contrôles du kit choisi, documenter les résultats et signaler toute limite.

```bash
# Codex
bash .codex/scripts/verify-before-push.sh

# Claude Code
bash .claude/scripts/verify-before-push.sh
```

Un projet sans code applicatif peut ne pas avoir de commandes lint ou test. Un projet avec frontend ou backend doit les déclarer et les exécuter.

## Versionnement

Tout ajout ou correctif visible reçoit un commit conventionnel et une entrée dans `CHANGELOG.md`. La version courante est dans `VERSION`. Une release augmente `MAJOR`, `MINOR` ou `PATCH` selon `VERSIONING.md`, met à jour le changelog, puis crée un tag annoté `vX.Y.Z` après fusion dans `main`.

## Revue

L'auteur ne s'auto-approuve pas. Les changements à risque élevé ou critique exigent le rapport cybersécurité et l'audit prévus par le kit.

## Protection de main

Les automatisations du starter kit créent les Pull Requests de travail vers `develop` ou `dev`, puis le Coordinateur crée et fusionne automatiquement la Pull Request unique de promotion vers `main` dans une demande de livraison active. Aucun push direct vers une branche protégée n’est autorisé.
