#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
docs="$root/docs"

write_if_missing() {
  local path="$1"
  [ -e "$path" ] && return 0
  mkdir -p "$(dirname "$path")"
  cat > "$path"
}

write_if_missing "$docs/README.md" <<'DOC'
# Dossier de conception du projet

## Statut

[[A_COMPLETER: indiquer `draft`, `review`, `approved` ou `updated`, avec date et responsable.]]

## Rôle

Ce dossier est la source de vérité entre le besoin métier, la conception et le code. Il doit permettre à un développeur, un testeur, un auditeur ou un nouveau membre de comprendre le projet sans déduire des règles implicites.

## Règles de qualité

- Toute affirmation distingue fait vérifié, hypothèse, décision et élément à valider.
- Toute user story possède des critères testables et une priorité.
- Toute interface, donnée sensible, permission, dépendance externe et erreur significative est documentée.
- Chaque diagramme est en Mermaid ou possède une source éditable versionnée.
- Toute évolution modifie, dans le même work item, le code, les tests et les documents touchés.
- Un document non applicable indique `Non applicable` avec une justification contextualisée.

## Index et traçabilité

| Artefact | Finalité | Référence de code ou test | Dernière mise à jour |
| --- | --- | --- | --- |
| Vision et périmètre | besoin, acteurs, limites | [[A_COMPLETER]] | [[A_COMPLETER]] |
| User stories | comportements attendus | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Parcours | étapes et erreurs utilisateur | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Architecture | composants et flux | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Données | entités, règles, rétention | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Contrats | API, événements, interfaces | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Sécurité | menaces et protections | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Roadmap et décisions | plan et arbitrages | [[A_COMPLETER]] | [[A_COMPLETER]] |
DOC

write_if_missing "$docs/product/vision-and-scope.md" <<'DOC'
# Vision, objectifs et périmètre

## Contexte et problème

[[A_COMPLETER: décrire le problème observé, ses conséquences, la situation actuelle et la valeur recherchée.]]

## Parties prenantes et utilisateurs

| Acteur | Besoin | Fréquence | Niveau d accès | Attente de réussite |
| --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Objectifs mesurables

| Objectif | Indicateur | Valeur cible | Méthode de mesure | Horizon |
| --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Périmètre de la première version

[[A_COMPLETER: lister les capacités incluses, leurs limites et les dépendances nécessaires.]]

## Hors périmètre et hypothèses

[[A_COMPLETER: lister explicitement ce qui ne sera pas réalisé et les hypothèses à confirmer.]]

## Contraintes et critères de réussite

[[A_COMPLETER: budget, délai, plateformes, accessibilité, performance, conformité, intégrations et définition de terminé.]]
DOC

write_if_missing "$docs/product/user-stories.md" <<'DOC'
# User stories, règles métier et critères d acceptation

## Convention

Chaque story suit la forme : En tant que `<acteur>`, je veux `<action>`, afin de `<valeur>`. Les critères couvrent le succès, les validations, les erreurs, les permissions et les cas limites.

## Backlog priorisé

| ID | Priorité | User story | Règles métier | Critères d acceptation vérifiables | Tests ou preuve | Statut |
| --- | --- | --- | --- | --- | --- | --- |
| US-001 | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Scénarios d erreur et cas limites

| Référence | Situation | Comportement attendu | Message ou retour | Test associé |
| --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Exigences non fonctionnelles liées

[[A_COMPLETER: accessibilité, performance, sécurité, confidentialité, compatibilité et disponibilité liées aux stories.]]
DOC

write_if_missing "$docs/product/user-flows.md" <<'DOC'
# Parcours utilisateur

## Inventaire des parcours

| ID | Déclencheur | Acteur | Résultat attendu | Échecs et reprises | Stories liées |
| --- | --- | --- | --- | --- | --- |
| FLOW-001 | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Diagramme des parcours critiques

```mermaid
flowchart TD
    A[Arrivée utilisateur] --> B{Condition à documenter}
    B -->|Succès| C[Résultat attendu]
    B -->|Erreur| D[Message, reprise ou support]
```

[[A_COMPLETER: remplacer le diagramme générique par les parcours réels ou indiquer Non applicable avec justification.]]

