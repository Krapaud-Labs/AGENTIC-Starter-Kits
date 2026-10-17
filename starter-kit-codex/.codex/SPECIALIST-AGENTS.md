# Gouvernance des agents spécialistes

## Principe

Les agents spécialistes complètent le noyau composé du Coordinateur, du Concepteur, du Frontend, du Backend, de la Cybersécurité et de l’Auditeur. Ils sont optionnels. Le Coordinateur les active uniquement lorsque le cahier des charges, la stack, le risque ou les critères d’acceptation le justifient.

## Activation

L’activation est déclarée dans `[agents]` de `.codex/project-profile.toml`. Une activation doit être justifiée dans le work item et produire une preuve vérifiable. Un agent désactivé ne doit pas être appelé par défaut.

## Matrice de décision

| Agent | Activation obligatoire si | Livrables attendus |
| --- | --- | --- |
| `produit` | Le périmètre, les priorités ou la valeur métier sont ambigus. | Objectifs, priorités, arbitrages et critères métier. |
| `qa` | Le projet possède une fonctionnalité testable ou un risque de régression. | Stratégie de test, cas de test, couverture et rapport de régression. |
| `devops` | Le projet possède une CI, un conteneur, un environnement ou un déploiement. | Pipeline, procédure d’environnement, observabilité et rollback. |
| `performance` | Un budget de latence, mémoire, taille ou disponibilité est déclaré. | Baseline, mesures, goulots d’étranglement et recommandations. |
| `ux_research` | Une hypothèse utilisateur doit être validée ou un parcours est incertain. | Hypothèses, parcours, risques d’usage et protocole de validation. |
| `image-generation` | Une image, photo, illustration, texture, icône ou ressource média doit être créée, sélectionnée, retouchée ou auditée. | Brief visuel, média réaliste et cohérent, contrôles d’artefacts, provenance, licence, accessibilité et preuves d’intégration. |
| `accessibilite` | Une interface utilisateur est livrée ou une exigence inclusive existe. | Contrôles clavier, contraste, sémantique, lecteur d’écran et exceptions. |
| `data` | Le projet possède un schéma, des migrations, des indicateurs ou des traitements. | Modèle, qualité, migrations, règles de rétention et preuves. |
| `documentation` | Une API, une installation, une exploitation ou un parcours utilisateur est livré. | Documentation ciblée, exemples vérifiés et procédure de maintenance. |
| `release` | Une version, une migration ou une livraison externe est préparée. | Changelog, version, checklist, migration, rollback et notes de livraison. |
| `conformite` | Des données personnelles, licences ou obligations réglementaires existent. | Registre des exigences, écarts, preuves et risques résiduels. |

## Contrat commun

Chaque spécialiste lit le work item, le profil projet, les décisions et le journal qualité. Il ne modifie que les fichiers autorisés, ne s’auto-approuve pas, documente chaque hypothèse et transmet une preuve reproductible. Toute anomalie est enregistrée dans `docs/quality/quality-journal.md` avec identifiant, impact, propriétaire, correction et vérification.

## Ordre de contrôle

Le Coordinateur active d’abord `produit` et `concepteur` pour clarifier le résultat, puis les spécialistes techniques nécessaires. `qa`, `cybersecurite`, `accessibilite` et `auditeur` contrôlent ensuite la livraison. `release` clôture uniquement après les décisions d’audit.
