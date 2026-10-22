# Protocole obligatoire de mise à jour du kit

Une mise à jour détectée pendant un work item suspend immédiatement le travail produit.

Le Coordinateur enregistre l'état et `next_action`, passe le runtime en `paused-kit-update`, met à jour le kit partagé, valide les scénarios, publie une branche dédiée, ouvre puis fusionne la PR vers `dev`, vérifie le SHA distant de `dev`, restaure l'état et reprend exactement `next_action`.

La mise à jour n'est jamais appliquée en plein milieu d'une tâche et jamais poussée directement vers `main`.

Tout rebuild applique aussi `docs/policies/BUILD-FRESHNESS-POLICY.md` et vérifie le SHA exact de `origin/dev` ou `origin/main` avant de construire.