## Détails par parcours

### FLOW-001

- Préconditions : [[A_COMPLETER]]
- Étapes nominales : [[A_COMPLETER]]
- Validations et erreurs : [[A_COMPLETER]]
- Annulation, reprise et persistance : [[A_COMPLETER]]
- Critères de sortie : [[A_COMPLETER]]
DOC

write_if_missing "$docs/design/architecture.md" <<'DOC'
# Architecture technique

## Décisions et contraintes structurantes

[[A_COMPLETER: technologies retenues, motifs, alternatives écartées, contraintes existantes et conséquences.]]

## Composants et responsabilités

| Composant | Responsabilité | Entrées | Sorties | Dépendances | Observabilité |
| --- | --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Diagramme de contexte et conteneurs

```mermaid
flowchart LR
    U[Utilisateur ou système externe] --> A[Application]
    A --> D[(Données)]
    A --> X[Système externe]
```

[[A_COMPLETER: remplacer par le diagramme réel, nommer les flux et les responsabilités.]]

## Flux critiques et résilience

[[A_COMPLETER: décrire synchronisme, asynchronisme, timeouts, retries, idempotence, dégradations, journalisation et alertes.]]

## Qualité technique

[[A_COMPLETER: sécurité, performance, scalabilité, disponibilité, accessibilité, dette technique et stratégie de tests.]]
DOC

write_if_missing "$docs/design/data-model.md" <<'DOC'
# Modèle de données

## Classification et cycle de vie

| Donnée ou entité | Sensibilité | Source | Usage | Rétention | Suppression | Responsable |
| --- | --- | --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Entités, attributs et règles

| Entité | Attributs clés | Identifiant | Relations | Contraintes et invariants |
| --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Diagramme de données

```mermaid
erDiagram
    ENTITY_A ||--o{ ENTITY_B : relation
```

[[A_COMPLETER: remplacer par les entités réelles ou indiquer Non applicable avec justification.]]

## Migrations, intégrité et sauvegarde

[[A_COMPLETER: décrire stratégie de migration, validation, rollback, sauvegarde et restauration.]]
DOC

write_if_missing "$docs/design/api-contracts.md" <<'DOC'
# Contrats d interfaces

## Conventions communes

[[A_COMPLETER: versionnement, authentification, encodage, pagination, erreurs, idempotence, limites et compatibilité.]]

## API, événements et interfaces partagées

| ID | Consommateur | Opération ou événement | Entrée validée | Sortie ou erreur | Autorisation | Tests |
| --- | --- | --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Exemple de contrat critique

```json
{
  "[[A_COMPLETER: champ]]": "[[A_COMPLETER: valeur ou type]]"
}
```

## Compatibilité et dépréciation

[[A_COMPLETER: clients affectés, stratégie de version, période de compatibilité, migration et retrait.]]
DOC

write_if_missing "$docs/design/security-design.md" <<'DOC'
# Conception de sécurité

## Périmètre et actifs à protéger

| Actif | Propriétaire | Sensibilité | Menace principale | Protection | Preuve |
| --- | --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Authentification, autorisation et secrets

[[A_COMPLETER: identité, sessions ou tokens, rôles, permissions, moindre privilège, rotation et stockage hors dépôt.]]

## Analyse de menaces

| Menace | Vecteur | Impact | Probabilité | Mesure préventive | Détection | Risque résiduel |
| --- | --- | --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Exigences de sécurité vérifiables

[[A_COMPLETER: validation des entrées, protections réseau, journalisation, dépendances, chiffrement, sauvegardes et tests sécurité.]]
DOC

write_if_missing "$docs/delivery/roadmap.md" <<'DOC'
# Roadmap et plan de livraison

## Incréments

| Incrément | Objectif | Stories incluses | Dépendances | Risques | Critères de sortie | État |
| --- | --- | --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Plan de validation et retour

[[A_COMPLETER: environnements, tests, approbations, déploiement, monitoring, rollback et communication.]]

## Écarts de périmètre

[[A_COMPLETER: décisions de report, dette assumée et raison.]]
DOC

write_if_missing "$docs/delivery/decision-log.md" <<'DOC'
# Journal des décisions

