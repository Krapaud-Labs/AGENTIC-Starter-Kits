---
name: trello-planning
description: Construit un tableau Trello détaillé à partir du cahier, de la conception et des audits après accord utilisateur.
---

# Skill trello-planning

## Objectif

Transformer le cahier des charges, la conception et les résultats d audit en un tableau Trello complet, détaillé et synchronisable.

## Quand l utiliser

Uniquement après une réponse utilisateur positive au choix Trello et après acceptation du cahier des charges. Le tableau complet versionné est toujours créé dans `docs/project-management/trello-board.md`. Après une réponse `oui`, l agent passe par les états `pending_activation`, `syncing`, `verified` ou `blocked`. Il doit d abord rechercher les intégrations et connecteurs Trello déjà disponibles dans la session, puis les utiliser directement. Il ne doit jamais installer `uv`, un plugin, un navigateur ou un outil externe pour remplacer une intégration déjà connectée, ni demander cette installation sans demande explicite de l utilisateur. Il doit créer réellement le tableau sur Trello avec l intégration connectée. Il ne doit jamais s arrêter au fichier local si l intégration est disponible. Si aucun outil Trello n est effectivement exposé, enregistrer `pending_activation`, fournir le fichier local prêt à synchroniser, journaliser le checkpoint et poursuivre les tâches indépendantes ; ne jamais annoncer une synchronisation distante réussie.

## Système visuel obligatoire

Lire et appliquer `policies/TRELLO-VISUAL-SYSTEM.md` avant de créer le tableau ou la première carte. Créer ou réutiliser les listes et étiquettes standardisées par nom exact, couleur et identifiant stable. Relire le rendu réel du tableau après synchronisation et corriger tout doublon, étiquette incohérente, liste mal ordonnée ou description illisible.

## Entrées

Cahier, dossier `docs/`, profil, roadmap, journal qualité, work items, contraintes, réponse Trello et liste validée des membres avec leur rôle.

## Procédure

Avant toute analyse technique, délégation, modification de fichier ou écriture de code, appliquer `policies/TRELLO-START-STATE.md` : déplacer la carte active dans `In Progress`, relire Trello et enregistrer la preuve de transition. Une carte dans `Ready`, `Review`, `Blocked` ou `Done` ne peut pas être codée sans réconciliation explicite de son état.

