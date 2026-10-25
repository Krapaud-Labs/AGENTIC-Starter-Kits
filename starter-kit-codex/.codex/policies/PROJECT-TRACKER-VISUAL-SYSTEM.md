# Système commun des gestionnaires de projet

Cette politique est la source de vérité pour Trello et GitHub Projects. Les mêmes règles de langue, de structure, de numérotation, d'étiquetage, de checklist, de synchronisation, de délégation et de clôture s'appliquent quel que soit le gestionnaire choisi.

## Langue et rédaction

Tout contenu créé ou édité par le kit est rédigé en français, y compris les noms, titres, descriptions, tâches, commentaires, décisions et preuves. Les commandes, identifiants, URLs, noms de branches et extraits de logs peuvent conserver leur forme technique. Les libellés natifs par défaut de la plateforme, ses champs système, ses vues, ses couleurs et ses paramètres ne sont pas renommés ni remplacés sauf demande explicite. Une information par ligne, sans titre séparé, gras, numérotation manuelle, tiret cadratin, caractère déclenchant une autocomplétion ou ponctuation ambiguë. Chaque phrase se termine par un point. Après publication, relire le contenu réellement affiché. Ne jamais demander une confirmation pour une écriture explicitement demandée.

## Statuts et ordre

Utiliser uniquement trois statuts dans cet ordre : `Backlog`, `In progress`, `Done`. Les détails de conception, validation, blocage et phase sont portés par la description, les labels, les tâches et les preuves, pas par des colonnes supplémentaires. `Done` exige la preuve de chaque tâche, la documentation finale, la PR fusionnée et la relecture distante.

Les colonnes de travail sont dimensionnées selon les membres actifs : `min(4, max(1, ceil(active_members / 2)))`. Une ou deux personnes utilisent une colonne, trois ou quatre deux, cinq à huit trois et au-delà quatre maximum. Ne jamais créer une colonne vide par personne.

## Numérotation, description et labels

Attribuer avant création un identifiant stable et topologique au format `[MVP-001]` ou `[POST-MVP-001]`. Ne jamais renuméroter un élément publié. Le titre est court, français, unique et orienté action.

La description commence par Owner, Type, Priority, Dependencies, Execution order, Phase, Parallel group, Scope decision et Definition of Done, puis contient Context, Scope, Implementation plan, Acceptance criteria, Evidence, Risks, Rollback et Definition of Done. Les tâches utilisent de vraies cases Markdown, une par preuve.

Pour une carte terminée, le contenu utilise des rubriques Markdown explicites : `## Contexte`, `## Objectif`, `## Périmètre`, `## Réalisation attendue`, `## Critères d'acceptation`, `## Preuves`, `## Risques`, `## Retour arrière` et `## Définition de terminé`. Les preuves historiques restent dans `## Preuves` et les tâches prouvées sont cochées dans une checklist Markdown. Le titre conserve un identifiant stable et une formulation d'action, sans préfixe de statut ajouté après publication. Une carte existante mal formée est corrigée lors de la prochaine relecture sans perdre son contenu historique.

Réutiliser ou créer les labels nommés `Fonctionnalité`, `Anomalie`, `Sécurité`, `Architecture`, `Frontend`, `Backend`, `Données`, `DevOps`, `Documentation`, `Qualité`, `Bloqué`, `Priorité haute` et `Validation externe`, avec leurs couleurs documentées. Chaque élément possède au moins un label de type et un label de domaine. Les labels restent compréhensibles sans la couleur.

## Démarrage et progression

Avant tout code, déplacement, délégation ou validation, relire l'élément distant, son identifiant, son statut, son propriétaire, son périmètre, ses dépendances, ses labels, sa checklist et sa Definition of Done. Le work item, le Goal et l'état runtime doivent utiliser le même identifiant.

Traiter les tâches dans l'ordre des dépendances. Pour chaque tâche, travailler, tester, enregistrer la preuve, cocher uniquement cette tâche, publier la preuve, relire l'élément et seulement ensuite commencer la suivante. Une tâche sans preuve relue reste ouverte.

Si au moins deux tâches sont indépendantes et que le parallélisme est utile, créer réellement plusieurs agents spécialisés, enregistrer leurs identifiants et leurs périmètres, puis faire intégrer leurs résultats par le Coordinateur. Les tâches dépendantes ou partageant un fichier restent séquentielles.

## Synchronisation et commentaires

Utiliser d'abord le connecteur en lecture-écriture. Utiliser ensuite le navigateur uniquement pour les fonctions non exposées ou pour la vérification visuelle. Après chaque création, modification, assignation, changement de statut, checklist, correction, commit, push, PR, CI, blocage, déblocage ou fusion, relire l'état distant avant toute action suivante.

Les commentaires et preuves sont concis, factuels, en français, une information par ligne, sans marqueur manuel. Ils indiquent les preuves vérifiées et les éléments non vérifiés ou bloqués. Ne cocher aucune tâche sur une simple intention. Vérifier le texte rendu après sauvegarde et corriger immédiatement toute troncature, menu d'autocomplétion ou format incorrect.

## Adaptation aux services

Dans Trello, les statuts sont des listes, les labels sont les étiquettes, les tâches sont une checklist et les commentaires sont les commentaires de carte.

Dans GitHub Projects, les statuts utilisent par défaut les options natives existantes du champ `Status`, les éléments suivis sont des Issues ou des Pull Requests, les labels sont les labels du dépôt, et les tâches sont une liste de tâches Markdown dans l'Issue. Un `Draft Issue` est réservé au brouillon d'intake non suivi. Dès qu'un élément reçoit un identifiant stable, un propriétaire, des tâches, une Definition of Done, un statut de travail ou une branche, le Coordinateur le convertit immédiatement en Issue réelle et relit le nouvel élément. Une carte ne peut jamais être `Terminé` tout en restant `Draft Issue`. Lors de l'audit d'un Project existant, convertir les brouillons déjà terminés en Issues en conservant le titre, le corps et le statut, puis relire chaque conversion. Ne pas renommer, supprimer ou remplacer les options, champs, vues ou paramètres natifs sauf demande explicite. GitHub Projects n'ayant pas toujours de checklist native, ne jamais prétendre qu'une tâche est synchronisée sans relire le corps de l'Issue et l'élément du Project. Conserver le numéro du Project, l'ID de l'élément, le numéro de l'Issue, les IDs des champs, les URLs et la vue Kanban dans le document local.

Pour GitHub Projects, conserver les champs et vues natifs et utiliser uniquement le contenu français dans les Issues, descriptions, tâches, commentaires et preuves. Réutiliser les labels existants par nom et couleur et créer uniquement les labels manquants si nécessaire. Une Issue et son élément Project forment une seule carte logique. Toute modification de l'un exige la relecture des deux.

## Livraison

Une carte correspond par défaut à une branche de travail et une seule PR finale. Pendant le travail, seuls les commits et pushes de la branche dédiée sont autorisés. La PR vers `dev` ou `develop` est créée uniquement après la dernière tâche, la mise à jour et relecture des README, de la documentation, du changelog et des notes de release, puis la validation de la Definition of Done. La fusion et la mise à jour de `dev` sont nécessaires avant la promotion vers `main`.

Ne jamais marquer `Terminé` ou `Done` sur une PR seulement créée ou sur une CI verte. Après la PR et après la fusion, relire le Project ou le tableau, l'élément, toutes les tâches et les preuves. Si le service est indisponible, journaliser l'événement localement sans prétendre à une synchronisation distante, puis rejouer les événements dans l'ordre dès son retour.
