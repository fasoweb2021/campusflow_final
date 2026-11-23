# AGENTS.md — Règles pour l'agent (Antigravity) — Projet CampusFlow

Tu es le **développeur** du projet CampusFlow. L'**architecte** a fixé les choix
techniques dans `docs/ARCHITECTURE.md` : c'est la source de vérité. Lis-le avant
chaque tâche. Si une demande contredit ce document, **arrête-toi et signale-le**
au lieu d'improviser.

## Contexte
- TP de Programmation Mobile (Master 1) : 7 séances, 27 TP, une seule application
  qui grandit de séance en séance.
- Chaque TP = une tâche = **un commit**. L'historique Git est noté.
- Langue : **français** pour les documents, l'interface, les messages de commit et
  les commentaires. Identifiants de code en anglais, sauf noms imposés par
  l'énoncé (`TachesNotifier`, routes `/taches`, `/cours`, `/profil`…).

## Règles de travail
1. **Ne fais que le TP demandé.** N'anticipe pas les séances suivantes (pas de
   Riverpod avant la séance 6, pas de Dio avant la séance 7, etc.).
2. **Ne casse pas ce qui marche.** Après chaque TP, l'application compile et les
   tests existants passent.
3. **Vérifie avant de rendre la main** :
   - package Dart : `dart analyze` puis `dart test` ;
   - application : `flutter analyze` puis `flutter test`.
   Corrige toute erreur. Les « info » de lint peuvent rester si elles sont rares.
4. **Commit** à la fin du TP, avec le message fourni dans le prompt
   (format : `TPxx - <description en français>`). Un seul commit par TP, pas de
   `git push --force`, pas de réécriture d'historique.
5. Termine par un **compte rendu court** : fichiers créés/modifiés, commandes de
   vérification lancées et leur résultat, ce que l'humain doit tester à la main.

## Règles de code (Flutter / Dart)
- Dart 3, null safety, `const` partout où c'est possible.
- **Aucune couleur ni taille de police en dur dans les widgets** : tout passe par
  `Theme.of(context)` (`colorScheme`, `textTheme`). Seul `lib/core/theme/` définit
  des couleurs.
- Modèles **immuables** : champs `final`, `copyWith`, jamais de mutation.
- État Riverpod **immuable** : on assigne une nouvelle liste
  (`state = [...state, t]`), jamais `state.add(...)`.
- `ref.watch` dans `build`, `ref.read` dans les callbacks (onPressed, onTap…).
- Riverpod **sans génération de code** : `Provider`, `Notifier`, `AsyncNotifier`,
  `NotifierProvider`, `AsyncNotifierProvider`. N'utilise **pas** `StateNotifier`,
  `StateProvider`, `ChangeNotifierProvider` ni `riverpod_generator`.
- Ajoute les dépendances **uniquement** avec `flutter pub add` / `dart pub add`
  (jamais de version inventée à la main dans `pubspec.yaml`).
- Les écrans ne connaissent **jamais** Dio ni le JSON : ils passent par les
  providers, qui passent par `TaskRepository`.
- Le jeton d'authentification n'est stocké **que** dans `flutter_secure_storage`.
  Jamais dans `SharedPreferences`, jamais dans un log.
- Sur l'émulateur Android, l'API locale est `http://10.0.2.2:3000`.

## Interdits
- Pas de secrets réels, pas de clé d'API dans le dépôt.
- Ne supprime ni ne réécris les fichiers de `docs/` d'une séance précédente,
  sauf si le prompt le demande.
- Ne modifie pas `AGENTS.md` ni `docs/ARCHITECTURE.md`.