| ID | Date | Décision | Contexte et options | Conséquence | Propriétaire | Révision |
| --- | --- | --- | --- | --- | --- | --- |
| ADR-001 | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |
DOC

write_if_missing "$docs/diagrams/README.md" <<'DOC'
# Diagrammes

Conserver ici les sources Mermaid ou éditables. Chaque diagramme est référencé depuis un document de conception, possède un objectif, une date, un propriétaire et une légende. Ne jamais déposer seulement une image sans source modifiable.

| Fichier | Type | Objectif | Document référent | Statut |
| --- | --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |
DOC

write_if_missing "$docs/design/design-readiness.md" <<'DOC'
# Design readiness

Status: draft

## Validation

- [ ] Cahier des charges accepté et périmètre MVP/Post-MVP arrêté
- [ ] Vision, stories et parcours cohérents
- [ ] Architecture, données, contrats et sécurité relus
- [ ] Direction visuelle et médias définis si applicable
- [ ] Diagrammes, roadmap et décisions à jour
- [ ] Audit de conception effectué
- [ ] Aucun marqueur `[[A_COMPLETER]]`, TODO ou FIXME non traité

## Preuves et approbation

- Auditeur : [[A_COMPLETER]]
- Date : [[A_COMPLETER]]
- Décision : [[A_COMPLETER]]
DOC
echo "Documentation de conception initialisée dans $docs. Remplacer tous les marqueurs [[A_COMPLETER]] par une conception issue du cahier des charges, obtenir Status: approved dans design-readiness.md, puis seulement lancer le développement."

write_if_missing "$docs/design/visual-direction.md" <<'DOC'
# Direction artistique et expérience visuelle

## Statut et intention

Statut : [[A_COMPLETER: draft, review, approved ou updated]]

