## Unreleased

## 1.12.73 - 2026-10-02

- Interdit explicitement de demander une confirmation pour une carte Trello déjà demandée par l'utilisateur.

## 1.12.72 - 2026-10-01

- Rend obligatoire l'inscription et l'activation des agents parallèles dans le Goal avant le premier check.

## 1.12.71 - 2026-10-01

- Vérifie l'ordre numérique et les dépendances des cartes avant chaque démarrage.

## 1.12.70 - 2026-10-01

- Ajoute le cycle de vie obligatoire des sessions navigateur et leur fermeture après chaque feature ou lot externe terminé.

## 1.12.69 - 2026-09-30

- Fusionne automatiquement les PR prévues vers `dev` ou `develop` dans un flux déjà autorisé, sans confirmation redondante.

## 1.12.68 - 2026-09-30

- Interdit de déclarer l'onboarding terminé avant la PR vérifiée vers `dev`.

## 1.12.67 - 2026-09-30

- Ajoute un audit final carte par carte obligatoire avant la fin de l'initialisation Trello.

## 1.12.66 - 2026-09-30

- Précise que le connecteur Trello reste en lecture-écriture prioritaire et que le navigateur complète seulement ses manques après vérification.

## 1.12.65 - 2026-09-30

- Implique une stratégie connecteur-premier puis navigateur pour les compléments Trello et la validation visuelle.

## 1.12.64 - 2026-09-30

- Vérifie chaque carte créée avant d'autoriser le passage à la suivante.

## 1.12.63 - 2026-09-30

- Interdit de considérer des cartes macro seules comme une décomposition complète de conception.

## 1.12.62 - 2026-09-30

- Définit le navigateur existant comme navigateur généraliste du projet, et non comme navigateur dédié à Trello.

## 1.12.61 - 2026-09-30

- Réutilise toujours le navigateur Trello déjà ouvert et connecté avant toute nouvelle session.

## 1.12.60 - 2026-09-30

- Rend obligatoire la création et la relecture des étiquettes Trello avant toute carte et toute synchronisation vérifiée.

## 1.12.59 - 2026-09-30

- Utilise automatiquement le navigateur Trello quand l'écriture native n'est pas exposée.
- Initialise les fichiers de contexte manquants et recherche réellement Python 3.11 ou plus récent avant de bloquer.

## 1.12.58 - 2026-09-30

- Met à jour `.gitignore` avant toute autre mutation lors de l'initialisation.

## 1.12.57 - 2026-09-30

- Impose la relecture complète des instructions et la création du Goal dès le démarrage de toute initialisation.

## 1.12.57 - 2026-09-29

- Utilise l API GitHub comme repli contre les réponses Raw obsolètes.

## 1.12.55 - 2026-09-29

- Ajoute un paramètre anti-cache à la vérification distante pour éviter les faux retours de version GitHub Raw.

## 1.12.54 - 2026-09-29

- Utilise la source officielle par défaut lorsque le projet ne possède pas de manifeste `.workspace.toml`.
- Évite les fausses indisponibilités lors de la vérification de session.

## 1.12.53 - 2026-09-29

- Vérifie la version distante du kit au démarrage de chaque session manuelle.
- Impose la prise en compte des nouvelles politiques et scripts avant toute action projet.

## 1.12.52 - 2026-09-29

- Sépare explicitement l'onboarding terminé des audits et développements demandés ensuite.
- Impose un nouveau Goal, un work item et les contrôles complets avant toute PR vers `dev`.

## 1.12.51 - 2026-09-29

- Ajoute une boucle d'amélioration continue après chaque erreur confirmée.
- Impose incident, cause, correction, règle préventive, test de non-régression et preuve.

## 1.12.50 - 2026-09-29

- Ajoute la vérification et l'installation gratuite réutilisable des outils de test et de validation.
- Journalise les chemins et versions dans un état partagé entre projets.

## 1.12.49 - 2026-09-29

- Ajoute `VERSION-HISTORY.md`, l’historique chronologique des versions et améliorations depuis l’origine.
- Ajoute un contrôle CI exigeant la présence de la version courante dans cet historique.

## 1.12.48 - 2026-09-28

- Autorise une PR de déploiement vers `dev` ou `develop` lorsqu'elle est explicitement demandée pour débloquer une revalidation d'environnement.
- Impose le retour sur la branche de travail et la reprise du Goal après ce checkpoint.

## 1.12.47 - 2026-09-28

- Interdit de conclure après une preuve négative comme un `404`, un échec de test ou un déploiement absent.
- Impose diagnostic, correction, déploiement ou alternative, puis revalidation automatique jusqu'à réussite ou blocage réel.

## 1.12.46 - 2026-09-28

- Interdit de redemander une confirmation pour publier un commentaire Trello explicitement demandé lorsque l'intégration est déjà autorisée.
- Maintient la relecture visuelle obligatoire après publication.

## 1.12.45 - 2026-09-28

