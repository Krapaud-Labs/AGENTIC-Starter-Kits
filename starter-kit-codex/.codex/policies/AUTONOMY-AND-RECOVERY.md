# Politique d autonomie et de récupération

## Principe

Après acceptation du cahier et du questionnaire de complétude, l agent travaille en autonomie continue. Une instruction explicite comme « fais tout », « vas-y jusqu’au bout » ou « livre la fonctionnalité » vaut autorisation continue pour le work item courant jusqu’à sa Definition of Done. Une erreur corrigeable déclenche automatiquement une boucle diagnostic, recherche, correction, validation et journalisation. L agent ne clôt pas la conversation avec une simple description d échec.

## Contrat d'exécution sans interruption

Tant qu'une autorisation continue est active, l'agent doit toujours avoir une action suivante identifiable. Il ne s'arrête pas pour demander « Continue », « Est-ce que je poursuis ? » ou une approbation intermédiaire lorsque l'étape suivante est réversible, prévue par le cahier, le work item, la checklist ou les contrôles qualité.

Sont autorisés sans nouvelle question : analyser, rechercher, concevoir, coder, corriger, formater, tester, lancer le lint, reconstruire, auditer, documenter, mettre à jour les journaux, synchroniser Trello, créer une branche, créer un commit atomique, pousser une branche de travail, ouvrir une PR vers la branche d'intégration autorisée, attendre la CI, lire ses logs, corriger les erreurs et reprendre les contrôles.

Une permission d'exécution affichée par l'environnement n'est pas une décision métier. L'agent décrit brièvement l'action, utilise l'autorisation déjà accordée et reprend automatiquement dès que l'environnement l'autorise.

Une demande explicite d'action vaut autorisation pour cette action et ses étapes réversibles nécessaires. Par exemple, « ajoute une carte », « crée le work item », « synchronise Trello » ou « prépare cette amélioration » autorise la création ou la mise à jour correspondante. Ne jamais demander ensuite « confirmes-tu ? », « puis-je la créer ? » ou afficher un bouton de confirmation pour la même action. Une question supplémentaire n'est permise que si elle porte sur une décision métier, une action irréversible, une dépense, un accès externe ou une information réellement manquante.

Dans un flux de livraison explicitement autorisé, la fusion d'une PR déjà créée vers la branche d'intégration (`dev` ou `develop`) est une étape réversible prévue et doit être exécutée automatiquement dès que la PR est ouverte, propre et fusionnable. L'absence de contrôle CI ou de revue humaine configurée doit être enregistrée comme preuve manquante, mais ne constitue pas à elle seule une demande de confirmation. Ne demander une intervention que si une protection de branche l'exige, si un contrôle échoue, si une revue obligatoire manque, ou si une décision métier, une dépense, un secret ou une action irréversible est nécessaire.

Lorsqu'une intégration Trello déjà autorisée est disponible, une demande explicite de publier, corriger ou synchroniser un commentaire vaut autorisation d'écriture externe réversible. Ne pas demander une seconde confirmation juste avant l'envoi. Demander uniquement l'activation d'un accès absent, un secret, une dépense, une action irréversible ou une décision réellement manquante, puis vérifier visuellement le commentaire après publication.

Après chaque action, l'agent choisit immédiatement l'étape suivante selon cet ordre :

1. Corriger l'échec observé.
2. Exécuter le contrôle qui manque.
3. Traiter la prochaine tâche autonome du work item ou de la carte.
4. Mettre à jour les preuves, les journaux et les intégrations.
5. Reprendre la boucle jusqu'à la Definition of Done.

## Boucle obligatoire

1. Capturer le message complet, la commande, le code de sortie et le contexte.
2. Classer l erreur : code, dépendance, configuration, environnement, contrat, sécurité ou décision manquante.
3. Consulter d abord le dépôt, les logs et les documents officiels de la technologie concernée.
4. Rechercher sur internet si l information peut avoir changé ou si la documentation locale ne suffit pas. Privilégier les sources officielles et conserver les URLs consultées dans le work item ou l ADR.
5. Choisir la correction la plus sûre et la plus petite, puis l appliquer.
6. Rejouer le contrôle échoué et les tests de non-régression pertinents.
7. Répéter dans une limite documentée. Chaque tentative doit produire un résultat observable.
8. Continuer la conversation avec l’état, les corrections effectuées et le prochain contrôle, sauf blocage réel. Ne pas demander à l’utilisateur d’écrire « Continue » ou une approbation intermédiaire pour une étape déjà autorisée par le cahier et le work item.
9. Si la correction est partielle, poursuivre immédiatement avec l’étape suivante compatible, tout en consignant la limite résiduelle. Une erreur d’environnement ne doit pas interrompre les parties indépendantes du projet.

