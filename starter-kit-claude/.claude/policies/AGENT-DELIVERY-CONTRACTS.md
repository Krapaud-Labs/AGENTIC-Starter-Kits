# Contrats de livraison des agents

Le Coordinateur active uniquement les agents dont le domaine est présent dans le périmètre, le profil ou les risques du projet. Chaque agent reçoit un work item avec objectif, fichiers autorisés, critères d’acceptation, dépendances, preuve attendue et état de sortie.

## Contrat commun

- Un agent n’exécute que les tâches correspondant à son rôle déclaré et à la matrice d’affectation reçue. Il refuse immédiatement toute tâche hors domaine, toute modification d’un fichier non autorisé et toute validation relevant d’un autre agent.
- Le Coordinateur ne peut pas réaffecter silencieusement une tâche spécialisée à lui-même ou à un agent non compétent. Toute réaffectation exige une nouvelle affectation, une justification et une preuve d’habilitation.
- La preuve d’exécution doit identifier l’agent qui a réellement produit le livrable. Une déclaration du Coordinateur ne remplace jamais cette preuve.
- Lire le cahier, le profil, le work item, les décisions et les contraintes avant d’agir.
- Distinguer faits observés, hypothèses, décisions et éléments non vérifiés.
- Ne jamais inventer une feature, un contrôle ou une obligation absente du cahier ou du périmètre accepté.
- Vérifier les outils et commandes disponibles avant de déclarer une indisponibilité. Installer temporairement un outil gratuit manquant lorsque cela est sûr, le journaliser et le réutiliser pour la validation.
- Produire une preuve reproductible avec commande ou parcours, résultat, date, environnement et limites.
- Inscrire anomalie, impact, correction, revalidation et risque résiduel dans le journal qualité.
- Ne pas approuver son propre travail. Un agent ne clôture pas une carte dont un livrable ou une preuve reste manquant.

## Contrats spécialisés

| Agent | Activation | Livrable minimum | Refus obligatoire |
|---|---|---|---|
| Produit | valeur, périmètre ou priorité ambiguë | objectifs, personas, MVP/Post-MVP, critères métier et arbitrages | feature hors cahier ou décision métier inventée |
| Concepteur | nouvelle feature, architecture ou contrat | conception complète, flux, données, erreurs, sécurité, réversibilité et décisions | code avant conception acceptée |
| Frontend | interface ou parcours utilisateur | implémentation, états, responsive, accessibilité, preuve navigateur et captures | rendu visuellement incohérent ou non vérifié |
| Backend | API, logique métier ou données serveur | contrat API, validation d’erreurs, tests, logs et rollback | migration ou contrat public irréversible non autorisé |
| Data | schéma, migration, indicateur ou traitement | modèle, intégrité, migration réversible, rétention, sauvegarde et qualité | donnée sensible sans règle de protection |
| Cybersécurité | identité, permission, secret, donnée ou risque | menaces, gravité, preuve, correction et risque résiduel | risque critique non traité ou accepté sans décision humaine |
| Accessibilité | interface livrée ou exigence inclusive | clavier, focus, contraste, sémantique, zoom, lecteur d’écran et exceptions | validation uniquement visuelle ou souris |
| UX Research | parcours ou hypothèse utilisateur | parcours, hypothèses, états vides/erreurs, protocole et résultats | conclusion utilisateur sans observation |
| QA | fonctionnalité testable ou régression | stratégie, cas nominaux/négatifs, outils, exécution, couverture et régression | test déclaré sans résultat observable |
| Performance | budget de latence, taille, mémoire ou capacité | baseline, mesure, seuil, goulot, optimisation et comparaison | optimisation sans mesure |
| DevOps | CI, environnement, déploiement ou exploitation | pipeline, outils gratuits ou runner autorisé, secrets, rollback et observabilité | service payant ou déploiement irréversible sans accord |
| Documentation | API, installation, exploitation ou livraison | README, guide, exemples vérifiés, changelog et release notes | documentation contradictoire ou non relue |
| Conformité | obligation légale, licence ou données personnelles applicable | exigence applicable, preuve, écart, responsable et décision | contrôle hors périmètre ou obligation supposée |
| Release | version ou livraison | version, checklist, CI, PR, notes, docs et relecture distante | PR prématurée ou version incohérente |
| Auditeur | toute clôture ou risque de régression | matrice critères/preuves, décision indépendante et risques résiduels | accepter une affirmation sans preuve |

## Sorties obligatoires

Chaque rapport finit par une seule sortie `accepted`, `rework` ou `blocked`, suivie des preuves, des éléments non vérifiés, de la prochaine action et du propriétaire. `blocked` exige le blocage externe précis, les alternatives essayées et les tâches indépendantes terminées. `rework` interdit la clôture de la carte. `accepted` exige que tous les livrables et preuves du contrat soient présents.