[[A_COMPLETER: formuler l'émotion, la personnalité et la promesse visuelle du produit.]]

## Références et anti-références

- Références : [[A_COMPLETER]]
- Anti-références : [[A_COMPLETER]]
- Différenciation attendue : [[A_COMPLETER]]

## Système visuel

| Élément | Décision | Justification produit | Exemple ou token |
| --- | --- | --- | --- |
| Palette | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Typographie | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Espacement | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Formes et profondeur | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |
| Iconographie et illustration | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Composants, états et motion

Documenter les composants réutilisables, les états loading, vide, erreur, succès, focus et désactivé. Décrire les transitions, durées, courbes, déclencheurs et comportement avec `prefers-reduced-motion`.

[[A_COMPLETER]]

## Responsive, accessibilité et performance

[[A_COMPLETER: points de rupture, clavier, lecteur d'écran, contraste, taille de texte, budget de performance et stratégie de chargement.]]

## Validation visuelle

Captures attendues : [[A_COMPLETER]]
Parcours vérifiés : [[A_COMPLETER]]
Auditeur : [[A_COMPLETER]]
Date : [[A_COMPLETER]]
DOC

echo "Direction artistique initialisée dans $docs/design/visual-direction.md"

write_if_missing "$docs/design/media-inventory.md" <<'DOC'
# Inventaire des médias

Chaque image, photo, illustration, vidéo, icône ou texture utilisée dans le produit doit être recensée avant livraison.

| ID | Fichier ou URL | Type | Auteur ou fournisseur | Licence et preuve | Date | Retouches | Usage | Statut |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MEDIA-001 | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Règles

- Ne jamais utiliser une ressource sans provenance et licence vérifiable.
- Conserver l'URL, la date de consultation et les obligations d'attribution.
- Documenter le brief et les retouches d'une image générée.
- Ne pas retirer de filigrane, scraper ou présenter un visuel temporaire comme final.
- Contrôler réalisme, artefacts, texte illisible, visages, mains, logos et conformité au produit.
DOC

echo "Inventaire médias initialisé dans $docs/design/media-inventory.md"

write_if_missing "$docs/quality/quality-journal.md" <<'DOC'
# Journal qualité, bugs et risques

## Règle de fonctionnement

Ce journal est le registre unique et chronologique des défauts, bugs, vulnérabilités, écarts de conception, régressions, résultats d audit et corrections. Tous les agents concernés lisent le journal avant leur audit et ajoutent ou mettent à jour les entrées dans le même work item. Les rapports spécialisés peuvent détailler une analyse, mais aucune anomalie ne doit exister uniquement dans un rapport isolé.

## Statuts autorisés

`open`, `in-progress`, `fixed`, `verified`, `accepted-risk`, `wont-fix`, `duplicate`, `blocked`.

Une entrée `fixed` n est pas résolue tant qu une preuve de vérification indépendante ne l a pas fait passer à `verified`. Une entrée `accepted-risk` exige une décision humaine identifiée, une échéance de révision et une mesure de réduction du risque.

## Registre principal

| ID | Date | Source | Catégorie | Gravité | Composant | Description et impact | Preuve | Responsable | Work item ou commit | Correction | Vérification | Statut | Date de clôture |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## Fiche détaillée obligatoire pour les niveaux élevé et critique

### [[QJ-XXX]]

- Détecté par : [[A_COMPLETER]]
- Date et contexte : [[A_COMPLETER]]
- Catégorie : bug, sécurité, conception, performance, accessibilité, test, documentation ou exploitation
- Gravité et justification : [[A_COMPLETER]]
- Actifs, utilisateurs ou composants affectés : [[A_COMPLETER]]
- Scénario reproductible : [[A_COMPLETER]]
- Preuves conservées : [[A_COMPLETER]]
- Cause racine ou hypothèse : [[A_COMPLETER]]
- Correction choisie et alternatives écartées : [[A_COMPLETER]]
- Tests de non régression : [[A_COMPLETER]]
- Vérification indépendante : [[A_COMPLETER]]
- Risque résiduel et décision humaine éventuelle : [[A_COMPLETER]]
DOC

echo "Journal qualité initialisé dans $docs/quality/quality-journal.md"

write_if_missing "$docs/project-management/trello-board.md" <<'DOC'
# Tableau Trello du projet

## Paramétrage

- Nom du tableau : [[A_COMPLETER]]
- Mode : tableau complet toujours généré ; synchronisation externe si intégration autorisée
- Responsable du tableau : [[A_COMPLETER]]
- Dernière synchronisation : [[A_COMPLETER]]

## Membres et rôles

| Membre | Rôle projet | Identifiant Trello | Cartes attribuées |
| --- | --- | --- | --- |
| [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

## Règle de synchronisation

Ce document est la source versionnée du tableau. Chaque carte possède un identifiant stable, un objectif, un périmètre, des dépendances, des critères d acceptation, une estimation, un responsable, une preuve attendue et un lien vers le work item. Le Coordinateur met à jour ce document avant toute création ou modification du tableau externe.

## Listes du tableau

1. À trier
2. Prêt à concevoir
3. Conception en cours
4. Prêt à développer
5. En développement
6. En revue
7. En validation
8. Bloqué
9. Terminé
10. Archivé

## Cartes détaillées

| ID | Liste | Feature | Titre | Description détaillée | Dépendances | Critères d acceptation | Preuve | Responsable | Estimation | Priorité |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CARD-001 | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] | [[A_COMPLETER]] |

### Checklist Definition of Done de chaque carte

- [ ] Conception et contrat concernés mis à jour
- [ ] Code de la feature terminé sur sa branche dédiée
- [ ] Cas nominal et cas d erreur testés
- [ ] Sécurité et permissions vérifiées
- [ ] Accessibilité et responsive vérifiés si frontend
- [ ] Documentation et journal qualité mis à jour
- [ ] Revue indépendante effectuée
- [ ] Preuve reproductible ajoutée
- [ ] Pull Request validée et prête à fusionner

## Checklist de complétude

- Chaque user story du cahier est liée à une ou plusieurs cartes.
- Chaque carte est assez petite pour une branche et des commits atomiques.
- Les tâches de conception, développement, tests, sécurité, documentation et livraison sont présentes.
- Les dépendances et blocages sont explicites.
- Les critères d acceptation sont vérifiables.
- Les cartes terminées référencent une preuve et un identifiant du journal qualité.
DOC

echo "Plan Trello initialisé dans $docs/project-management/trello-board.md"
