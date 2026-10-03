# Git Flow universel

## Branches obligatoires

La branche d intégration est définie dans `project-profile.toml`, habituellement `develop`. Toute modification produit commence sur une branche dédiée : `feature/<id>-<sujet>`, `fix/<id>-<sujet>`, `hotfix/<id>-<sujet>`, `chore/<id>-<sujet>`, `docs/<id>-<sujet>`, `refactor/<id>-<sujet>` ou `test/<id>-<sujet>`.

Ne jamais développer, committer ou pousser directement vers `main`, `master` ou la branche d intégration. La promotion vers ces branches passe par une Pull Request validée. Une branche ne porte qu un objectif cohérent et un seul work item actif.

## Commits atomiques

Un commit correspond à une intention vérifiable : une étape de conception, une migration, une modification fonctionnelle, des tests, une documentation liée ou une correction ciblée. Il contient le minimum de fichiers nécessaire, un message `type(scope): description` et des contrôles adaptés.

Les limites par défaut sont `75` fichiers et `1200` lignes modifiées par commit. Elles sont configurables dans `[delivery]` de `project-profile.toml` seulement après décision explicite et documentée. Un commit massif de code métier est interdit. Un lockfile ou artefact généré incompressible peut dépasser la limite uniquement dans un commit séparé, sans code métier, avec un message conventionnel et une justification dans le work item. L agent isole automatiquement ce commit et ne demande pas une autorisation pour une limite technique connue.

## Promotion

Une branche ne passe vers l intégration qu avec work item, conception à jour, tests proportionnés, preflight vert, preuves, audit indépendant et rapport sécurité lorsque la matrice l exige. `main` reçoit seulement des livraisons validées. Ne pas réécrire l historique des branches protégées.

## Contrôle de périmètre avant livraison

Avant tout commit final ou toute Pull Request, le Coordinateur compare le diff complet depuis la branche d intégration au résultat attendu, au hors périmètre et aux fichiers autorisés du work item. Il exécute au minimum `git diff --name-status <branche-intégration>...HEAD`, relit chaque commit et classe chaque fichier : `autorisé`, `preuve nécessaire`, `hors périmètre` ou `généré`. Un fichier hors périmètre bloque la livraison. Il ne doit pas être supprimé ou masqué pour obtenir un diff vert.

Si la branche contient plusieurs objectifs, un changement de maintenance, de configuration ou d’internationalisation sans lien direct, ou plusieurs work items, le Coordinateur bloque la PR et crée une branche propre depuis la branche d’intégration. Il reporte uniquement les commits pertinents, vérifie le diff de la nouvelle branche et conserve l’ancienne branche comme archive jusqu’à décision de l’utilisateur. Une PR ne doit jamais mélanger des domaines simplement parce que les tests passent.

## Contrôle automatisé

`verify-before-push.sh` bloque le push direct vers une branche protégée, les noms de branche non conformes et les commits dépassant les limites déclarées. Ne jamais contourner ce contrôle avec `--no-verify`.

Le contrôle de livraison doit également échouer si le work item, la branche, le titre de PR et le diff ne décrivent pas le même objectif. Les changements non rattachés reçoivent leur propre work item et leur propre branche avant toute promotion.

## État inconnu

Si Git est indisponible, le Coordinateur peut préparer le travail et les preuves locales, mais ne doit pas prétendre avoir créé une branche, une Pull Request ou une fusion.

## Pull Requests automatiques

Toute Pull Request créée automatiquement par le starter kit cible exclusivement `develop` ou `dev`. Le workflow refuse toute autre branche cible, notamment `main`. Une promotion vers `main` doit être réalisée par un humain ou demandée explicitement par l’utilisateur dans la conversation, avec une justification et des contrôles verts.

## Cadence des Pull Requests

Un push sur une branche de travail ne crée pas automatiquement une nouvelle PR. Le Coordinateur pousse les commits nécessaires sur la branche existante, puis ouvre une seule PR vers la branche d'intégration `dev` ou `develop` uniquement lorsque la carte est prête à intégrer, que les contrôles locaux sont passés et que les preuves de la Definition of Done sont réunies. Si une PR existe déjà pour la carte, elle est mise à jour au lieu d'en créer une autre. Les micro-corrections, commits de checkpoint et changements de documentation liés restent dans la même PR.

La promotion vers `main` est une seule PR depuis `dev` ou `develop` par lot cohérent et version. Elle ne doit pas créer de PR intermédiaire par commit, check, agent, résultat CI ou correction.

## Pull Request par carte

Une carte Trello correspond par défaut à une branche de travail et à une seule Pull Request finale. Tant qu'un seul check, une seule preuve ou une seule action de la carte reste ouvert, l'agent ne crée aucune Pull Request : il ne fait que des commits atomiques et les pousse sur la branche dédiée. La PR vers `dev` ou `develop` est créée uniquement après la dernière checklist, la mise à jour documentaire, la validation de la Definition of Done et la relecture Trello. Si une PR existe par erreur avant cette étape, le Coordinateur la ferme sans supprimer la branche, puis reprend les commits sur cette branche. Une PR intermédiaire exige une demande explicite de l'utilisateur ou une justification critique documentée.

Exception de déploiement explicite : si l'utilisateur demande précisément de fusionner ou promouvoir la branche de travail vers `dev` ou `develop` afin de déclencher un déploiement ou une validation d'environnement, cette demande autorise une PR de déploiement avant la clôture de la carte. Le Coordinateur crée la PR vers la branche d'intégration, attend CI et déploiement, vérifie la preuve externe, puis revient sur la branche de travail et reprend le Goal avec les checks restants. Cette PR est un checkpoint d'environnement et ne clôture ni la carte ni le Goal.
