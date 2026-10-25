# Découverte fiable des outils

Avant de déclarer un outil indisponible, le Coordinateur doit effectuer une recherche complète et observable. Vérifier successivement le `PATH` courant, les emplacements système et utilisateur usuels, les gestionnaires d environnements et de paquets présents, les binaires embarqués par l IDE ou le terminal, les scripts locaux du projet et les intégrations déjà exposées par la session. Pour Python, rechercher notamment `python3.12`, `python3`, `uv`, les environnements `.venv` et les chemins gérés par pyenv ou uv ; `python3` en 3.9 ne suffit pas à conclure que `tomllib` est absent si Python 3.11 ou plus récent est installé ailleurs.

Pour chaque emplacement pertinent, utiliser une vérification adaptée au système, confirmer que le binaire ou service répond à une commande d identité ou de version, puis vérifier son authentification et son périmètre. Une commande qui échoue à cause du `PATH` ne constitue jamais une preuve d absence.

Le Coordinateur doit aussi inspecter les variables d environnement non sensibles, les fichiers de configuration applicables et les chemins documentés par le projet, sans afficher de secret. Il doit comparer au besoin le résultat entre le shell de l IDE, le terminal utilisateur et le shell d exécution.

Si l outil est trouvé hors `PATH`, utiliser son chemin absolu ou enrichir uniquement le `PATH` de la session, puis relancer la vérification. Ne jamais installer, activer, payer ou transmettre une donnée à un service sans l autorisation applicable. Si aucune instance utilisable n est trouvée après cette procédure, enregistrer les recherches, les erreurs et les alternatives tentées avant de déclarer le blocage.

Si l outil est absent, le Coordinateur doit exécuter `scripts/ensure-tools.sh --bootstrap` avec le manifeste du kit et du projet. L’installation utilise exclusivement le registre partagé `AGENTIC_TOOLS_HOME`, son préfixe npm central ou son environnement Python central, de manière idempotente et gratuite. Après installation, le chemin absolu et la version sont relus depuis le registre. Un outil installable dans ce registre ne peut jamais être présenté comme indisponible.

Pour un daemon local connu, une commande qui échoue ne suffit jamais à déclarer `blocked`. Après avoir vérifié le binaire, le Coordinateur exécute le garde-fou de démarrage correspondant, notamment `.claude/scripts/ensure-docker-ready.sh` pour Docker, attend un état prêt et relance le contrôle. Le démarrage reste limité aux services locaux, gratuits et autorisés. Un blocage n est recevable qu après échec observable du démarrage, permission manquante ou décision externe réellement indispensable.

Une conclusion d indisponibilité doit mentionner les emplacements vérifiés, la commande de version ou d identité, l état d authentification, les alternatives disponibles et la prochaine action. Une simple sortie `command not found` est insuffisante.

Pour GitHub, exécuter `.claude/scripts/verify-github-access.sh` avant tout blocage. Les résultats distinguent les états suivants :

- `DNS_RESOLUTION_FAILED` : le processus courant ne résout pas le nom demandé. Cela ne prouve ni une panne de GitHub ni une panne DNS macOS. Vérifier le résolveur système hors sandbox avant toute conclusion.
- `SANDBOX_LIMITATION` : le processus est bloqué par une permission ou une restriction d'exécution. Relancer dans un contexte réseau renforcé, le shell de l'IDE ou le navigateur connecté.
- `NETWORK_ACCESS_UNVERIFIED` : un échec réseau initial ne permet pas de conclure. Relancer `verify-github-access.sh --after-network-enabled-retry` depuis un contexte où l'accès réseau renforcé est effectivement actif.
- `GITHUB_EXTERNAL_UNAVAILABLE` : ne peut être émis qu'après cette relance explicite, pour un échec non lié à la résolution DNS ou à une permission. C'est alors seulement une preuve d'indisponibilité externe.

Le résultat de `gh auth status` est distinct du test DNS/HTTP : une authentification non vérifiée dans le contexte courant ne prouve pas que le jeton est invalide ni que GitHub est indisponible. Vérifier séparément l'authentification dans le contexte réseau approprié.

Un endpoint public en HTTP 200 ne prouve pas un accès d'administration VPS, Dokploy ou préproduction. Avant de conclure à l'absence d'accès, le Coordinateur doit créer ou activer l'agent DevOps et vérifier les chemins autorisés disponibles : binaire `ssh`, configurations et agents SSH, `gh`, variables non sensibles, navigateur déjà connecté, URL Dokploy, connecteurs et outils du projet. Il ne demande jamais un secret dans le dépôt et ne modifie pas la production sans autorisation explicite.