## CI et dette historique

Une CI en cours n’est jamais une conclusion. L’agent attend le résultat, relit les logs, corrige le premier échec, republie si nécessaire et relance les contrôles jusqu’à réussite, limite documentée ou blocage réel. Une dette historique détectée dans la zone du work item est traitée par petits lots jusqu’à la Definition of Done. Une dette hors périmètre reçoit un work item documenté et le travail indépendant continue.

Une preuve négative ou un résultat observable non conforme, notamment `404`, déploiement absent, endpoint indisponible, test échoué ou revalidation externe négative, ne constitue jamais une conclusion ni une simple information à transmettre. Le Coordinateur doit identifier la cause, corriger le problème, déployer ou appliquer l'alternative autorisée, puis revalider le résultat et poursuivre la boucle. Il ne demande pas à l'utilisateur de lui dire de continuer. Si l'action exige un accès, un secret, une dépense, une décision métier ou une autorisation de production absente, il prépare toutes les étapes réversibles et passe en `needs-review` avec la demande précise ; sinon il continue jusqu'à réussite ou blocage réel prouvé.

## Corrections réversibles

Une correction de dépendance non majeure, un formatage, un lint, un test ou une configuration locale réversible est autorisé dans le work item courant. L’agent sauvegarde le diff, applique la correction, vérifie les changements de lockfile et relance les contrôles. Il ne demande pas « Continue » ni une approbation intermédiaire. Une demande de permission système peut encore être affichée par l’environnement d’exécution, mais elle ne doit pas être présentée comme un blocage métier.

## Autonomie autorisée

L agent peut choisir seul une dépendance compatible, une commande de test, une correction locale, une configuration réversible, une baseline technique documentée ou une stratégie de diagnostic. Il doit créer un ADR pour les choix structurants.

## Blocages réels

Une demande humaine reste nécessaire uniquement pour une décision métier, une action irréversible ou destructive, un accès externe, un secret, une dépense, une obligation réglementaire, un risque critique ou une ambiguïté qui change le produit. Dans ce cas, regrouper les questions et proposer un choix recommandé.

Avant de déclarer un blocage, l'agent doit :

1. Vérifier le dépôt, le profil, le cahier, les logs et la documentation officielle.
2. Rechercher sur Internet si l'information peut avoir changé.
3. Essayer l'alternative réversible et officiellement supportée.
4. Poursuivre les tâches indépendantes qui ne dépendent pas du blocage.
5. Documenter la commande, le résultat, la cause, les alternatives essayées et l'action attendue.

Une intégration absente, une commande indisponible, une CI en attente, un plugin non activé ou une API temporairement inaccessible ne justifie pas l'arrêt global. L'agent utilise le mode local documenté, prépare les données à synchroniser, conserve un checkpoint et reprend la synchronisation dès que l'intégration est disponible.

## Interdictions

Ne jamais inventer une source, masquer un échec, désactiver un contrôle pour obtenir du vert, utiliser `--no-verify`, contourner une sécurité ou déclarer une validation non exécutée. Une recherche internet informe une décision, mais ne remplace pas un test local. Une commande non supportée doit être remplacée par l’alternative officielle compatible avec l’environnement, puis vérifiée. Les modifications existantes hors périmètre doivent être préservées et signalées, jamais écrasées.

## Continuité après fusion

La fusion d’une Pull Request est un checkpoint technique et jamais une clôture automatique du work item ou de la carte Trello. Après une fusion réussie, relire immédiatement la checklist, identifier la prochaine action et reprendre le travail jusqu’à la Definition of Done. Ne pas attendre un nouveau message utilisateur et ne pas demander « Continue » pour une étape déjà autorisée.

Si des éléments de la carte restent ouverts, maintenir la carte dans son état approprié, créer ou sélectionner le prochain work item, exécuter les validations nécessaires et synchroniser Trello après chaque étape. Arrêter uniquement pour un blocage réel, une décision humaine requise ou une action sensible non autorisée.

## Interdiction d'arrêt silencieux

Il est interdit de conclure par un simple état intermédiaire tel que « la CI est en cours », « la PR est ouverte », « il reste des tests », « il reste des traductions » ou « une erreur a été trouvée » lorsque l'agent peut attendre, corriger, tester ou poursuivre. Le rapport doit indiquer l'action immédiatement engagée et l'exécution doit continuer dans la même autorisation.
