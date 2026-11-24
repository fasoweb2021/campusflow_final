# Récapitulatif du Projet CampusFlow — Rendu Final

- **Étudiant** : KINDO Salifou
- **Dépôt GitHub** : [https://github.com/fasoweb2021/campusflow_final](https://github.com/fasoweb2021/campusflow_final)
- **Destinataire enseignant** : `moctar.compaore@gmail.com`

---

## Lancer le projet

### 1. Démarrer le serveur API (Node.js & json-server avec authentification)
```bash
cd server
npm install
npm start
```
*Le serveur écoute sur `http://localhost:3000` (accessible via `http://10.0.2.2:3000` depuis l'émulateur Android).*

### 2. Démarrer l'application mobile Flutter
Dans un second terminal :
```bash
cd campusflow_app
flutter pub get
flutter run
```

### 3. Compte de démonstration
- **Email** : `etudiant@campusflow.bf`
- **Mot de passe** : `campus2026`

---

## Grille d'auto-vérification (Séances 1 à 7)

Chaque point reprend fidèlement la liste d'auto-vérification de l'énoncé avec ses fichiers, captures et commits associés.

### • Séance 1 : la fiche comparative, l'autopsie sourcée et le paragraphe de décision pour CampusFlow
- **Fichiers concernés** :
  - [docs/seance1/01_fiche_comparative.md](seance1/01_fiche_comparative.md) (14 critères avec focus Afrique francophone & sources StatCounter)
  - [docs/seance1/02_autopsie_blackberry.md](seance1/02_autopsie_blackberry.md) (3 causes classées avec faits, mécanismes et leçons)
  - [docs/seance1/03_decision_campusflow.md](seance1/03_decision_campusflow.md) (décision argumentée Android / Flutter)
  - [docs/ARCHITECTURE.md](ARCHITECTURE.md) (dossier technique de référence)
- **Captures** : *(Livrables textuels et analytiques en Markdown)*
- **Commits associés** :
  - `934e430` — `TP01 - Initialisation du dépôt et fiche comparative Android/iOS`
  - `79abaa2` — `TP02 - Autopsie de BlackBerry OS (3 causes classées et sourcées)`
  - `3960472` — `TP02 - Correction des chiffres non sourcés de l'autopsie`
  - `2475b9a` — `TP03 - Décision de plateforme argumentée pour CampusFlow`
  - `1b58453` — `TP03 - Mise en cohérence de la décision avec le périmètre v1`

---

### • Séance 2 : le persona, le parcours, les 5 wireframes (avec 3 variantes d'un écran) et le design system v1
- **Fichiers concernés** :
  - [docs/seance2/04_persona_job_stories.md](seance2/04_persona_job_stories.md) (Moussa Ouédraogo, contexte et 2 job stories)
  - [docs/seance2/05_parcours_utilisateur.md](seance2/05_parcours_utilisateur.md) (parcours en 5 étapes et opportunités retenues)
  - [docs/seance2/wireframes/](seance2/wireframes/) :
    - `01_echeances.svg`, `01_echeances_variante_A.svg`, `01_echeances_variante_B.svg`, `01_echeances_variante_C.svg`
    - `02_detail_tache.svg`, `03_nouvelle_tache.svg`, `04_cours.svg`, `05_connexion.svg`
    - [docs/seance2/wireframes/index.md](seance2/wireframes/index.md)
  - [docs/seance2/06_choix_variante.md](seance2/06_choix_variante.md) (grille d'évaluation et choix de la variante C)
  - [docs/seance2/07_design_system.md](seance2/07_design_system.md) (couleurs, contrastes WCAG AAA, typographie, composants)
  - [docs/seance2/design_system.svg](seance2/design_system.svg) (planche visuelle d'une page)
- **Captures** : Wireframes et planche SVG directement visualisables dans `docs/seance2/`
- **Commits associés** :
  - `5ee8ef0` — `TP04 - Persona étudiant et deux job stories`
  - `8ed03a9` — `TP05 - Parcours utilisateur suivre mes échéances`
  - `506a43d` — `TP06 - Wireframes des 5 écrans et 3 variantes de l'écran Échéances`
  - `932f4f1` — `TP06 - Décision finale sur la variante de l'écran Échéances`
  - `4bd62ef` — `TP07 - Design system v1 (couleurs, typographie, composants)`

---

### • Séance 3 : le package campusflow_models avec Task, Course, User, fromJson et 3 tests qui passent
- **Fichiers concernés** :
  - [campusflow_models/lib/campusflow_models.dart](../campusflow_models/lib/campusflow_models.dart) (export principal)
  - [campusflow_models/lib/src/task.dart](../campusflow_models/lib/src/task.dart) (modèle immuable avec `isOverdue`, `copyWith`, `fromJson`, `toJson`)
  - [campusflow_models/lib/src/course.dart](../campusflow_models/lib/src/course.dart) & [campusflow_models/lib/src/user.dart](../campusflow_models/lib/src/user.dart)
  - [campusflow_models/lib/src/mock_task_repository.dart](../campusflow_models/lib/src/mock_task_repository.dart) (dépôt asynchrone simulé)
  - [campusflow_models/test/campusflow_models_test.dart](../campusflow_models/test/campusflow_models_test.dart) (7 tests unitaires)
- **Captures** : *(Validé par `dart test` sans erreur)*
- **Commits associés** :
  - `ef498df` — `TP08 - Création du package Dart campusflow_models`
  - `5798a8f` — `TP09 - Modèles immuables Task, Course et User avec copyWith`
  - `c76de80` — `TP10 - fromJson/toJson et dépôt simulé asynchrone`
  - `489d17f` — `TP11 - Tests unitaires du package (copyWith, fromJson, erreurs)`

---

### • Séance 4 : flutter doctor sans erreur, l'application sur l'émulateur, le thème centralisé, un asset affiché et au moins 3 commits
- **Fichiers concernés** :
  - [campusflow_app/lib/core/theme/app_theme.dart](../campusflow_app/lib/core/theme/app_theme.dart) (thème M3 centralisé, zéro couleur en dur)
  - [campusflow_app/assets/images/logo_campusflow.png](../campusflow_app/assets/images/logo_campusflow.png) (asset logo)
  - [campusflow_app/lib/app.dart](../campusflow_app/lib/app.dart) (application racine)
  - [docs/captures/flutter_doctor.txt](captures/flutter_doctor.txt) (rapport `flutter doctor -v`)
- **Captures** :
  - [docs/captures/flutter_doctor.png](captures/flutter_doctor.png) (`flutter doctor` sans erreur)
  - [docs/captures/s4_premier_lancement.png](captures/s4_premier_lancement.png) (premier lancement sur émulateur)
  - [docs/captures/s4_ecran_titre.png](captures/s4_ecran_titre.png) (écran de titre avec logo, typographie et date intl)
- **Commits associés** :
  - `77964ad` — `TP12 - Environnement Flutter installé (flutter doctor sans erreur)`
  - `96984f2` — `TP13 - Création du projet Flutter campusflow_app`
  - `f97ea51` — `TP12-TP13 - Captures flutter doctor et premier lancement`
  - `137d4ed` — `TP14 - Thème centralisé issu du design system et écran de titre`
  - `613f19b` — `TP15 - Ajout du package intl et du logo en asset`
  - `1ed6bcf` — `TP15 - Capture de l'écran de titre`

---

### • Séance 5 : les écrans Échéances, Détail et Formulaire, et la version tablette à 840 dp
- **Fichiers concernés** :
  - [campusflow_app/lib/features/tasks/echeances_screen.dart](../campusflow_app/lib/features/tasks/echeances_screen.dart) (LayoutBuilder responsive au seuil 840 dp)
  - [campusflow_app/lib/features/tasks/widgets/task_tile.dart](../campusflow_app/lib/features/tasks/widgets/task_tile.dart) (tuile variante C)
  - [campusflow_app/lib/features/tasks/widgets/task_detail_view.dart](../campusflow_app/lib/features/tasks/widgets/task_detail_view.dart) (panneau de détail partagé)
  - [campusflow_app/lib/features/tasks/task_detail_screen.dart](../campusflow_app/lib/features/tasks/task_detail_screen.dart) (écran de détail plein écran)
  - [campusflow_app/lib/features/tasks/task_form_screen.dart](../campusflow_app/lib/features/tasks/task_form_screen.dart) (formulaire avec validation et date picker)
- **Captures** :
  - [docs/captures/s5_telephone.png](captures/s5_telephone.png) (rendu sur téléphone)
  - [docs/captures/s5_tablette.png](captures/s5_tablette.png) (rendu tablette master-detail split-view $\ge 840\text{ dp}$)
- **Commits associés** :
  - `c7f520a` — `TP16 - Écran Échéances (ListView.builder, FAB, NavigationBar)`
  - `eeddb2c` — `TP16 - Libellés de navigation, tuile lisible et tri par date`
  - `027957c` — `TP17 - Écran de détail d'une tâche avec action principale`
  - `47e74d5` — `TP18 - Formulaire de nouvelle tâche avec validation et SnackBar`
  - `287407b` — `TP19 - Mise en page tablette liste/détail au seuil de 840 dp`
  - `c4b0c30` — `TP19 - Captures téléphone et tablette`

---

### • Séance 6 : la navigation par adresses, l'état partagé entre les trois écrans et les trois filtres
- **Fichiers concernés** :
  - [campusflow_app/lib/router/app_router.dart](../campusflow_app/lib/router/app_router.dart) (GoRouter avec ShellRoute `/login`, `/taches`, `/cours`, `/profil`)
  - [campusflow_app/lib/shell/app_shell.dart](../campusflow_app/lib/shell/app_shell.dart) (coque avec NavigationBar et NavigationRail)
  - [campusflow_app/lib/features/tasks/providers/taches_notifier.dart](../campusflow_app/lib/features/tasks/providers/taches_notifier.dart) (TachesNotifier immuable)
  - [campusflow_app/lib/features/tasks/providers/filtres.dart](../campusflow_app/lib/features/tasks/providers/filtres.dart) (filtreProvider, tachesFiltreesProvider, compteursProvider)
  - [campusflow_app/lib/features/courses/cours_screen.dart](../campusflow_app/lib/features/courses/cours_screen.dart) & [campusflow_app/lib/features/profile/profil_screen.dart](../campusflow_app/lib/features/profile/profil_screen.dart)
  - [campusflow_app/test/taches_notifier_test.dart](../campusflow_app/test/taches_notifier_test.dart) & [campusflow_app/test/filtres_test.dart](../campusflow_app/test/filtres_test.dart)
- **Captures** :
  - [docs/captures/s6_filtres.png](captures/s6_filtres.png) (SegmentedButton avec compteurs et filtrage réactif)
- **Commits associés** :
  - `07766bf` — `TP20 - Ajout de flutter_riverpod et go_router, ProviderScope`
  - `5e842b1` — `TP21 - Navigation par adresses avec GoRouter et ShellRoute`
  - `49bfbec` — `TP21 - Profil aligné sur le persona`
  - `587d498` — `TP22 - État partagé des tâches avec TachesNotifier (Riverpod)`
  - `8dcfb1d` — `TP23 - Filtres à faire / faites / en retard (provider dérivé)`
  - `f2e1bb3` — `TP23 - Filtres lisibles et libellés de navigation restaurés`
  - `79ce800` — `TP23 - Capture des filtres`

---

### • Séance 7 : l'API json-server, les couches Repository, la liste connectée (création, PATCH, DELETE) et la connexion avec jeton sécurisé
- **Fichiers concernés** :
  - [server/db.json](../server/db.json) & [server/server.js](../server/server.js) (serveur Express/json-server avec jetons Bearer)
  - [server/package.json](../server/package.json) (scripts `start` et `start:simple`)
  - [campusflow_app/lib/core/config/api_config.dart](../campusflow_app/lib/core/config/api_config.dart) (baseUrl 10.0.2.2 / localhost)
  - [campusflow_app/lib/core/network/dio_client.dart](../campusflow_app/lib/core/network/dio_client.dart) & [campusflow_app/lib/core/network/auth_interceptor.dart](../campusflow_app/lib/core/network/auth_interceptor.dart)
  - [campusflow_app/lib/core/storage/token_storage.dart](../campusflow_app/lib/core/storage/token_storage.dart) (wrapper flutter_secure_storage)
  - [campusflow_app/lib/data/task_repository.dart](../campusflow_app/lib/data/task_repository.dart), [api_task_repository.dart](../campusflow_app/lib/data/api_task_repository.dart), [fake_task_repository.dart](../campusflow_app/lib/data/fake_task_repository.dart)
  - [campusflow_app/lib/data/auth_repository.dart](../campusflow_app/lib/data/auth_repository.dart) & [campusflow_app/lib/features/auth/auth_notifier.dart](../campusflow_app/lib/features/auth/auth_notifier.dart)
  - [campusflow_app/lib/features/auth/login_screen.dart](../campusflow_app/lib/features/auth/login_screen.dart) (formulaire de connexion sécurisé)
  - [campusflow_app/test/auth_flow_test.dart](../campusflow_app/test/auth_flow_test.dart) (tests du flux d'authentification)
- **Captures** :
  - [docs/captures/s7_api.png](captures/s7_api.png) (API json-server opérationnelle)
  - [docs/captures/s7_chargement.png](captures/s7_chargement.png) (état de chargement asynchrone)
  - [docs/captures/s7_erreur.png](captures/s7_erreur.png) (état d'erreur avec bouton Réessayer)
  - [docs/captures/s7_login_erreur.png](captures/s7_login_erreur.png) (erreur d'authentification identifiants incorrects)
  - [docs/captures/s7_redirection_401.png](captures/s7_redirection_401.png) (redirection automatique sur 401 vers `/login`)
- **Commits associés** :
  - `85a5b75` — `TP24 - API simulée json-server avec db.json`
  - `6671300` — `TP24 - Capture de l'API json-server`
  - `36834b6` — `TP25 - Architecture en couches : client Dio et TaskRepository`
  - `b0251a7` — `TP26 - CRUD asynchrone avec AsyncNotifier (GET, POST, PATCH, DELETE)`
  - `b142caf` — `TP26 - Captures des états chargement et erreur`
  - `d6f353f` — `TP27 - Authentification : login, jeton sécurisé, intercepteur et redirection 401`
  - `c9b6682` — `TP27 - Captures de l'authentification`
  - `99d320c` — `TP27 - Ajustement de l'état de chargement du login`

---

### • Le lien du dépôt GitHub est ouvert en lecture et envoyé à moctar.compaore@gmail.com
- **Dépôt public** : [https://github.com/fasoweb2021/campusflow_final](https://github.com/fasoweb2021/campusflow_final)
- **Accès enseignant** : vérifié accessible en navigation privée.

---

## Statistiques globales du projet

- **Nombre total de commits** : 42 commits (dépassant l'exigence minimale de $\ge 27$).
- **Nombre total de tests automatisés** : 39 tests réussis à 100% :
  - `campusflow_models` : 7 tests unitaires (`dart test`).
  - `campusflow_app` : 32 tests unitaires et de widgets (`flutter test`).
- **Qualité du code** : 0 erreur de linting (`flutter analyze` et `dart analyze` sans aucun avertissement).
