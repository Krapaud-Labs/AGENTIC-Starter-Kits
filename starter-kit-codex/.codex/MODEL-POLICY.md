# Politique de modèles

`.codex/models.toml` est la source de vérité de sélection des modèles. Le Coordinateur résout un profil de modèle avant chaque délégation avec `resolve-agent-model.sh`.

## Principes

- `gpt-5.6-sol` traite orchestration, conception, risques critiques et décisions complexes.
- `gpt-5.6-terra` traite implémentation, tests, revue et sécurité courante avec le meilleur équilibre qualité et coût.
- `gpt-5.6-luna` traite uniquement les tâches répétitives à faible risque, avec contrôle par un rôle plus robuste si la sortie influence une décision.
- Le raisonnement monte avec le risque : `low`, `medium`, `high`, puis `xhigh` pour le critique.
- Sol n'est pas utilisé pour une tâche simple lorsque Terra ou Luna suffit.
- Le fallback est utilisé seulement si le modèle primaire n'est pas disponible dans l'environnement Codex configuré.

## Choix par rôle

| Rôle | Profil normal | Risque élevé | Risque critique |
|---|---|---|---|
| Coordinateur | Sol high | Terra high | Sol xhigh |
| Concepteur | Sol high | Terra high | Sol xhigh |
| Frontend | Terra medium | Terra high | Sol xhigh |
| Backend | Terra medium | Terra high | Sol xhigh |
| Cybersécurité | Terra high | Terra high | Sol xhigh |
| Auditeur | Terra high | Terra high | Sol xhigh |
| Produit | Sol high | Sol high | Sol xhigh |
| QA | Terra high | Terra high | Sol xhigh |
| DevOps | Terra medium | Terra high | Sol xhigh |
| Performance | Terra high | Terra high | Sol xhigh |
| UX Research | Terra medium | Terra high | Sol xhigh |
| Accessibilité | Terra high | Terra high | Sol xhigh |
| Data | Terra medium | Terra high | Sol xhigh |
| Documentation | Luna low | Terra medium | Sol high |
| Release | Sol high | Terra high | Sol xhigh |
| Conformité | Terra high | Terra high | Sol xhigh |

Luna low est accessible avec le niveau `low` pour les tâches sans effet direct sur le produit ou la sécurité.

Toute modification de `models.toml` nécessite une évaluation avant et après, conformément à `COST-AND-EVALUATION.md`.

## Priorité du risque sur le profil de rôle

Le profil de rôle fournit le choix par défaut. Si un niveau de risque est explicitement fourni, l’entrée correspondante de `[risk_override]` dans `models.toml` prime sur le profil de rôle, y compris lorsque le modèle choisi diffère de la colonne de risque du tableau ci-dessus. En cas d’absence de risque explicite, appliquer le profil de rôle.