1. Vérifier que chaque membre possède un nom et un rôle confirmé dans `tracking.trello_members`. Si la liste est vide ou ambiguë, arrêter et demander les informations manquantes.
2. Décomposer chaque objectif et user story en petites features logiques, indépendantes autant que possible et livrables sur une branche dédiée. Une carte ne doit pas regrouper plusieurs features sans lien.
3. Ajouter les cartes de conception, développement frontend ou backend, données, tests, sécurité, documentation, CI, audit et livraison lorsque pertinentes.
4. Découper chaque carte pour qu elle corresponde à une branche et à des commits atomiques.
4 bis. Utiliser une seule branche de travail et une seule Pull Request finale par carte. Les cases de checklist, corrections et validations intermédiaires sont regroupées sur cette branche avec des commits atomiques.
5. Renseigner pour chaque carte ID, liste, feature, description détaillée, périmètre inclus et exclu, dépendances, critères d acceptation, preuve, responsable, estimation, priorité et risques.
5 bis. Avant d'ajouter une carte, un check ou un blocage découvert, vérifier sa trace dans le cahier des charges accepté, le périmètre, les critères, la conception ou une décision projet. S'il n'est pas prévu, le classer hors périmètre et ne pas l'ajouter à Trello ni au Goal actif. Une obligation légale ou de sécurité critique doit être escaladée en `needs-review` avec sa source ; elle ne peut pas être inventée.
5 ter. Lorsque la demande utilisateur demande explicitement de créer une carte, cette demande constitue déjà l'autorisation de création. Créer immédiatement la carte, son work item et ses éléments réversibles nécessaires, puis relire le résultat. Ne jamais demander « confirmes-tu la création ? », « puis-je la créer ? » ou une confirmation équivalente pour la même demande. Demander uniquement si une décision métier, une action irréversible, une dépense, un accès ou une information réellement manquante bloque la création.
5 quater. Avant toute création de carte, déterminer ses étiquettes obligatoires à partir du type, du domaine et du risque, vérifier qu'elles existent et sont nommées, puis préparer leur rattachement. Une carte ne doit jamais être créée sans labels requis prêts à être attachés. Si le connecteur ne sait pas créer ou nommer un label, utiliser immédiatement le navigateur généraliste comme complément, puis relire la carte et ses labels avant toute checklist, commentaire ou carte suivante.
5 bis. Calculer avant création l'ordre topologique des cartes et attribuer un identifiant d'exécution stable `[MVP-001]` ou `[POST-MVP-001]`. Ajouter le niveau de parallélisation, la décision de périmètre et les dépendances dans chaque carte. Les cartes au même niveau sans dépendance commune peuvent être lancées ensemble ; une carte dépendante ne commence pas avant ses prédécesseurs prouvés.
6. Ajouter à chaque carte une checklist explicite : conception à jour, code, tests, sécurité, accessibilité si applicable, documentation, revue, preuve et Definition of Done. Ajouter obligatoirement en dernière position l'item `Mettre à jour et relire les README, la documentation, le changelog et les notes de release applicables avant la PR`. Cet item est toujours le dernier à cocher avant l'ouverture de la PR de la branche associée à la carte ; la PR est interdite tant qu'il n'est pas prouvé, et la carte ne peut ensuite passer à `Done` qu'après relecture finale.
7. Ajouter les cartes de correction pour chaque entrée ouverte du journal qualité.
8. Produire `docs/project-management/trello-board.md` avant toute synchronisation externe.
8 bis. Ne jamais utiliser une carte unique d'initialisation comme substitut au plan produit. Avant la création externe, transformer chaque feature, user story, dépendance technique et étape de livraison pertinente du cahier des charges accepté en carte distincte. Une simple carte `Initialisation et conception du projet` est non conforme sauf si le projet ne contient réellement aucun objectif livrable supplémentaire, ce qui doit être justifié dans le document local.
8 ter. Appliquer un contrôle bloquant avant synchronisation : chaque carte doit avoir un identifiant stable, un titre numéroté, au moins une étiquette nommée, une description détaillée contenant propriétaire, type, priorité, périmètre, dépendances, ordre d'exécution, critères d'acceptation, risques, preuve attendue et Definition of Done, ainsi qu'une checklist adaptée. Si un de ces éléments manque, rester en `syncing`, corriger la source locale et ne pas créer ou déclarer le tableau vérifié.
8 quater. Les cartes macro ou épics ne remplacent jamais les cartes d'exécution. Une carte macro peut rester comme synthèse uniquement si elle référence toutes ses cartes enfants ; elle ne compte pas dans la couverture détaillée et ne peut pas être la seule carte d'une phase. Pour chaque document de conception, fonctionnalité, parcours, modèle de données, contrat API, règle de sécurité, écran, intégration, migration, test, validation externe et livraison prévu, créer une carte ou un check détaillé traçable. Chaque carte enfant possède son propre objectif, périmètre, dépendances, responsable, étiquette, critères, preuve et checklist.
9. Lire `tracking.trello_board_id` et `tracking.trello_sync_status`. Si un identifiant existe, reprendre le tableau existant. Sinon, rechercher un tableau de même nom avant toute création afin d’éviter un doublon.
10. Le connecteur Trello est prioritairement utilisé en lecture-écriture : il réalise les lectures, créations, modifications, déplacements, étiquetages et checklists qu'il expose. Après chaque lot connecteur, relire son résultat. Ensuite seulement, utiliser le navigateur généraliste existant pour vérifier visuellement le rendu et compléter uniquement les éléments que le connecteur n'a pas pu créer ou modifier. Après chaque complément navigateur, relire à nouveau via le connecteur et visuellement. Le navigateur sert aussi à GitHub, VPS, Dokploy et aux autres services autorisés ; il ne doit pas être dédié à Trello. Ne jamais créer un navigateur vierge ou importer un profil lorsqu'une session existante est contrôlable.
11. Avec l’intégration Trello disponible, passer à `syncing`, rechercher le workspace cible, créer ou reprendre le tableau avec une visibilité adaptée, puis créer les listes manquantes dans l’ordre défini.
12. Dimensionner les colonnes de travail selon `min(4, max(1, ceil(active_members / 2)))`, après déduplication et validation des membres. Conserver les listes de gouvernance standard et créer une seule colonne `In Progress` pour une équipe de une ou deux personnes. Pour une équipe plus grande, suffixer les colonnes de travail (`In Progress 1`, etc.) et documenter leur responsable ou groupe.
12 bis. Si le périmètre contient à la fois du MVP et du Post-MVP, séparer visuellement les files de travail par phase (`MVP - À développer`, `Post-MVP - À développer`, puis leurs colonnes de travail si nécessaire). Ne jamais créer une colonne Post-MVP vide ou y déplacer une carte sans décision de scope documentée.
13. Avant toute carte, créer ou réutiliser dans Trello toutes les étiquettes normalisées requises avec leur nom et leur couleur. Si l'écriture native des étiquettes n'est pas exposée, ouvrir automatiquement le navigateur Trello déjà disponible, accéder au tableau par son URL ou son identifiant et créer les étiquettes depuis l'interface ; ne jamais demander à l'utilisateur de choisir un navigateur et ne jamais considérer la synchronisation comme réussie sans cette étape. Ensuite seulement, créer ou reprendre chaque carte par son identifiant stable ou son titre préfixé, rattacher les étiquettes et créer la checklist. Une carte sans étiquette nommée requise est invalide.
14. Relire le tableau, les listes, les cartes, les étiquettes et les checklists depuis Trello. Vérifier que chaque étiquette attendue existe avec son nom exact et qu'elle est réellement rattachée à chaque carte concernée. Une carte sans étiquette requise est incomplète et ne peut pas être déplacée vers `Ready`, `Review` ou `Done`. Conserver les identifiants et URLs dans `docs/project-management/trello-board.md`, puis passer `trello_sync_status` à `verified` uniquement si le tableau, les listes, les cartes, les étiquettes, les checklists et les membres attendus sont relus avec succès.
14 bis. Comparer le nombre et la couverture des cartes Trello avec la matrice des features du cahier des charges. Toute feature non couverte, carte sans étiquette, description courte ou checklist manquante doit déclencher une correction immédiate et une nouvelle relecture, jamais une clôture partielle.
14 ter. Refuser la validation d'un tableau qui ne contient que des cartes macro, même si leur nombre paraît élevé. Produire une matrice `source de conception → carte détaillée → preuve attendue` et vérifier qu'aucune ligne du cahier des charges ou des documents de conception ne reste uniquement couverte par une carte de synthèse.
14 quater. Après chaque demande de création de carte, relire immédiatement le tableau et vérifier l'existence, le titre, la liste, les étiquettes, la description et la checklist de la carte réellement créée. Tant que cette preuve n'est pas obtenue, ne jamais préparer ni démarrer la carte suivante ; corriger la création manquante via le navigateur généraliste si nécessaire.
14 quinquies. Juste avant de terminer l'initialisation Trello, effectuer un audit final carte par carte. Pour chaque carte, vérifier depuis le connecteur puis visuellement si nécessaire l'identifiant, le titre, la liste, l'ordre, les labels nommés et rattachés, la description complète, le périmètre, les dépendances, le responsable, la checklist, la Definition of Done et la preuve attendue. Comparer chaque carte au cahier des charges, aux documents de conception et à la matrice de couverture ; corriger immédiatement tout manque ou doublon, puis refaire la relecture. L'initialisation ne peut être déclarée terminée qu'après cette passe complète.
14. Synchroniser le statut Trello avec les work items, la roadmap et le journal qualité à chaque livraison. Cette synchronisation est immédiate après chaque étape validée, chaque fusion de Pull Request, chaque correction et chaque changement de statut, sans attendre la fin de la carte.
15. Relire sur Trello la carte précise, sa liste, sa description, sa checklist et ses cases cochées après chaque synchronisation. Comparer cette lecture avec le work item et refuser le statut `complete` si une case livrée n’est pas cochée ou si la carte n’est pas dans la liste attendue.
16. En cas d’écart, corriger Trello immédiatement, mettre à jour le fichier local et conserver dans le journal la date, l’identifiant de carte, l’URL, l’action effectuée et la preuve de relecture.

