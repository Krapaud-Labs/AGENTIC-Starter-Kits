# Architecture Agentic 2.0

## Objectif

La version 2.0 repart sur une installation shared unique et une migration obligatoire depuis la 1.x. Elle conserve Codex et Claude, mais impose des contrats identiques, un état runtime canonique et une orchestration vérifiable.

## Flux principal

```text
demande
  -> coordinateur
  -> Goal et plan consolidé
  -> routage par capacités
  -> agents isolés par lots
  -> intégrateur unique
  -> contrôles rapides
  -> audit uniquement sur demande ou carte dédiée
  -> PR unique vers dev
```

## Rôles

- Le Coordinateur planifie, route, intègre et livre.
- Les agents spécialisés produisent uniquement leur lot et leur rapport.
- L intégrateur est le seul acteur autorisé à manipuler l index Git principal.
- L auditeur intervient uniquement lorsqu une carte d audit ou une demande explicite l active.

## État

Un seul document runtime canonique contient le Goal, l action courante, la prochaine action, les portes, les agents et les preuves. Chaque transition est validée, idempotente et journalisée. Une reprise relit l état réel avant d écrire et ne répète pas une action déjà confirmée.

## Limites

Chaque Goal possède des plafonds de durée, étapes, tokens, agents et reprises. Une limite atteinte déclenche une consolidation ou une question réellement humaine, jamais une boucle automatique.

## Sécurité

Les rapports et preuves sont anonymisés avant publication. Les secrets, chemins personnels et données projet restent hors des rapports. Les permissions sont vérifiées par action et par rôle.

## Migration

La migration 1.x est précédée d un dry-run, d une sauvegarde et d un checksum. Toute erreur déclenche un rollback vérifiable. La migration ne supprime jamais le code ni les documents produit.
