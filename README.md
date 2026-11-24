# CampusFlow

> 📋 **Récapitulatif du rendu enseignant** : Consultez le document [docs/RENDU.md](docs/RENDU.md) contenant la grille d'auto-vérification complète (séances 1 à 7), la liste exhaustive des fichiers, captures et commits associés.

Application mobile d'aide à la gestion académique pour les étudiants d'Afrique francophone (Burkina Faso en priorité). CampusFlow permet de suivre ses cours, ses échéances de devoirs/examens et ses tâches au quotidien, en tenant compte des contraintes réelles du terrain (connectivité mobile intermittente, téléphones d'entrée de gamme, maîtrise de la consommation de données).

Projet réalisé dans le cadre du module de Programmation Mobile (Master 1).

## Plan du dépôt

```text
campusflow/                      ← Racine du dépôt Git
├── AGENTS.md                    ← Règles et consignes pour l'agent de développement
├── README.md                    ← Présentation, guide d'installation et de lancement
├── docs/                        ← Documentation d'architecture et livrables de séances
│   ├── RENDU.md                 ← Récapitulatif d'auto-vérification pour l'enseignant
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

## Séance 7 — API simulée et authentification complète

### 1. Lancement de l'API avec authentification
Le serveur Node.js (`server/server.js`) gère l'authentification (`POST /login`), la validation des jetons Bearer sur toutes les routes protégées (`/taches`, `/cours`, `/utilisateurs`) et renvoie une erreur 401 si le jeton est absent ou invalide.

Commandes d'installation et de lancement du serveur :
```bash
cd server
npm install
npm start
```
*(Pour lancer la version sans authentification utilisée au TP24, utiliser `npm run start:simple`).*

### 2. Compte de démonstration
Pour vous connecter dans l'application mobile :
- **Email** : `etudiant@campusflow.bf`
- **Mot de passe** : `campus2026`

### 3. Lancement de l'application mobile
Dans un second terminal :
```bash
cd campusflow_app
flutter run
```

### 4. Tests et vérifications qualité
```bash
# Vérification du package de modèles
cd campusflow_models
dart analyze
dart test

# Vérification de l'application mobile
cd ../campusflow_app
flutter analyze
flutter test
```

## Outils utilisés et démarche

Ce projet a été réalisé avec l'aide d'outils d'intelligence artificielle :
- **Agent Antigravity (Google)** : écriture du code et des documents, à
  partir de consignes rédigées TP par TP ;
- **Claude (Anthropic)** : assistant d'architecture (choix techniques,
  fichiers AGENTS.md et docs/ARCHITECTURE.md, rédaction des consignes,
  relecture des comptes rendus).

Mon rôle :
- installation et configuration de l'environnement (Flutter, Android SDK 36,
  émulateur, Node.js) ;
- décisions de conception (plateforme Android + Flutter, choix de la
  variante C de l'écran Échéances) ;
- vérification de chaque TP sur l'émulateur et tests manuels (CRUD, panne
  du serveur, connexion, jeton expiré, déconnexion) ;
- repérage des défauts et demandes de correction (libellés de navigation,
  filtres coupés, chiffres non sourcés, cohérence du profil avec le persona) ;
- captures d'écran et suivi du dépôt Git.

Les fichiers AGENTS.md et docs/ARCHITECTURE.md sont les consignes données à
l'agent ; ils sont laissés dans le dépôt par transparence.





