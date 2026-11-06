# Migration 1.x vers 2.0

## Préconditions

- Projet propre ou changements locaux explicitement inventoriés.
- Sauvegarde du projet, du runtime et du manifeste.
- Version 1.x identifiée et vérifiable.
- Outils shared disponibles ou installables gratuitement.

## Étapes obligatoires

1. Exécuter le dry-run sans modifier le projet.
2. Produire la matrice des fichiers et comportements à conserver, migrer ou archiver.
3. Sauvegarder et calculer les checksums.
4. Installer le kit shared 2.0 dans un emplacement central.
5. Reconstruire la configuration projet sans dupliquer `.codex`, `.claude`, hooks ou runtime.
6. Valider les scripts, modèles, agents, outils et permissions.
7. Exécuter les tests de migration et de non-régression.
8. Publier une branche dédiée et une PR vers `dev`.

## Échec et rollback

Tout échec avant validation finale restaure la configuration précédente depuis la sauvegarde. Le rollback ne supprime aucun fichier produit et laisse une preuve de l opération.

## Sortie attendue

La migration est acceptée uniquement si le manifeste, le kit partagé, l état runtime, les hooks, les agents, les versions et les tests sont cohérents.