- Empêche de transformer une suggestion ou un blocage hors périmètre en check Trello ou exigence de Goal.
- Impose la vérification du cahier des charges, des critères, de la conception et des décisions avant toute extension du périmètre.

## 1.12.44 - 2026-09-28

- Ajoute à l'onboarding le choix entre CI sur chaque push et CI uniquement sur les Pull Requests et les branches protégées.
- Configure par défaut le mode `pull-request-only` afin de limiter les exécutions et le coût CI.
- Génère le workflow selon le choix enregistré dans `[delivery].ci_trigger_mode`.

## 1.12.43 - 2026-09-28

- Interdit les Pull Requests tant qu'un check de carte reste ouvert.
- Impose les commits poussés sur la branche dédiée jusqu'à la clôture complète de la carte.

## 1.12.42 - 2026-09-28

- Rend obligatoire la préparation automatique de chaque session avant toute action.
- Impose le chargement du cahier, du profil, des politiques, de l'état runtime et de l'inventaire des outils déjà installés.
- Ajoute un contrôle de non-régression dans les deux kits pour empêcher l'oubli de ces prérequis.

## 1.12.41 - 2026-09-28

### Initialisation executable des Goals

- Ajoute `start-goal.sh` aux kits Codex et Claude pour initialiser l état persistant avant toute action.
- Enregistre l objectif, les preuves attendues, les contraintes, le blocage, la carte, la branche d intégration et la délégation parallèle.
- Ajoute un test de régression couvrant le lancement du Goal et sa traçabilité.

## 1.12.40 - 2026-09-28

### Parallélisation obligatoire des lots indépendants

- Impose la création ou l’activation de plusieurs agents dès deux lots indépendants lorsque le parallélisme apporte un gain réel.
- Impose la matrice agent, périmètre, fichiers, dépendances et preuves avant le démarrage.
- Exige une justification dans le Goal lorsqu’une exécution séquentielle est conservée malgré des lots techniquement indépendants.
- Ajoute un test de cohérence pour empêcher le retour d’une règle seulement facultative.

## 1.12.39 - 2026-09-28

### Goals obligatoires pour les reprises de cartes

- Initialise ou reprend automatiquement un Goal pour toute demande ciblant une carte Trello, même avec une seule case ouverte.
- Supprime les contradictions entre les règles du Coordinateur, de l'orchestration et de la continuité de session.
- Ajoute un test de régression vérifiant cette obligation dans les deux kits.

## 1.12.38 - 2026-09-28

### Langue Trello

- Rend le français obligatoire pour tous les contenus rédigés dans Trello.
- Autorise uniquement les éléments techniques incompressibles dans leur forme originale.
- Impose la relecture du contenu réellement affiché après chaque enregistrement.

## 1.12.37 - 2026-09-28

### Livraison obligatoire des goals

- Maintient un goal actif jusqu'à la preuve du push vers `dev` ou `develop` et de la PR d'intégration relue.
- Ajoute au runtime la branche d'intégration, le commit poussé, l'état de livraison et l'état de la PR.
- Bloque le garde avant réponse si un goal est déclaré terminé sans preuve de livraison complète.
- Ajoute un test de régression pour un goal terminé prématurément.

## 1.12.36 - 2026-09-28

### Cadence des Pull Requests

- Ouvre une seule PR vers `dev` ou `develop` quand une carte est prête à intégrer.
- Met à jour la PR existante au lieu de créer une PR par commit, check ou correction.
- Réserve une PR unique de promotion vers `main` par lot cohérent et version.

## 1.12.35 - 2026-09-27

### Sobriété CI/CD

- Évite les doublons de validation entre `push` et `pull_request` pour un même commit.
- Annule les exécutions obsolètes et limite les matrices aux besoins justifiés.
- Réutilise les preuves lors de la promotion vers `main` lorsque le commit est identique.

## 1.12.34 - 2026-09-27

### Runners auto-hébergés

- Préfère les runners auto-hébergés pour les contrôles GitHub Actions afin d'éviter les coûts de runners facturables.
- Vérifie leur disponibilité, leur autorisation, leur label et leurs outils avant exécution.

## 1.12.33 - 2026-09-27

### Résolution obligatoire des checks bloqués

- Interdit de passer à une autre carte tant qu'un check ouvert n'est pas prouvé ou réellement bloqué.
- Impose un journal de tentatives et un changement concret d'approche après deux tours sans résolution.

## 1.12.32 - 2026-09-27

### Découverte fiable des outils

- Vérifie les chemins, environnements, IDE, scripts locaux, intégrations, identité et authentification avant de déclarer un outil indisponible.
- Interdit de conclure à une absence sur un simple échec lié au `PATH`.

## 1.12.31 - 2026-09-27

### Cadence des commentaires Trello

- Réduit les micro-commentaires pour éviter les cartes qui stagnent.
- Impose des synthèses lors des changements significatifs et une synthèse finale probante.

## 1.12.30 - 2026-09-27

