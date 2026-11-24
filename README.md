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

## Environnement

- **Flutter** : version `3.47.9` (channel stable)
- **Dart** : version `3.13.7`
- **Android SDK** : version `36` (Plateforme Android 36, Build-Tools 36.0.0, Emulator 37.3.10.0, toutes licences acceptées)
- **Émulateur Android** : `CampusFlow_Pixel` (Google Pixel 7, API 36 `google_apis/x86_64`, stocké sur `D:` via `ANDROID_AVD_HOME=D:\AndroidSdk\avd`)
- **Validation** : voir la sortie détaillée dans [docs/captures/flutter_doctor.txt](docs/captures/flutter_doctor.txt) et la capture d'écran [docs/captures/flutter_doctor.png](docs/captures/flutter_doctor.png).
- *Note sur Visual Studio* : L'avertissement éventuel affiché par `flutter doctor` sur Visual Studio / Windows 10 SDK concerne uniquement le ciblage d'applications bureau Windows natives et n'est absolument pas bloquant pour le développement mobile (Android / iOS) et Web.

## Séance 3 — Modèles de données Dart (`campusflow_models`)

Création du package Dart pur `campusflow_models` contenant les modèles immuables de l'application (`Task`, `Course`, `User`), la sérialisation JSON, et un dépôt simulé asynchrone pour les tests.

Commandes de vérification du package :
```bash
cd campusflow_models
dart analyze
dart test
```

## Séance 7 — API simulée (`server`)

Mise en place d'une API REST locale simulée avec `json-server@0.17.4` et `db.json`, exposant les ressources `/taches`, `/cours` et `/utilisateurs`.

Commandes d'installation et de lancement du serveur :
```bash
cd server
npm install
npm run start:simple
```