### Répartition parallèle des cartes multi-lots

Si une carte comporte au moins deux cases indépendantes et que leur exécution parallèle réduit réellement le délai, le Coordinateur doit créer ou activer plusieurs agents et répartir les lots avant le démarrage. Il renseigne pour chaque lot l'agent, les fichiers autorisés, les dépendances, le responsable et la preuve attendue, puis synchronise l'assignation et la checklist Trello avant le démarrage. Les lots qui touchent le même fichier, un contrat partagé, une migration, une décision d'architecture ou une validation dépendante restent séquentiels et cette décision doit être justifiée dans le Goal.

Les agents parallèles travaillent dans des espaces isolés si nécessaire. Le Coordinateur intègre ensuite leurs résultats sur la branche unique de la carte, résout les conflits, synchronise chaque transition et fait exécuter l'audit final. Une carte ne passe pas à `Done` tant que tous les lots, preuves et contrôles ne sont pas relus.

Pour une famille de tâches homogènes, plusieurs agents du même rôle peuvent travailler en parallèle sur des cartes, fichiers, parcours, lignes de données ou lots de checklist distincts. Le Coordinateur désigne un agent intégrateur, vérifie les partitions avant lancement, interdit les doublons et ne valide qu'après assemblage, tests et relecture de toutes les preuves.

