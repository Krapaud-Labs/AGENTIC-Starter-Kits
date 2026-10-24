# Registre des cahiers des charges

## Emplacement officiel

Le cahier de référence d'un projet est conservé par défaut dans `Documents/Projets/Cahier-des-Charges/<nom-du-projet>/`. Le fichier principal porte le nom `cahier-des-charges.md`. Les versions acceptées, les empreintes et les changements Post-MVP restent dans ce même dossier. Le chemin peut être personnalisé à l'installation.

Le fichier `.codex/PROJECT-BRIEF.md` ou `.claude/PROJECT-BRIEF.md` est une copie de travail nécessaire au kit. Il ne remplace jamais l'archive officielle. Il doit contenir l'identifiant, la version, l'empreinte et le chemin du cahier officiel.

## Règles de rangement

Un projet possède un seul cahier initial accepté.

Un modèle vierge reste dans le kit et ne doit jamais être confondu avec un cahier projet.

Une reconstitution est conservée séparément avec le statut `reconstructed` jusqu'à validation.

Une évolution postérieure utilise une demande `change-request-post-mvp.md` séparée et ne réécrit jamais le cahier initial.

Les sauvegardes automatiques et copies de mise à jour restent dans les archives du kit et ne deviennent pas de nouveaux cahiers.

Les doublons historiques ne sont pas supprimés automatiquement. Ils sont inventoriés, comparés par empreinte et marqués comme copie, archive ou source officielle avant toute consolidation.

## Initialisation

Le Coordinateur recherche d'abord le dossier officiel, puis les fichiers de projet et enfin les archives du kit. Il produit un inventaire avec chemin, taille, date, empreinte, statut, source et relation au projet. Il ne choisit pas silencieusement entre deux cahiers contradictoires.

Si aucune source n'est retrouvée, il demande le cahier. Une reconstitution n'est possible que si le propriétaire la demande explicitement.

## Modèles disponibles

`project-brief.md` est le modèle universel complet.

`project-brief-blank.md` est le formulaire vierge non accepté.

`reconstruction-existing-project.md` encadre une reconstitution provisoire.

`change-request-post-mvp.md` protège le cahier initial contre les ajouts ultérieurs.

## Inventaire local

Pour rechercher sans supprimer :

```bash
find "$DOCUMENTS_ROOT" -type f \( -iname '*cahier*' -o -iname '*brief*' \) -not -path '*/.git/*' -print
```

Toute consolidation doit préserver les fichiers originaux, créer un rapport de correspondance et être livrée séparément du produit.
