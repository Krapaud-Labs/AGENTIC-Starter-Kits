# Système visuel Trello

Cette politique complète `PROJECT-TRACKER-VISUAL-SYSTEM.md` uniquement lorsque Trello est le gestionnaire choisi dans le profil du projet. Elle ne rend pas Trello obligatoire.

## Langue

Tout contenu rédigé dans Trello est en français. Les commandes, identifiants, URL, noms de branches et extraits de journaux peuvent conserver leur forme technique. Les explications qui les accompagnent restent en français.

## Statuts et listes

Les trois statuts canoniques sont `Todo`, `In Progress` et `Done`, dans cet ordre. Réutiliser les listes existantes lorsque leur correspondance est claire. Les états de blocage, de revue, de priorité, d’échéance ou d’archivage sont représentés par des étiquettes ou métadonnées, jamais par des colonnes supplémentaires. La taille de l’équipe et les phases MVP ne créent pas de colonnes supplémentaires.

## Étiquettes

Réutiliser les étiquettes existantes par nom et créer uniquement celles qui manquent. Les étiquettes doivent distinguer le type et le domaine lorsque c’est utile. Une étiquette de blocage, de risque ou de priorité décrit un attribut, pas un statut. Le titre, la première partie de la description et la checklist restent compréhensibles sans couleur.

## Description et tâches

Utiliser de vrais retours à la ligne et des cases de checklist. Indiquer le périmètre, les dépendances, l’ordre, les critères d’acceptation, les preuves attendues, les risques et le retour arrière lorsque c’est pertinent. Ne pas encoder les sauts de ligne avec les caractères littéraux `\n`.

## Synchronisation et relecture

Relire l’état distant après chaque écriture. Regrouper les écritures locales connexes et effectuer une relecture complémentaire aux checkpoints importants : fin de lot, blocage ou reprise, livraison, PR, CI et fusion. Vérifier les champs réellement modifiés et la prochaine tâche ouverte. Éviter une synchronisation pour chaque micro-événement local. Si Trello est indisponible, noter l’événement localement sans prétendre que le tableau est synchronisé.