Lors de la création d'un Goal pour une carte contenant au moins deux cases ouvertes indépendantes, inscrire dans le Goal la création ou l'activation des agents parallèles, la partition de chaque lot et l'agent intégrateur avant de commencer. Synchroniser ces responsables dans Trello et conserver une seule branche et une seule PR finale pour la carte.

### Rythme obligatoire des transitions et preuves

Une synchronisation Trello correspond à un événement significatif, jamais à un lot différé. Le Coordinateur doit synchroniser puis relire la carte immédiatement après chacun de ces événements : entrée ou sortie d'une colonne, assignation ou changement de responsable, ajout ou clôture d'une case, début ou fin d'un work item, commit ou push livrable, ouverture ou mise à jour d'une PR, résultat CI, correction, blocage, déblocage, validation externe et fusion. La relecture doit confirmer l'identifiant de la carte, la colonne, le responsable, la checklist, la description et la preuve associée avant toute action suivante.

Il est interdit de regrouper plusieurs transitions ou preuves dans une seule mise à jour de fin de lot. Une panne Trello autorise uniquement un checkpoint local horodaté avec l'événement, la tentative, l'erreur, la prochaine action et le statut `pending_activation` ou `blocked`; dès que l'intégration revient, les événements sont rejoués dans l'ordre et relus un par un. Une carte ne peut passer à `Done` qu'après la dernière synchronisation et sa relecture réussie.

## Échéances et pauses contrôlées

Une date limite Trello ne suspend jamais tout le projet par défaut. Si une carte ne peut commencer avant sa date, la marquer `time-gated`, enregistrer la date ISO, la raison, les dépendances et la prochaine action dans le work item et `RUNTIME-STATE.md`. Suspendre uniquement cette carte et ses dépendances directes. Continuer les cartes indépendantes autorisées.

À la date prévue, reprendre la carte au prochain checkpoint, relire son état Trello et vérifier que la condition d’entrée est toujours vraie. Ne pas poller inutilement ni inventer un réveil automatique que l’environnement ne fournit pas. Une échéance dépassée déclenche une réévaluation, pas un contournement de contrôle.

## Enchaînement automatique des cartes autorisées

Lorsqu'une demande utilisateur autorise un lot, la finalisation du tableau ou l'exécution jusqu'à la Definition of Done, la clôture vérifiée d'une carte déclenche immédiatement une relecture du tableau et la sélection de la prochaine carte. Le Coordinateur choisit la première carte dans l'ordre Trello qui est dans `Ready` ou reprenable, sans dépendance ouverte, échéance bloquante ou blocage documenté, et qui possède un propriétaire, un périmètre et une Definition of Done vérifiables.

Il déplace cette carte dans `In Progress`, initialise ou reprend son work item, met à jour `current_action` et `next_action`, puis exécute la première case autonome dans le même cycle d'autorisation. Il ne demande pas « Continue » pour une carte éligible. S'il n'existe aucune carte éligible, il documente les cartes ignorées et leur raison, puis termine uniquement avec `complete`, `needs-review` ou `blocked`. Cette règle ne s'applique pas à une demande explicitement limitée à une seule carte.

## Sortie

Un tableau réellement créé et vérifié sur Trello, ou un blocage externe documenté avec le tableau local complet, sans tâche implicite, avec traçabilité cahier, code, tests et audit.

## Mesures

Stories couvertes, cartes sans critères, cartes bloquées, tâches orphelines, écarts entre le tableau et le dépôt, délai de mise à jour et tâches reprises.

## Arrêt

Arrêter si la réponse utilisateur est absente, si le périmètre est ambigu, si une carte critique manque de responsable ou si l intégration externe n est pas autorisée.

Une carte ne peut être déplacée dans `Terminé` que si toutes ses cases, y compris les validations juridiques, métier, réglementaires, client ou externes, sont prouvées. Une publication technique ne suffit pas. Lorsqu’une carte doit précéder une autre, enregistrer la dépendance et ne pas démarrer la suivante avant la clôture conforme de la première, sauf instruction explicite contraire.

## Format des descriptions

## Règle de Pull Request par carte

