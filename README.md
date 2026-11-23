# CampusFlow

Application mobile d'aide à la gestion académique pour les étudiants d'Afrique francophone (Burkina Faso en priorité). CampusFlow permet de suivre ses cours, ses échéances de devoirs/examens et ses tâches au quotidien, en tenant compte des contraintes réelles du terrain (connectivité mobile intermittente, téléphones d'entrée de gamme, maîtrise de la consommation de données).

Projet réalisé dans le cadre du module de Programmation Mobile (Master 1).

## Plan du dépôt

```text
campusflow/                      ← Racine du dépôt Git
├── AGENTS.md                    ← Règles et consignes pour l'agent de développement
├── README.md                    ← Présentation, guide d'installation et de lancement
├── docs/                        ← Documentation d'architecture et livrables de séances
│   ├── ARCHITECTURE.md          ← Dossier d'architecture technique (source de vérité)
│   ├── seance1/                 ← Séance 1 : Écosystème mobile (comparatif, autopsie, décision)
│   ├── seance2/                 ← Séance 2 : UX/UI, personas, wireframes, design system
│   └── captures/                ← Captures d'écran de validation
├── campusflow_models/           ← Package Dart pur (modèles Task, Course, User) [Séance 3]
├── campusflow_app/              ← Application mobile Flutter [Séances 4 à 7]
└── server/                      ← API REST simulée json-server / Node.js [Séance 7]
```

## Architecture & Choix structurants

Pour le détail des choix architecturaux (Flutter, Riverpod, GoRouter, Dio, design system, sécurité), consultez [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Séance 3 — Modèles de données Dart (`campusflow_models`)

Création du package Dart pur `campusflow_models` contenant les modèles immuables de l'application (`Task`, `Course`, `User`), la sérialisation JSON, et un dépôt simulé asynchrone pour les tests.

Commandes de vérification du package :
```bash
cd campusflow_models
dart analyze
dart test
```