### Nommage obligatoire des étiquettes Trello

- Invalide les étiquettes sans nom explicite.
- Autorise le navigateur comme solution de secours lorsque le connecteur ne permet pas le renommage.
- Impose une relecture visuelle du nom dans Trello.
- Impact de release : `patch`.

## 1.12.29 - 2026-09-27

### Étiquettes Trello obligatoires

- Rend obligatoires les étiquettes de périmètre et de risque applicables dès la création des cartes.
- Impose la relecture des rattachements et bloque les transitions si une étiquette requise manque.
- Impact de release : `patch`.

## 1.12.28 - 2026-09-27

### Livraison automatique de l'onboarding

- Termine l'onboarding après collecte des réponses, avec `.gitignore`, branche `dev`, commit et push vérifié.
- Reporte la question de lancement du développement après cette livraison uniquement.
- Impact de release : `patch`.

## 1.12.27 - 2026-09-27

### Migration des tableaux Trello existants

- Rend obligatoire la remise en conformité directe d'un tableau existant avec les normes du kit.
- Impose la préservation de l'historique utile, la correction sans doublons et la relecture complète après migration.
- Impact de release : `patch`.

## 1.12.26 - 2026-09-27

### Audit obligatoire des projets existants

- Déclenche un audit complet après le choix Trello lors de l'initialisation d'un projet déjà commencé.
- Transforme chaque correction, dette, incohérence ou amélioration en carte ordonnée et classée MVP ou Post-MVP avant toute reprise du développement.
- Impact de release : `patch`.

## 1.12.25 - 2026-09-27

### Anti-boucle des Goals

- Interdit de répéter le même blocage plus de deux tours de Goal.
- Impose une action de déblocage concrète au deuxième tour et documente les alternatives tentées.
- Impact de release : `patch`.

## 1.12.24 - 2026-09-27

### Outils de test manquants

- Autorise l'installation provisoire d'outils gratuits manquants pour exécuter les tests.
- Impose la journalisation de la version et du résultat ainsi que le nettoyage si l'outil n'est pas une dépendance projet.
- Impact de release : `patch`.

## 1.12.23 - 2026-09-27

### Commentaires Trello en phrases

- Remplace les puces et numérotations par une phrase par ligne séparée par un retour à la ligne.
- Maintient la rédaction française, la preuve explicite et la vérification visuelle après sauvegarde.
- Impact de release : `patch`.

## 1.12.22 - 2026-09-27

### Format final des commentaires Trello

- Remplace les tirets manuels par les puces natives Trello et impose le français, une idée par puce, une ponctuation complète et une relecture visuelle.
- Impose la mention des preuves vérifiées et des éléments non vérifiés ou bloqués.
- Impact de release : `patch`.

## 1.12.21 - 2026-09-27

### Format strict des commentaires Trello

- Implique des lignes alignées à gauche, chacune commençant par `-`, sans titre, gras, ligne vide, deux-points ou caractère ouvrant un menu.
- Impose la relecture du contenu complet après sauvegarde.
- Impact de release : `patch`.

## 1.12.20 - 2026-09-27

### Commentaires Trello sans autocomplétion

- Interdit les deux-points et les caractères connus pour ouvrir des menus dans les commentaires Trello.
- Maintient la relecture complète après publication et la correction des commentaires historiques incomplets.
- Impact de release : `patch`.

## 1.12.19 - 2026-09-27

### Relecture historique des commentaires Trello

- Impose la relecture des commentaires précédents avant toute nouvelle mise à jour.
- Exige la correction des preuves partielles, vides ou tronquées avant de poursuivre.
- Impact de release : `patch`.

## 1.12.18 - 2026-09-27

### Outils gratuits uniquement

- Interdit toute activation de service payant, runner supérieur, quota supplémentaire ou moyen de paiement sans accord explicite.
- Privilégie les outils locaux, open source, gratuits et les runners GitHub Actions standards.
- Bloque toute tentative de contournement d'un quota ou d'une facturation.
- Impact de release : `patch`.

## 1.12.17 - 2026-09-27

### Clôture documentaire Trello

- Rend obligatoire une dernière case de checklist pour mettre à jour et relire les README, docs, changelog et notes de release applicables.
- Interdit de passer la carte à `Done` avant la preuve de cette dernière case.
- Impact de release : `patch`.

## 1.12.16 - 2026-09-27

### Preuve Trello fiable

- Impose la saisie en texte brut et la fermeture des menus d'autocomplétion avant validation d'un commentaire.
- Impose la relecture du commentaire publié dans l'activité avant de considérer la preuve comme valide.
- Impact de release : `patch`.

## 1.12.15 - 2026-09-27

### Contrôle automatisé de frontière projet

- Ajoute un garde avant push qui bloque les références aux outils internes dans les fichiers suivis du projet.
- Vérifie que la détection bloque une fuite et accepte un livrable neutre.
- Impact de release : `patch`.

## 1.12.14 - 2026-09-27

### Frontière entre kit et projet