Une carte Trello correspond par défaut à une branche de travail et à une seule Pull Request finale. Les commits restent atomiques et couvrent les étapes de la checklist, mais l'agent ne crée pas de PR pour chaque contrôle, sous-tâche, correction ou document. Si une PR existe déjà pour la carte, il la met à jour jusqu'à la Definition of Done. Une PR intermédiaire exige une demande explicite de l'utilisateur ou une justification critique documentée.

Les descriptions, commentaires et checklists envoyés à Trello doivent contenir de vrais retours à la ligne, jamais la séquence littérale `\n`. Construire le texte avec des chaînes multilignes ou des retours à la ligne natifs, puis vérifier après relecture que Trello affiche des paragraphes et des listes lisibles. Normaliser les échappements avant l’appel API, sans modifier les URLs, le code ou les exemples qui doivent conserver leur syntaxe.

Les commentaires Trello doivent respecter exactement ce format : rédaction exclusivement en français, une phrase par ligne séparée par un vrai retour à la ligne, sans tiret, puce, numérotation ni titre séparé. Commencer directement par les informations importantes, terminer chaque phrase par un point, éviter les caractères pouvant ouvrir des menus automatiques, rester clair, factuel, professionnel et concis, mentionner les preuves vérifiées ainsi que les éléments non vérifiés ou bloqués, et ne cocher une tâche que lorsque sa preuve est confirmée. Saisir le commentaire complet, puis le vérifier visuellement après son enregistrement. Tout commentaire non conforme ou non vérifié doit être corrigé immédiatement.

Une demande explicite de publier ou de corriger un commentaire autorise sa publication lorsque Trello est déjà connecté. Ne pas demander « publie », « confirme » ou une confirmation équivalente une seconde fois ; exécuter l'envoi, fermer toute autocomplétion ouverte et relire visuellement le contenu réellement enregistré.
Limiter la cadence pour éviter la stagnation : publier un commentaire d'ouverture, puis uniquement une synthèse lors d'un changement significatif, d'une preuve nouvelle, d'un blocage ou d'un déblocage. Ne jamais commenter chaque micro-étape, commande, fichier ou sous-tâche. En l'absence de changement significatif, poursuivre l'exécution au lieu d'ajouter un commentaire. Une carte ne doit pas accumuler des commentaires redondants ; regrouper les détails dans la synthèse de progression et clôturer par une synthèse finale avec les preuves, les éléments bloqués et la prochaine action.

Avant chaque nouvelle mise à jour d'une carte, relire également les commentaires et preuves déjà présents dans son activité. Toute preuve antérieure partielle, vide, tronquée ou publiée avec un menu d'autocomplétion doit être corrigée ou remplacée avant d'ajouter un nouveau commentaire. Ne jamais déclarer la carte correctement synchronisée sans cette relecture historique.

Après création ou modification, relire le champ description depuis Trello et contrôler l’absence de `\n` littéraux, de doublons, de titres collés ou de listes mal rendues. Si le rendu est incorrect, corriger immédiatement avant de déclarer la synchronisation vérifiée.

La fusion d’une PR ne clôture jamais une carte. Après chaque fusion, relire la checklist, reprendre immédiatement la prochaine étape ouverte et poursuivre jusqu’à la Definition of Done réelle.

## Exécution continue obligatoire

Après une livraison partielle, ne pas rendre la main si la carte comporte encore une case autonome ouverte. Relire la carte, choisir la prochaine case dans l'ordre des dépendances, ouvrir ou reprendre son work item et exécuter la suite. Un simple compte rendu comme « il reste les traductions » est insuffisant : il doit être suivi de l'action suivante dans la même autorisation continue. Le message final est autorisé uniquement après `complete`, `needs-review` ou `blocked` avec la preuve correspondante.

## Protocole de session d'une carte

Au début de chaque carte, le Coordinateur crée ou reprend un work item et annonce explicitement : `Session continue active pour la carte <ID> jusqu'à la Definition of Done.` Il ne produit ensuite aucun message de statut sans lancer dans le même tour l'action annoncée. Les formulations « je poursuis », « il reste à faire » ou « je vais traiter » sont interdites si elles ne sont pas immédiatement suivies d'une commande, d'une délégation ou d'une modification observable.

Après chaque action observable, le Coordinateur exécute la prochaine action de la checklist dans la même session. Il ne transforme pas un checkpoint technique en fin de tour. La session ne se termine qu'après relecture de Trello et preuve de `complete`, `needs-review` ou `blocked`.
