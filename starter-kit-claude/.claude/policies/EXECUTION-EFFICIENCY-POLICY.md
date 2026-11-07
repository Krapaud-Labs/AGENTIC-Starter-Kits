# Politique d'efficacité d'exécution

Appliquer la politique commune située dans `docs/policies/EXECUTION-EFFICIENCY-POLICY.md`. Une carte ou feature utilise un plan unique, une branche unique et une PR finale unique. Les agents spécialisés sont activés dans le même cycle, leurs lots sont non recouvrants, les audits sont consolidés et les revalidations identiques sont interdites sans changement d'état.

Déclarer dans `RUNTIME-STATE.md` le mode `work_item_mode` parmi `quick-fix`, `feature` et `audit`, ainsi que `exhaustive_audit_required`. `quick-fix` n'active ni audit indépendant ni validation responsive globale. `feature` réalise une seule validation finale proportionnée. `audit` seul active la matrice exhaustive, sauf demande explicite ou risque critique documenté.

Le Coordinateur doit exécuter une passe d'inventaire, une passe de correction groupée et une revalidation finale. Il limite chaque agent à une relance, change d'approche après deux échecs identiques et poursuit les actions autonomes sans demander « continue » ou une confirmation intermédiaire déjà autorisée.

Les audits lourds de rendu, responsive, accessibilité, performance et navigateur sont différés jusqu'à la fin du lot d'implémentation. Pendant le développement, seuls les contrôles rapides nécessaires pour éviter une régression immédiate sont autorisés. Une passe anticipée n'est permise que si l'utilisateur la demande, si un risque critique doit être tranché avant de continuer, ou si une preuve locale est indispensable pour choisir l'implémentation. Cette exception doit être inscrite dans le plan du Goal.
