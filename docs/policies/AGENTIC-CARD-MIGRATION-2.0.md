# Migration des cartes AGENTIC 1.x vers 2.0

Le script `scripts/migrate_agentic_card.py` migre une carte située à
`<projet>/agentic-card.json` dans un espace de projet isolé.

## Garanties

- `--dry-run` valide la carte et affiche le checksum SHA-256 sans écrire.
- Une migration réelle écrit d abord une copie dans
  `.migration-backups/agentic-card.json`, puis remplace le fichier de façon
  atomique. Le checksum de la source est conservé dans `migration`.
- `--rollback` restaure la sauvegarde la plus récente et refuse d agir si elle
  est absente.
- Les entrées absentes ou déjà en `2.x`, le JSON invalide et les cartes sans
  `id` ou `title` sont refusés sans créer de sauvegarde.

Exemples :

```sh
python3 scripts/migrate_agentic_card.py /chemin/projet --dry-run
python3 scripts/migrate_agentic_card.py /chemin/projet
python3 scripts/migrate_agentic_card.py /chemin/projet --rollback
```

La fixture de référence est `tests/fixtures/agentic-card-v1-project` et les
scénarios sont dans `tests/test_migrate_agentic_card.py`.