- Interdit l'exposition des noms, fichiers et mécanismes internes du kit dans les livrables projet.
- Ajoute la politique de séparation aux kits Codex et Claude.
- Impact de release : `patch`.

## 1.12.13 - 2026-09-27

### Porte conception avant développement

- Bloque l'implémentation tant que `docs/design/design-readiness.md` n'est pas approuvé et complet.
- Ajoute le contrôle preflight du statut, des cases ouvertes et des marqueurs de conception.
- Ajoute le template et l'initialisation du manifeste de readiness pour Codex et Claude.
- Impact de release : `patch`.

## 1.12.12 - 2026-09-27

### Numérotation et ordre des cartes Trello

- Ajoute une numérotation stable `MVP-001` ou `POST-MVP-001` fondée sur les dépendances.
- Documente l'ordre d'exécution, les groupes parallèles et les décisions de périmètre.
- Ajoute les files `MVP - À développer` et `Post-MVP - À développer` uniquement lorsque les deux phases existent.
- Impact de release : `patch`.

## 1.12.11 - 2026-09-26

### Goal obligatoire pour chaque carte

- Crée un Goal dès le début de toute demande explicite de finalisation d'une carte Trello, même avec une seule case ouverte.
- Réserve le nombre de checks au choix de parallélisation et non à l'activation du Goal.
- Impact de release : `patch`.

## 1.12.10 - 2026-09-26

### Attribution dynamique des checks d'un Goal

- Réévalue les checks ouverts et les agents disponibles à chaque relecture du Goal.
- Attribue immédiatement chaque check autonome à un agent disponible ou crée/active un agent compétent.
- Trace l'attribution, le périmètre, la preuve attendue et l'heure de début.
- Impact de release : `patch`.

## 1.12.9 - 2026-09-26

### Délégation automatique à la création des Goals

- Ajoute au Goal un plan de création ou d'activation d'agents pour les cartes comportant au moins trois tâches indépendantes.
- Exige la partition, les preuves, les dépendances et l'agent intégrateur avant le démarrage parallèle.
- Conserve une branche et une PR finales par carte.
- Impact de release : `patch`.

## 1.12.8 - 2026-09-26

### Cible frontend Framer-like

- Ajoute une cible comparative de rendu Framer-like à 99 % sur la qualité perçue.
- Renforce les contrôles de composition, motion, interactions, responsive et micro-détails.
- Maintient les exigences d'accessibilité, de performance, de provenance et de maintenabilité.
- Impact de release : `patch`.

## 1.12.7 - 2026-09-26

### Parallélisation contrôlée des agents

- Autorise plusieurs agents sur une même carte lorsque les lots sont indépendants et partitionnés.
- Autorise plusieurs agents du même rôle sur des cartes, fichiers, parcours ou lots distincts.
- Ajoute un agent intégrateur chargé de l'assemblage, des conflits, des tests et des preuves finales.
- Impact de release : `patch`.

## 1.12.6 - 2026-09-26

### Contenu visuel frontend premium

- Encourage la génération d'images réalistes et spécifiques lorsque le produit en a besoin.
- Ajoute les contrôles de provenance, artefacts, responsive, performance, accessibilité et crédibilité.
- Renforce les livrables et interdictions de l'agent frontend Codex et Claude.
- Impact de release : `patch`.

## 1.12.5 - 2026-09-26

### Attente récupérable des Goals

- Ajoute l'état `waiting` pour les CI, intégrations temporaires indisponibles et commandes réessayables.
- Interdit de transformer automatiquement ces attentes en `blocked` ou en pause native du Goal.
- Ajoute un test vérifiant qu'un checkpoint `waiting` conserve la reprise possible.
- Impact de release : `patch`.

## 1.12.4 - 2026-09-26

### Synchronisation Trello événementielle

- Interdit les mises à jour groupées après plusieurs transitions ou preuves.
- Impose une synchronisation et une relecture immédiates après chaque événement significatif.
- Documente le checkpoint local et le rejeu ordonné en cas d'indisponibilité Trello.
- Impact de release : `patch`.

## 1.12.3 - 2026-09-26

### Dimensionnement adaptatif des tableaux Trello

- Adapte le nombre de colonnes de travail au nombre de personnes actives.
- Conserve les colonnes de gouvernance stables et limite les colonnes de travail à quatre.
- Impact de release : `patch`.

## 1.12.2 - 2026-09-26

### Enchaînement automatique des cartes Trello

- Ajoute la sélection automatique de la prochaine carte éligible après clôture vérifiée d'une carte lors d'une autorisation de lot.
- Ignore explicitement les cartes bloquées, dépendantes, `time-gated`, en revue ou déjà terminées.
- Impact de release : `patch`.

## 1.12.1 - 2026-09-26

### Correction du synchroniseur external

- Corrige la cible de synchronisation pour éviter la création de `.codex/.codex`.
- Corrige l’écriture de la version dans `.workspace.toml`.
- Impact de release : `patch`.

