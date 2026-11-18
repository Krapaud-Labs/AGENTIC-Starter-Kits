# Politique des budgets Goal, retries, agents et métriques

Les valeurs générales par défaut d’un Goal sont 30 minutes, 40 étapes et 50 000 tokens. Une limite spécifique documentée pour la tâche ou le work item courant prime sur ces valeurs générales et doit être reprise dans le Goal natif et l’état runtime. En l’absence de limite spécifique, appliquer les valeurs générales. Les retries sont limités à deux et les appels d'agents à trois par Goal. Une reprise est réservée aux erreurs transitoires identifiables. Les métriques locales excluent prompts, sorties complètes, secrets et données personnelles, et ne remplacent jamais l'état natif du Goal.

Une seconde tentative d'agent utilise un contexte neuf et un périmètre réduit. Une troisième tentative avec la même signature de blocage est interdite et exige l'arrêt propre, la récupération du rapport et une alternative.
