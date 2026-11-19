# Politique d isolation des conversations

Chaque conversation active est liée à un scope persistant dérivé de l identifiant de session, du Goal natif ou du Goal local. Le kit ne transmet jamais l historique complet d une autre conversation.

Chaque scope conserve son manifeste, son Goal, son work item, sa branche et ses rapports. Une conversation ne réutilise pas silencieusement le runtime, la branche ou les agents d un autre scope. Elle reprend uniquement un work item explicitement identifié et compatible avec sa branche.

Le Coordinateur doit exécuter `bind-session.sh` avant toute reprise. Un scope déjà lié à une autre branche est refusé afin d empêcher qu une conversation écrase le travail d une autre. Une reprise d un même work item doit réutiliser son scope et son Goal, sans en créer un second.

Les agents parallèles reçoivent un scope et un répertoire de preuve propres. Ils ne modifient jamais le runtime d une autre conversation et ne manipulent pas l index Git du checkout partagé.