## 1.12.0 - 2026-09-26

### Goal automatique pour les cartes Trello multi-étapes

- Active automatiquement le contrat Goal pour une demande de finalisation d'une carte comportant au moins deux cases ouvertes.
- Rattache l'objectif au titre, à la checklist, à la Definition of Done, aux preuves et aux contraintes de livraison de la carte.
- Conserve un fonctionnement local explicite lorsque le mécanisme Goal natif n'est pas disponible.
- Impact de release : `minor`.

## 1.11.0 - 2026-09-26

### Application du cahier des charges agentique

- Ajoute la validation explicite de la session, du dernier tour et des échecs d'outils.
- Ajoute `validate-session-state.sh` aux kits Codex et Claude.
- Renforce le garde avant réponse sur les états distribués et les environnements distants.
- Documente l'état d'implémentation et les limites des adaptateurs Agents API/webhooks.
- Impact de release : `minor`.

## 1.10.0 - 2026-09-26

### Continuité de session fondée sur les objectifs

- Ajoute une politique commune de continuité de session aux kits Codex et Claude.
- Documente l'utilisation d'un objectif persistant natif lorsqu'il est disponible, avec résultat attendu, preuves, contraintes, budget et condition de blocage.
- Ajoute les métadonnées d'objectif à `RUNTIME-STATE.md`.
- Interdit de présenter Agent, Work locally, idle ou un tour terminé comme une garantie d'autonomie continue.
- Aligne la clôture sur la vérification réelle des outils et des preuves.
- Ajoute les contrôles runtime pour les actions requises, reprises, budgets, environnements, requêtes en attente et artefacts.
- Documente l'idempotence, la signature et la déduplication des webhooks, la traçabilité et la protection des secrets.
- Impact de release : `minor`.

## 1.9.0 - 2026-09-26

### Continuité de session fondée sur les objectifs

- Ajoute une politique commune de continuité de session aux kits Codex et Claude.
- Documente l'utilisation d'un objectif persistant natif lorsqu'il est disponible, avec résultat attendu, preuves, contraintes, budget et condition de blocage.
- Ajoute les métadonnées d'objectif à `RUNTIME-STATE.md`.
- Interdit de présenter Agent, Work locally, idle ou un tour terminé comme une garantie d'autonomie continue.
- Aligne la clôture sur la vérification réelle des outils et des preuves.
- Impact de release : `minor`.

## 1.8.2 - 2026-09-26

### Exécution agentique sans confirmation redondante

- Autorise immédiatement les actions réversibles explicitement demandées par l'utilisateur, notamment la création d'une carte Trello et du work item associé.
- Interdit de demander une confirmation supplémentaire pour une action déjà demandée.
- Ajoute des contrôles de cohérence pour maintenir cette règle dans les kits Codex et Claude.
- Ajoute un état runtime obligatoire et un garde avant réponse pour empêcher les clôtures prématurées.
- Renforce `checkpoint.sh` et ajoute un test automatisé des états `running` et `complete`.
- Impact de release : `patch`.

## 1.8.0 - 2026-09-25

### Portes de gouvernance exécutables

- Ajoute un registre TSV structuré aux nouveaux work items pour les huit portes du contrat central.
- Bloque le push et la livraison lorsqu une porte reste ouverte ou sans preuve.
- Ajoute des scénarios de non-régression pour les registres incomplets, valides et sans preuve.
- Exécute les tests de gouvernance dans la CI et contrôle la parité Codex et Claude.

## 1.7.0 - 2026-09-25

### Contrat de gouvernance central

- Ajoute un registre d obligations persistant avec responsable, déclencheur, preuve, état et prochaine action.
- Ajoute huit portes obligatoires couvrant intake, conception, périmètre, validation, documentation, intégrations, audit et livraison.
- Aligne les parcours Codex et Claude et ajoute un audit automatisé de cohérence.
- Interdit la clôture tant qu une obligation applicable ne possède pas de preuve ou une justification explicite.

### Synchronisation Trello

- Privilégie les connecteurs Trello déjà disponibles dans la session.
- Interdit de proposer l’installation d’outils de remplacement lorsqu’une intégration connectée existe.
- Ajoute un checkpoint local et la poursuite des tâches indépendantes lorsque Trello est réellement indisponible.

## 1.6.3 - 2026-09-25

### Autonomie après le cadrage

- Conserve les réponses partielles au questionnaire et ne redemande que les décisions réellement manquantes.
- Lance automatiquement l onboarding, la conception et le flux prévu dès que les blocages de cadrage sont levés.
- Interdit de demander « Continue » ou « fais tout » pour déclencher une étape déjà autorisée.

### Intégrité des branches

- Ajoute un contrôle explicite du diff complet par rapport au work item avant commit final et Pull Request.
- Bloque les branches qui mélangent internationalisation, configuration, maintenance ou plusieurs work items.
- Documente la création automatique d’une branche propre depuis la branche d’intégration et le report des seuls commits pertinents.

