# Chaos testing et observabilité AGENTIC 2.0

Le harnais `scripts/chaos_observability.py` vérifie les reprises locales dans
un répertoire temporaire par scénario. Il couvre les fautes `crash`,
`interruption`, `network_unavailable`, `slow_ci`, `git_index_locked`,
`concurrency` et `resume`.

Chaque faute transitoire est tentée au maximum trois fois: tentative initiale
et deux reprises. Le verrou Git est un fichier synthétique dans l'espace
temporaire; aucun index du checkout appelant n'est lu ou modifié. Le mode
concurrent utilise un espace isolé par thread.

`MetricsSink` écrit des lignes JSONL append-only avec un identifiant tronqué
issu d'un hash. Les métriques ne contiennent ni prompt, ni sortie complète,
ni secret, ni chemin utilisateur. Elles décrivent les résultats observés et
ne prouvent pas l'état natif d'un Goal, une CI ou un déploiement.

Exécution locale:

```bash
python3 -m unittest tests/test_chaos_observability.py
python3 -m unittest discover -s tests -p 'test_*.py'
```
