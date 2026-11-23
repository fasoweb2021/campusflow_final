# CampusFlow — Dossier d'architecture

> Document de référence fixé par l'architecte. L'agent de développement s'y
> conforme. Toute évolution passe par une mise à jour de ce document.

## 1. Vision et décisions structurantes

**CampusFlow** aide un étudiant à suivre ses cours, ses échéances et ses tâches.

| Décision | Choix | Justification courte |
|---|---|---|
| Cible | Étudiants d'Afrique francophone (Burkina Faso en premier) | Contexte de l'énoncé |
| Plateforme prioritaire | **Android** (téléphones d'entrée et milieu de gamme), iOS en second | Android est très largement majoritaire dans la région ; à sourcer en séance 1 (StatCounter) |
| Approche | **Cross-platform avec Flutter** | Un seul code pour Android et iOS, bon rendu sur appareils modestes, imposé par la suite du cours |
| Données | API REST (simulée par json-server) | Séance 7 |
| État | Riverpod (sans génération de code) | Séance 6 |
| Navigation | go_router (navigation par adresses) | Séance 6 |
| Réseau | Dio + intercepteur d'authentification | Séance 7 |
| Sécurité du jeton | flutter_secure_storage | Séance 7 |

Contraintes du contexte à garder en tête : connexion mobile instable et coûteuse,
écrans petits, appareils à mémoire limitée, usage en français.

## 2. Organisation du dépôt (monorepo)

```
campusflow/                      ← racine du dépôt Git (créé au TP01)
├── AGENTS.md                    ← règles de l'agent
├── README.md                    ← comment lancer chaque partie
├── docs/
│   ├── ARCHITECTURE.md          ← ce document
│   ├── seance1/                 ← fiche comparative, autopsie, décision
│   ├── seance2/                 ← persona, parcours, wireframes/, design-system
│   └── captures/                ← captures d'écran (flutter doctor, émulateur…)
├── campusflow_models/           ← package Dart pur (séance 3)
├── campusflow_app/              ← application Flutter (séances 4 à 7)
└── server/                      ← json-server (séance 7)
```

L'application dépend du package de modèles par chemin :

```yaml
# campusflow_app/pubspec.yaml
dependencies:
  campusflow_models:
    path: ../campusflow_models
```

## 3. Design system v1 (séance 2 → thème Flutter en séance 4)

### Couleurs (contrastes vérifiés, seuil WCAG AA texte = 4,5:1)

| Rôle | Hex | Texte posé dessus | Contraste |
|---|---|---|---|
| primary | `#0B6E4F` (vert) | onPrimary `#FFFFFF` | 6,25:1 ✅ |
| secondary | `#F2A541` (ambre) | onSecondary `#1C1B1F` | 8,35:1 ✅ |
| surface | `#FAFAF7` | onSurface `#1C1B1F` | 16,38:1 ✅ |
| surface | `#FAFAF7` | texte secondaire `#4A4F4C` | 7,99:1 ✅ |
| primaryContainer | `#D8EFE5` | onPrimaryContainer `#1C1B1F` | 14,19:1 ✅ |
| error | `#B3261E` | onError `#FFFFFF` | 6,54:1 ✅ |
| surface | `#FAFAF7` | texte « en retard » `#B3261E` | 6,25:1 ✅ |

Règle : le **blanc n'est jamais posé sur l'ambre** (contraste insuffisant).

### Typographie
Police système Material (Roboto sur Android). Échelle :

| Style | Taille / graisse | Usage |
|---|---|---|
| headlineSmall | 24 / w600 | Titres d'écran |
| titleMedium | 16 / w600 | Titre d'une tâche |
| bodyMedium | 14 / w400 | Texte courant |
| labelLarge | 14 / w600 | Boutons |
| bodySmall | 12 / w400 | Dates, métadonnées |

### Composants
1. **Bouton principal** : `FilledButton`, couleur primary, hauteur min 48 dp,
   coins 12 dp.
2. **Carte de tâche** : `Card` ou `ListTile` ; titre (titleMedium), cours et date
   (bodySmall), case à cocher à gauche, date en rouge (error) si en retard.
3. **Champ de saisie** : `TextFormField` avec `OutlineInputBorder`, coins 12 dp,
   libellé toujours visible, message d'erreur sous le champ.

Cibles tactiles ≥ 48 × 48 dp. Espacements : multiples de 8 (8, 16, 24).

### Tailles de fenêtre visées
- **Compacte** < 600 dp : téléphone (cible principale), 360 × 800 dp de référence.
- **Moyenne** 600–839 dp : petite tablette, mise en page téléphone élargie.
- **Étendue** ≥ 840 dp : tablette, **liste + détail côte à côte**.

## 4. Modèles de données (package `campusflow_models`)

Tous immuables : champs `final`, constructeur `const`, `copyWith`, `fromJson`,
`toJson` (utile au POST de la séance 7), `==`/`hashCode` sur l'`id`.
Les `id` sont des **String** (`fromJson` accepte un nombre et le convertit avec
`toString()`, car json-server peut générer des id numériques).

### Task
| Champ | Type | JSON | Remarque |
|---|---|---|---|
| id | String | `id` | obligatoire |
| title | String | `title` | obligatoire, non vide |
| description | String? | `description` | |
| dueDate | DateTime | `dueDate` | ISO 8601 |
| done | bool | `done` | défaut `false` |
| courseId | String? | `courseId` | référence `Course.id` |

Méthode utilitaire : `bool isOverdue(DateTime now)` → `!done && dueDate.isBefore(now)`.

### Course
| Champ | Type | JSON |
|---|---|---|
| id | String | `id` |
| name | String | `name` |
| teacher | String | `teacher` |
| room | String? | `room` |

### User
| Champ | Type | JSON |
|---|---|---|
| id | String | `id` |
| name | String | `name` |
| email | String | `email` |
| program | String | `program` (filière, ex. « Master 1 MSI ») |

Le mot de passe n'apparaît **jamais** dans le modèle `User`.

### Erreurs
`fromJson` lève une `FormatException` (message en français) si un champ
obligatoire manque ou a un mauvais type. C'est l'« erreur attendue » testée.

### Dépôt simulé (séance 3)
`MockTaskRepository` dans le package :
- `Future<List<Task>> fetchTasks()` : attend `Future.delayed(300 ms)`, puis
  construit les tâches à partir d'une liste de `Map` JSON en dur via `fromJson`.
- paramètre `shouldFail` (bool) : si vrai, lève une `Exception` → permet de
  pratiquer `try / catch`.
- un `bin/campusflow_models.dart` qui appelle le dépôt avec `async/await`,
  affiche les tâches, puis provoque l'erreur et l'attrape.

## 5. Application Flutter — structure cible (état final séance 7)

```
campusflow_app/lib/
├── main.dart                       ← runApp(ProviderScope(child: CampusFlowApp()))
├── app.dart                        ← MaterialApp.router + thème
├── core/
│   ├── theme/app_theme.dart        ← SEUL endroit avec des couleurs
│   ├── config/api_config.dart      ← baseUrl = http://10.0.2.2:3000
│   ├── network/dio_client.dart     ← création du Dio (provider dioProvider)
│   ├── network/auth_interceptor.dart
│   └── storage/token_storage.dart  ← wrapper flutter_secure_storage
├── router/app_router.dart          ← GoRouter + ShellRoute + redirect auth
├── data/
│   ├── task_repository.dart        ← contrat abstrait
│   ├── api_task_repository.dart    ← implémentation Dio
│   ├── fake_task_repository.dart   ← implémentation en mémoire (tests)
│   └── auth_repository.dart        ← login / logout
├── features/
│   ├── tasks/
│   │   ├── providers/taches_notifier.dart   ← TachesNotifier (S6) → AsyncNotifier (S7)
│   │   ├── providers/filtres.dart           ← filtre courant + liste filtrée
│   │   ├── echeances_screen.dart            ← liste + LayoutBuilder 840 dp
│   │   ├── task_detail_screen.dart
│   │   ├── task_form_screen.dart
│   │   └── widgets/task_tile.dart
│   ├── courses/cours_screen.dart
│   ├── profile/profil_screen.dart
│   └── auth/login_screen.dart, auth_notifier.dart
└── shell/app_shell.dart            ← Scaffold + NavigationBar (ShellRoute)
```

Évolution par séance :
- **S4** : `main.dart`, `app.dart`, `core/theme/`, écran de titre.
- **S5** : écrans dans `features/`, données locales en dur (liste de `Task`),
  navigation `Navigator.push` provisoire.
- **S6** : `router/`, `shell/`, providers ; suppression du `Navigator.push`.
- **S7** : `core/network`, `core/storage`, `data/`, `AsyncNotifier`, auth.

## 6. Navigation (séance 6)

| Adresse | Écran | Dans le ShellRoute (NavigationBar) |
|---|---|---|
| `/login` | LoginScreen | non |
| `/taches` | EcheancesScreen | oui (onglet 1 « Échéances ») |
| `/taches/nouvelle` | TaskFormScreen | non (plein écran) |
| `/taches/:id` | TaskDetailScreen (lit `state.pathParameters['id']`) | non |
| `/cours` | CoursScreen | oui (onglet 2) |
| `/profil` | ProfilScreen | oui (onglet 3) |

Attention : déclarer `/taches/nouvelle` **avant** `/taches/:id` (sinon
« nouvelle » est pris pour un id). Écran d'accueil : `/taches`.
Id inconnu dans `/taches/:id` → message « Tâche introuvable », pas de crash.

Avant la séance 7, `/login` affiche un bouton « Entrer » qui fait `context.go('/taches')`.

## 7. État (séance 6, puis séance 7)

### Séance 6 (synchrone)
```dart
final tachesProvider = NotifierProvider<TachesNotifier, List<Task>>(TachesNotifier.new);

class TachesNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => donneesInitiales;           // liste en dur
  void ajouter(Task t) => state = [...state, t];
  void basculer(String id) => state = [
    for (final t in state) t.id == id ? t.copyWith(done: !t.done) : t,
  ];
}
```

### Filtres (fournisseur dérivé)
```dart
enum FiltreTaches { aFaire, faites, enRetard }
final filtreProvider = NotifierProvider<FiltreNotifier, FiltreTaches>(FiltreNotifier.new);
final tachesFiltreesProvider = Provider<List<Task>>((ref) { ... ref.watch(tachesProvider) ... });
```
- à faire : `!done` ; faites : `done` ; en retard : `isOverdue(DateTime.now())`.
- UI : `SegmentedButton<FiltreTaches>` en haut de l'écran Échéances.

### Séance 7 (asynchrone)
`TachesNotifier extends AsyncNotifier<List<Task>>` :
- `build()` → `ref.read(taskRepositoryProvider).fetchAll()` ;
- `ajouter`, `basculer`, `supprimer` appellent le repository puis mettent à jour
  `state` avec une **nouvelle** liste (`AsyncData([...])`) ;
- en cas d'erreur d'une action : `SnackBar` d'erreur, l'état précédent est conservé ;
- l'écran gère les 3 états avec `.when(loading:, error:, data:)` ; l'erreur
  affiche un bouton **Réessayer** → `ref.invalidate(tachesProvider)`.
- `tachesFiltreesProvider` devient `Provider<AsyncValue<List<Task>>>` (ou dérive
  via `.whenData`).

## 8. API (séance 7)

### Contrat REST (json-server)
| Méthode | Route | Usage |
|---|---|---|
| POST | `/login` | `{email, password}` → `200 {token, user}` ou `401` |
| GET | `/taches` | liste |
| GET | `/taches/:id` | détail |
| POST | `/taches` | création (corps = `toJson` sans `id`) |
| PATCH | `/taches/:id` | `{ "done": true }` |
| DELETE | `/taches/:id` | suppression |
| GET | `/cours`, `/utilisateurs/:id` | lecture |

Toutes les routes sauf `/login` exigent `Authorization: Bearer <jeton>` (à partir
du TP27), sinon **401**.

### Serveur
- Version **épinglée** : `json-server@0.17.4` (la v1 a changé de fonctionnement et
  ne permet plus simplement les routes personnalisées).
- TP24 : `npx json-server@0.17.4 --watch db.json --host 0.0.0.0 --port 3000`
  (pas encore d'authentification ; `/taches` s'ouvre dans le navigateur).
- TP27 : `node server.js`, qui ajoute `/login` et le contrôle du jeton :

```js
// server/server.js
const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('db.json');
const jetonsValides = new Set(); // en mémoire : un redémarrage invalide les jetons

server.use(jsonServer.defaults());
server.use(jsonServer.bodyParser);

server.post('/login', (req, res) => {
  const { email, password } = req.body || {};
  const user = router.db.get('utilisateurs').find({ email, password }).value();
  if (!user) return res.status(401).json({ message: 'Identifiants invalides' });
  const { password: _, ...publicUser } = user;
  const token = `fake-jwt-${user.id}-${Date.now()}`;
  jetonsValides.add(token);
  res.json({ token, user: publicUser });
});

server.use((req, res, next) => {
  const auth = req.headers.authorization || '';
  const token = auth.replace(/^Bearer /, '');
  if (!jetonsValides.has(token)) {
    return res.status(401).json({ message: 'Non authentifié' });
  }
  next();
});

server.use(router);
server.listen(3000, '0.0.0.0', () => console.log('API sur http://localhost:3000'));
```

### db.json (forme)
Ressources : `taches` (≥ 6, dont au moins 2 en retard et 2 faites), `cours` (≥ 3),
`utilisateurs` (≥ 1, avec `password` en clair — **simulation uniquement**).
Compte de démonstration : `etudiant@campusflow.bf` / `campus2026`.

### Côté application
- `api_config.dart` : `const baseUrl = 'http://10.0.2.2:3000';`
- Android : `INTERNET` déjà présent en debug ; ajouter
  `android:usesCleartextTraffic="true"` dans `AndroidManifest.xml` (API en http
  local uniquement).
- `AuthInterceptor` :
  - `onRequest` : lit le jeton dans `TokenStorage`, ajoute `Authorization: Bearer …` ;
  - `onError` : si `statusCode == 401` et route ≠ `/login` → efface le jeton,
    passe l'état d'auth à « déconnecté » → le `redirect` de GoRouter renvoie vers
    `/login`.
- Auth et routeur : `authProvider` (`AsyncNotifier<bool>` ou état équivalent) ;
  le `routerProvider` crée un `ValueNotifier` alimenté par `ref.listen(authProvider, …)`
  et le passe en `refreshListenable` ; `redirect` : non connecté → `/login`,
  connecté sur `/login` → `/taches`.
- Au démarrage : présence d'un jeton dans le stockage sécurisé → connecté.
- Bouton « Se déconnecter » dans `/profil`.

## 9. Tests
- Package : 3 tests minimum (`copyWith`, `fromJson`, erreur attendue `FormatException`).
- Application : à partir de S7, test du `TachesNotifier` avec
  `ProviderContainer(overrides: [taskRepositoryProvider.overrideWithValue(FakeTaskRepository())])`.
- Remplacer le test « counter » généré par `flutter create` par un test qui
  vérifie l'affichage de l'écran de titre (S4), à adapter ensuite.

## 10. Stratégie Git
Un commit par TP, message `TPxx - description`. 27 TP → au moins 27 commits.
Le dépôt est créé au TP01 à la racine `campusflow/`. `.gitignore` racine :
`.dart_tool/`, `build/`, `.idea/`, `*.iml`, `node_modules/`, `.flutter-plugins*`,
`pubspec.lock` **conservé** pour l'application.