## 1.6.2 - 2026-09-24

### Synchronisation temps réel Trello

- Impose la validation, le cochage, la relecture et la reprise séquentielle après chaque élément.
- Interdit de cocher plusieurs éléments en différé ou sans preuve.

## 1.6.1 - 2026-09-24

### Démarrage obligatoire des cartes Trello

- Impose le déplacement de la carte active dans `In Progress` avant toute analyse ou modification.
- Ajoute une preuve de relecture de la liste, des labels, de la checklist et de la Definition of Done.
- Bloque le codage si l état Trello et l état local ne correspondent pas.

## 1.6.0 - 2026-09-24

### Gouvernance visuelle Trello

- Ajoute des listes, étiquettes, couleurs et règles de nommage standardisées.
- Rend le rendu du tableau lisible, accessible et vérifiable après synchronisation.
- Interdit les doublons d étiquettes et les descriptions mal formatées.

## 1.5.0 - 2026-09-24

### Documentation technique en anglais

- Rend l anglais obligatoire pour les README, commentaires, docstrings, scripts, CI, work items et rapports techniques, sauf dérogation explicite du profil projet.
- Normalise les séparateurs de sections et les métadonnées TODO et FIXME.
- Impose la synchronisation documentaire après chaque changement significatif.
- Ajoute une validation de cohérence avant commit et Pull Request.

## 1.4.0 - 2026-09-24

### Demandes exceptionnelles

- Ajoute une classification S1 à S4 et rend Trello obligatoire pour les demandes structurantes ou critiques.
- Ajoute un work item, une Definition of Done, un retour arrière et un mode local si Trello est indisponible.

## 1.2.2 - 2026-09-23

### Fiabilité

- Ajoute la restauration automatique du kit précédent après une synchronisation échouée.
- Conserve la sauvegarde et signale explicitement le rollback.

## 1.2.1 - 2026-09-23

### Sécurité et fiabilité

- Ajoute des timeouts et une concurrence contrôlée aux workflows.
- Épingle les actions GitHub de checkout et de configuration Python par SHA.
- Réduit les risques de mises à jour external concurrentes.

## 1.2.0 - 2026-09-23

### Ajouts

- Ajoute la carte de documentation du dépôt.
- Ajoute le diagnostic local Codex et Claude.
- Rend vérifiables le mode, la version, le manifeste, le cahier et les fichiers external suivis par Git.

## 1.1.9 - 2026-09-23

### Documentation

- Réorganise le guide d installation avec une progression numérotée cohérente.
- Met à jour le README principal vers la version réelle du kit.
- Complète les README des distributions native et external.
- Documente les fichiers suivis, les données protégées, les mises à jour et le GitFlow.

## 1.1.8 - 2026-09-23

### Corrections

- Ajoute une validation pre-push dédiée au mode external.
- Évite les contrôles de profil et les artefacts générés incompatibles avec un kit local ignoré.
- Conserve la détection des secrets, du suivi Git interdit et des workflows invalides.

## 1.1.7 - 2026-09-23

### Corrections

- Rend le rapport de cadrage obligatoire comme première réponse du mode initialisation.
- Interdit les résumés de configuration avant la vérification explicite du cahier des charges.
- Distingue strictement les statuts absent, pending et accepted.

## 1.1.6 - 2026-09-23

### Améliorations

- Rend l origine et le statut du cahier des charges explicites à chaque initialisation.
- Signale les fichiers réellement lus, les fichiers manquants et l action suivante.
- Interdit de présenter un cahier existant comme reçu dans le chat sans preuve.

## 1.1.5 - 2026-09-23

### Corrections

- Corrige la mise à jour forcée d un kit déjà installé.
- Préserve les données projet tout en actualisant réellement KIT.toml et les fichiers universels.

## 1.1.4 - 2026-09-23

### Améliorations

- Remplace la navigation de dossiers par un sélecteur clavier sans dépendance obligatoire.
- Sépare clairement l entrée dans un dossier et la sélection du projet.
- Ajoute le retour parent avec Backspace ou la flèche gauche.

## 1.1.3 - 2026-09-23

### Ajouts

- Ajoute la synchronisation locale automatique du kit externe.
- Protège le cahier des charges, l état projet, les décisions et les work items lors des mises à jour.
- Crée une sauvegarde avant chaque remplacement du moteur du kit.

# Changelog

## 1.12.31

- Réduit la cadence des commentaires Trello pour éviter les cartes qui stagnent sous des micro-mises à jour.
- Impose des synthèses uniquement lors d'événements significatifs, avec une synthèse finale probante.
## 1.1.2 - 2026-09-23

### Corrections

- Ajoute le mode initialisation utilisable dans une conversation déjà ouverte.
- Rend la porte du cahier des charges explicitement relançable sans redémarrer la session.

## 1.1.2 - 2026-09-23

### Corrections

- Améliore l’assistant interactif de sélection du mode.
- Corrige les exemples manuels d’installation Codex et Claude.
- Clarifie les parcours native et external dans les README.

