# Découverte fiable des outils

Avant de déclarer un outil indisponible, le Coordinateur doit effectuer une recherche complète et observable. Vérifier successivement le `PATH` courant, les emplacements système et utilisateur usuels, les gestionnaires d environnements et de paquets présents, les binaires embarqués par l IDE ou le terminal, les scripts locaux du projet et les intégrations déjà exposées par la session. Pour Python, rechercher notamment `python3.12`, `python3`, `uv`, les environnements `.venv` et les chemins gérés par pyenv ou uv ; `python3` en 3.9 ne suffit pas à conclure que `tomllib` est absent si Python 3.11 ou plus récent est installé ailleurs.

Pour chaque emplacement pertinent, utiliser une vérification adaptée au système, confirmer que le binaire ou service répond à une commande d identité ou de version, puis vérifier son authentification et son périmètre. Une commande qui échoue à cause du `PATH` ne constitue jamais une preuve d absence.

Le Coordinateur doit aussi inspecter les variables d environnement non sensibles, les fichiers de configuration applicables et les chemins documentés par le projet, sans afficher de secret. Il doit comparer au besoin le résultat entre le shell de l IDE, le terminal utilisateur et le shell d exécution.

Si l outil est trouvé hors `PATH`, utiliser son chemin absolu ou enrichir uniquement le `PATH` de la session, puis relancer la vérification. Ne jamais installer, activer, payer ou transmettre une donnée à un service sans l autorisation applicable. Si aucune instance utilisable n est trouvée après cette procédure, enregistrer les recherches, les erreurs et les alternatives tentées avant de déclarer le blocage.

Pour un daemon local connu, une commande qui échoue ne suffit jamais à déclarer `blocked`. Après avoir vérifié le binaire, le Coordinateur exécute le garde-fou de démarrage correspondant, notamment `.claude/scripts/ensure-docker-ready.sh` pour Docker, attend un état prêt et relance le contrôle. Le démarrage reste limité aux services locaux, gratuits et autorisés. Un blocage n est recevable qu après échec observable du démarrage, permission manquante ou décision externe réellement indispensable.

Une conclusion d indisponibilité doit mentionner les emplacements vérifiés, la commande de version ou d identité, l état d authentification, les alternatives disponibles et la prochaine action. Une simple sortie `command not found` est insuffisante.

Pour GitHub, exécuter `.claude/scripts/verify-github-access.sh` avant tout blocage. Un échec marqué `SANDBOX_LIMITATION` signifie que le processus est limité par l'environnement d'exécution, pas que GitHub est indisponible : relancer avec l'accès réseau renforcé, le shell de l'IDE ou le navigateur connecté. Seul `GITHUB_EXTERNAL_UNAVAILABLE`, après ces alternatives, peut documenter une indisponibilité externe réelle.

Un endpoint public en HTTP 200 ne prouve pas un accès d'administration VPS, Dokploy ou préproduction. Avant de conclure à l'absence d'accès, le Coordinateur doit créer ou activer l'agent DevOps et vérifier les chemins autorisés disponibles : binaire `ssh`, configurations et agents SSH, `gh`, variables non sensibles, navigateur déjà connecté, URL Dokploy, connecteurs et outils du projet. Il ne demande jamais un secret dans le dépôt et ne modifie pas la production sans autorisation explicite.
