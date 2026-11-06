# Contrat d'orchestration AGENTIC 2.0

Le coordinateur doit valider la combinaison `rôle/modèle/capacités` avant toute
délégation. Une mission est bornée, non vide et dépourvue de secrets. Les
budgets sont partagés entre le coordinateur et les enfants : 3 enfants, 40
étapes et 50 000 tokens au maximum par Goal, sauf plafond plus bas explicite.

La délégation récursive est interdite par défaut. Le rôle doit déclarer sa
capacité de délégation et la profondeur doit rester dans la limite. Le modèle
doit autoriser le rôle et le rôle doit autoriser le modèle. Un rapport expose
uniquement l'identité logique de la tâche, le rôle, le modèle, les constats et
les compteurs. Il ne contient ni secret, ni chemin personnel, ni contenu de
contexte. Un rapport ne prouve pas à lui seul la livraison ou l'approbation.

L'implémentation exécutable est `scripts/agentic_orchestration.py`; les tests
de délégation, sélection, capacités, limites et sécurité sont dans
`tests/test_agentic_orchestration.py`.
