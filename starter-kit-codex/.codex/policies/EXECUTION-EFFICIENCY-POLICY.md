# Politique d'efficacité d'exécution

Appliquer la politique commune située dans `docs/policies/EXECUTION-EFFICIENCY-POLICY.md`. Une carte ou feature utilise un plan unique, une branche unique et une PR finale unique. Les agents spécialisés sont activés dans le même cycle, leurs lots sont non recouvrants, les audits sont consolidés et les revalidations identiques sont interdites sans changement d'état.

Le Coordinateur doit exécuter une passe d'inventaire, une passe de correction groupée et une revalidation finale. Il limite chaque agent à une relance, change d'approche après deux échecs identiques et poursuit les actions autonomes sans demander « continue » ou une confirmation intermédiaire déjà autorisée.