## 1.1.2 - 2026-09-23

### Ajouts

- Ajoute les distributions `native` et `external`.
- Ajoute le manifeste `.workspace.toml` et le workflow de mise à jour externe.
- Conserve les fichiers d’orchestration localement sans les publier dans le dépôt projet en mode external.

## 1.1.2 - 2026-09-23

### Corrections

- Corrige le workflow de mise à jour pour récupérer son script officiel malgré l’ignorance de `.codex/` et `.claude/`.
- Rend la détection et la mise à jour automatique utilisables dans les projets importateurs.

## 1.1.2 - 2026-09-23

### Corrections

- Renforce la synchronisation Trello après chaque livraison et la relecture des checklists.
- Distingue les tâches terminées, les décisions humaines requises et les blocages réels.
- Rend la validation navigateur obligatoire pour les changements frontend.
- Ajoute le routage universel des demandes hors cahier des charges initial.

## 1.1.2 - 2026-09-22

- Corrige la condition de secret du workflow de publication GitHub.

## 1.1.2 - 2026-09-22

- Fixe le déclenchement et la publication idempotente des Releases GitHub.
- Maintient la synchronisation documentaire et le contrôle de version.


Ce projet suit le versionnement sémantique. Les changements publiés sont regroupés par version et classés en ajouts, corrections, sécurité, changements incompatibles et dépréciations.

## Non publié

- Clarifie que les versions reflètent les évolutions consommées du kit et non chaque maintenance interne.

- Corrige le déclencheur de tags et rend la publication Release idempotente.

- Corrige les permissions du workflow Release et documente le secret nécessaire à la mise à jour About.

- Ajoute la publication automatique des Releases et la mise à jour de la section About après un tag sur main.

- Ajoute le contrat documentaire premium, les Skills de rédaction et d’audit et la validation automatique des documents.

- Supprime les contextes GitHub Actions optionnels non déclarés et détecte automatiquement dev ou develop.

- Ajoute la création et la mise à jour idempotente du gitignore lors de l’installation.

- Corrige la navigation du sélecteur de dossiers avec choix explicite du dossier courant et retour au parent.

- Ajoute un sélecteur de dossier avec navigation fzf et un fallback Bash sans dépendance obligatoire.

- Améliore l’installateur avec un assistant terminal coloré, des choix guidés et un résumé avant installation.

- Verrouille les Pull Requests automatiques sur dev ou develop et interdit toute promotion automatique vers main.

- Ajout du choix d’activation des mises à jour automatiques lors de l’initialisation Codex ou Claude.

- Complète la politique de sécurité et ajoute un résumé rassurant dans le README principal.

- Réorganisation du README principal pour présenter l’installation et le démarrage avant les détails avancés.

- Suppression du doublon de version dans le README principal et clarification complète de l’installation et des mises à jour automatiques.

- Ajout d’un installateur qui sélectionne automatiquement Codex ou Claude et installe uniquement la variante nécessaire.

- Ajout ou correction : inscrire ici chaque changement visible avant la release.
- Ajout du synchroniseur non destructif et du workflow de Pull Request automatique pour propager les mises à jour du kit dans les projets utilisateurs.

## 1.1.2 - 2026-09-21

### Corrections

- Renforcement de l’autonomie continue pendant l’attente et la reprise des CI.
- Ajout de la règle de traitement par lots des dettes historiques du périmètre.
- Clarification des corrections réversibles qui ne nécessitent pas de demander « Continue ».

## 1.0.7 - 2026-09-21

### Corrections

- Ajout d’un lint Markdown explicite et bloquant pour supprimer les avertissements jaunes avant fusion.
- Ajout de la configuration `.markdownlint.json` adaptée aux README, aux frontmatters Claude et aux tableaux du kit.

## 1.0.6 - 2026-09-21

### Ajouts

- Ajout d’un contrôle CI qui exige les trois README publics pour les changements du kit.
- Ajout d’un contrôle de cohérence entre `VERSION`, `KIT.toml`, les README et le changelog.
- Ajout de l’affichage du tag de version sur les README.

## 1.0.5 - 2026-09-21

### Corrections

- Correction des formulations des README afin d’indiquer explicitement les 16 agents disponibles.

## 1.0.4 - 2026-09-21

### Documentation

- Mise à jour du README principal et des README Codex et Claude avec l’inventaire fonctionnel réel, la gouvernance des spécialistes, les checkpoints, le suivi des coûts et le mode Trello `time-gated`.

## 1.0.3 - 2026-09-21

### Corrections

- Synchronisation des versions affichées dans les README internes des deux kits.
- Ajout des profils de modèles Claude pour les dix agents spécialistes optionnels.

## 1.0.2 - 2026-09-21

### Corrections

- Correction du niveau de titre dans la gouvernance publique du kit Claude.

## 1.0.1 - 2026-09-21

### Ajouts

- Ajout du mode `time-gated` pour suspendre uniquement les cartes Trello dépendantes d’une échéance.
- Ajout de l’obligation de mise à jour détaillée du README pour chaque changement livré.

### Corrections

- Le Coordinateur doit lire la gouvernance des spécialistes avant toute délégation et justifier leur activation.

## 1.0.0 - 2026-09-21

### Ajouts

- Ajout de dix agents spécialistes optionnels pour le produit, la QA, le DevOps, la performance, la recherche UX, l’accessibilité, les données, la documentation, les releases et la conformité.
- Ajout de la gouvernance d’activation et de supervision des agents spécialistes.
- Ajout du suivi interne des coûts et du routage des modèles par risque.

### Corrections

- Le Coordinateur lit désormais la gouvernance des spécialistes avant toute délégation.
- Le preflight accepte les agents optionnels tout en conservant les six agents du noyau obligatoires.

## 0.1.0 - 2026-09-17

### Ajouts

- Première version publiée des starter kits Codex et Claude Code.
- Gouvernance, Gitflow, conception, journal qualité, contrôles CI et option Trello.
## 1.2.3 - 2026-09-24

### Fiabilité des décisions

- Ajoute une politique universelle de recherche Internet actualisée pour Codex et Claude.
- Rend obligatoires les recherches pour les informations évolutives, réglementaires, de sécurité, de compatibilité et de coût.
- Impose la traçabilité des sources, des versions, des dates et des décisions influencées.
- Ajoute un routage explicite des recherches vers les agents concernés.
- Réutilise les recherches valides et interdit l'envoi de secrets ou de données personnelles non anonymisées.
## 1.2.4 - 2026-09-24

### Continuité des cartes

- Ajoute une boucle obligatoire de continuation après chaque livraison partielle, PR, fusion, CI ou synchronisation Trello.
- Interdit de terminer l'intervention lorsqu'une case autonome reste ouverte.
- Impose la reprise immédiate du prochain work item jusqu'à la Definition of Done réelle.
- Distingue explicitement une livraison intermédiaire d'une clôture de carte.
## 1.2.5 - 2026-09-24

### Autonomie continue

- Renforce le contrat d'exécution sans interruption pour toutes les actions autorisées.
- Interdit les demandes intermédiaires de type « Continue » lorsqu'une action autonome reste disponible.
- Ajoute une procédure obligatoire avant toute déclaration de blocage.
- Oblige l'agent à poursuivre les tâches indépendantes lorsqu'une intégration ou une CI est indisponible.
- Interdit les conclusions basées uniquement sur une CI en cours, une PR ouverte ou une erreur corrigeable.
## 1.2.6 - 2026-09-24

### Continuité d'exécution

- Rend l'interdiction de rendre la main avec une action autonome restante visible dans les points d'entrée Codex et Claude.
- Rend les politiques d'autonomie et de clôture obligatoires pour le Coordinateur.
- Traite chaque PR, fusion, CI et rapport intermédiaire comme un checkpoint et non comme une fin de tâche.
- Empêche explicitement la clôture conversationnelle après une simple liste de tâches restantes.
## 1.2.7 - 2026-09-24

### Exécution des cartes

- Ajoute un protocole de session continue pour chaque carte Trello.
- Interdit les annonces de poursuite sans action observable dans le même tour.
- Rend obligatoire la reprise immédiate de la prochaine case ouverte.
- Conditionne la fin de session à la relecture de Trello et à un état final prouvé.
## 1.2.8 - 2026-09-24

### Cohérence documentaire

- Rend obligatoire la synchronisation du code, de la configuration, des README, de la conception, des décisions, des work items, du journal qualité, du changelog, des preuves et de Trello.
- Transforme toute documentation obsolète en anomalie de livraison.
- Renforce l'audit documentaire avant la Definition of Done.
## 1.2.9 - 2026-09-24

### GitFlow des cartes

- Impose une branche unique et une seule PR finale par carte Trello.
- Regroupe les étapes, corrections et validations avec des commits atomiques.
- Interdit les PR intermédiaires par checklist sauf demande explicite ou besoin critique documenté.
## 1.3.0 - 2026-09-24

### Exécution persistante

- Ajoute un contrat d'exécution persistante chargé par les points d'entrée et le Coordinateur.
- Rend obligatoire une action observable avant tout compte rendu.
- Ajoute les états `current_action`, `next_action`, `execution_status` et `last_observable_evidence`.
- Interdit toute conclusion lorsque la session est encore `running` ou `waiting-ci`.
- Rend les interruptions reprenables depuis le dernier checkpoint réel.
## 1.3.1 - 2026-09-24

### Mode d'exécution

- Documente l'utilisation obligatoire du mode Agent avec Work locally pour modifier un projet.
- Distingue explicitement le mode Plan, le mode lecture seule et le mode d'exécution.
- Ajoute la reprise contrôlée depuis `RUNTIME-STATE.md` lorsque le mode d'exécution est interrompu.
