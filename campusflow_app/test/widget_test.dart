import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow_app/app.dart';
import 'package:campusflow_app/data/fake_task_repository.dart';
import 'package:campusflow_app/data/task_repository.dart';
import 'package:campusflow_app/features/courses/cours_screen.dart';
import 'package:campusflow_app/features/profile/profil_screen.dart';
import 'package:campusflow_app/features/tasks/providers/filtres.dart';
import 'package:campusflow_app/features/tasks/task_detail_screen.dart';
import 'package:campusflow_app/features/tasks/task_form_screen.dart';
import 'package:campusflow_app/features/tasks/widgets/task_detail_view.dart';
import 'package:campusflow_app/features/tasks/widgets/task_tile.dart';
import 'package:campusflow_app/router/app_router.dart';

import 'failing_task_repository.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  Widget createTestApp({
    String initialLocation = '/taches',
    TaskRepository? repository,
  }) {
    final repo = repository ?? FakeTaskRepository(delay: Duration.zero);
    return ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(repo),
      ],
      child: CampusFlowApp(
        routerConfig: createRouter(
          initialLocation: initialLocation,
          navigatorKey: GlobalKey<NavigatorState>(),
        ),
      ),
    );
  }

  testWidgets('Écran /login s\'affiche et "Entrer" mène à Échéances',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/login'),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Logo CampusFlow'), findsOneWidget);
    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.text('Entrer'), findsOneWidget);
    expect(
      find.text('Vos cours, vos échéances, sans stress'),
      findsOneWidget,
    );

    // Clic sur "Entrer" -> mène à /taches
    await tester.tap(find.text('Entrer'));
    await tester.pumpAndSettle();

    // Vérifie l'arrivée sur l'écran Échéances avec le SegmentedButton et les tâches à faire
    expect(find.text('Échéances'), findsWidgets);
    expect(find.byType(SegmentedButton<FiltreTaches>), findsOneWidget);
    expect(find.byType(TaskTile), findsNWidgets(6));
  });

  testWidgets('/taches/inconnu affiche Tâche introuvable avec bouton de retour',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches/inconnu'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tâche introuvable'), findsOneWidget);
    expect(find.text('Retour aux échéances'), findsOneWidget);

    // Clic sur le bouton de retour -> retour sur /taches
    await tester.tap(find.text('Retour aux échéances'));
    await tester.pumpAndSettle();

    expect(find.text('Échéances'), findsWidgets);
    expect(find.byType(TaskTile), findsNWidgets(6));
  });

  testWidgets(
      'Écran Échéances affiche les filtres et changer de filtre met à jour la liste',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches'),
    );
    await tester.pumpAndSettle();

    // Filtre initial "À faire (6)"
    expect(find.byType(TaskTile), findsNWidgets(6));

    // Basculer sur "Faites"
    await tester.tap(find.textContaining('Faites'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskTile), findsNWidgets(2));

    // Basculer sur "En retard"
    await tester.tap(find.textContaining('En retard'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskTile), findsNWidgets(2));
  });

  testWidgets('Cocher une tâche non faite la fait basculer dans les tâches faites',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches'),
    );
    await tester.pumpAndSettle();

    // 6 tâches à faire au départ
    expect(find.byType(TaskTile), findsNWidgets(6));

    // Clic sur la case de la première tâche à faire
    await tester.tap(
      find.descendant(
        of: find.byType(TaskTile).first,
        matching: find.byType(Checkbox),
      ),
    );
    await tester.pumpAndSettle();

    // La tâche cochée passe dans "Faites" donc la liste "À faire" n'en contient plus que 5
    expect(find.byType(TaskTile), findsNWidgets(5));

    // Aller sur "Faites" : elle compte désormais 3 tâches
    await tester.tap(find.textContaining('Faites'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskTile), findsNWidgets(3));
  });

  testWidgets(
      'Ouvrir le détail d\'une tâche à faire, appuyer sur Marquer comme fait et vérifier qu\'au retour elle est dans Faites',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches'),
    );
    await tester.pumpAndSettle();

    // Trouver une tâche non faite
    final taskTitleFinder =
        find.text('Devoir maison : Arbres B+ et indexation');
    expect(taskTitleFinder, findsOneWidget);

    // Tap sur la tâche pour ouvrir l'écran Détail
    await tester.tap(taskTitleFinder);
    await tester.pumpAndSettle();

    // Vérifie l'affichage de l'écran Détail et du bouton
    expect(find.byType(TaskDetailScreen), findsOneWidget);
    expect(find.text('Détail'), findsOneWidget);
    expect(find.text('Marquer comme fait'), findsOneWidget);

    // Clic sur "Marquer comme fait"
    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();

    // Retour sur Échéances : la tâche n'est plus dans "À faire", elle est dans "Faites"
    expect(find.text('Échéances'), findsWidgets);
    expect(find.text('Devoir maison : Arbres B+ et indexation'), findsNothing);

    // Basculer sur "Faites"
    await tester.tap(find.textContaining('Faites'));
    await tester.pumpAndSettle();

    expect(find.text('Devoir maison : Arbres B+ et indexation'), findsOneWidget);
    final taskTileFinder = find.ancestor(
      of: find.text('Devoir maison : Arbres B+ et indexation'),
      matching: find.byType(TaskTile),
    );
    final checkbox = tester.widget<Checkbox>(
      find.descendant(
        of: taskTileFinder,
        matching: find.byType(Checkbox),
      ),
    );
    expect(checkbox.value, isTrue);
  });

  testWidgets(
      'Marquer une tâche comme faite depuis /taches/:id puis revenir sur /taches -> la case est cochée',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final router = createRouter(
      initialLocation: '/taches',
      navigatorKey: GlobalKey<NavigatorState>(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
        child: CampusFlowApp(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    // Navigation vers l'échéance t1 via son URL
    router.push('/taches/t1');
    await tester.pumpAndSettle();

    expect(find.byType(TaskDetailScreen), findsOneWidget);
    expect(find.text('Devoir maison : Arbres B+ et indexation'), findsOneWidget);

    // Clic sur "Marquer comme fait"
    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();

    // L'écran revient sur /taches
    expect(find.text('Échéances'), findsWidgets);

    // Vérifie que sous l'onglet "Faites", la tâche t1 est cochée
    await tester.tap(find.textContaining('Faites'));
    await tester.pumpAndSettle();

    expect(find.text('Devoir maison : Arbres B+ et indexation'), findsOneWidget);
    final taskTileFinder = find.ancestor(
      of: find.text('Devoir maison : Arbres B+ et indexation'),
      matching: find.byType(TaskTile),
    );
    final checkbox = tester.widget<Checkbox>(
      find.descendant(
        of: taskTileFinder,
        matching: find.byType(Checkbox),
      ),
    );
    expect(checkbox.value, isTrue);
  });

  testWidgets('Formulaire affiche une erreur si le titre est vide',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches/nouvelle'),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TaskFormScreen), findsOneWidget);

    // Appui direct sur Enregistrer
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.text('Le titre est obligatoire'), findsOneWidget);
  });

  testWidgets(
      'Remplir le titre et le cours puis enregistrer ajoute une tâche à la liste',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches'),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TaskTile), findsNWidgets(6));

    // Clic sur le FAB (+) pour ouvrir le formulaire
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Nouvelle tâche'), findsOneWidget);

    // Saisie du Titre
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Titre *'),
      'Nouveau devoir TP26 AsyncNotifier',
    );

    // Sélection du Cours
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Programmation Mobile').last);
    await tester.pumpAndSettle();

    // Appui sur Enregistrer
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    // Vérifie le retour sur la liste avec 7 tuiles et le SnackBar
    expect(find.text('Échéances'), findsWidgets);
    expect(find.byType(TaskTile), findsNWidgets(7));
    expect(find.text('Nouveau devoir TP26 AsyncNotifier'), findsOneWidget);
    expect(find.text('Tâche ajoutée'), findsOneWidget);
  });

  testWidgets(
      'Mise en page tablette (1280x800) : si la tâche n\'est plus dans la liste filtrée, revient à Sélectionnez une tâche',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches'),
    );
    await tester.pumpAndSettle();

    // Vérifie la présence du NavigationRail et de SegmentedButton
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(SegmentedButton<FiltreTaches>), findsOneWidget);

    // Au départ : "Sélectionnez une tâche"
    expect(find.text('Sélectionnez une tâche'), findsOneWidget);

    // Tap sur une tâche non faite (ex: "Devoir maison : Arbres B+ et indexation")
    await tester.tap(find.text('Devoir maison : Arbres B+ et indexation'));
    await tester.pumpAndSettle();

    // Le détail s'affiche
    expect(find.text('Sélectionnez une tâche'), findsNothing);
    expect(find.byType(TaskDetailView), findsOneWidget);
    expect(find.text('Marquer comme fait'), findsOneWidget);

    // Clic sur "Marquer comme fait" -> la tâche devient faite
    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();

    // Puisqu'on est sous le filtre "À faire", la tâche n'y est plus : le panneau revient à "Sélectionnez une tâche"
    expect(find.text('Sélectionnez une tâche'), findsOneWidget);
    expect(find.byType(TaskDetailView), findsNothing);
  });

  testWidgets('Navigation ShellRoute : bascule vers Cours puis Profil',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches'),
    );
    await tester.pumpAndSettle();

    // Navigation vers Cours
    await tester.tap(find.text('Cours'));
    await tester.pumpAndSettle();

    expect(find.byType(CoursScreen), findsOneWidget);
    expect(find.text('Algorithmique Avancée'), findsOneWidget);

    // Navigation vers Profil
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilScreen), findsOneWidget);
    expect(find.text('Moussa Ouédraogo'), findsOneWidget);
    expect(find.text('Licence 3 Informatique'), findsWidgets);
  });

  testWidgets(
      'Vérifie que les libellés Échéances, Cours et Profil sont visibles en permanence dans la barre de navigation',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches'),
    );
    await tester.pumpAndSettle();

    final navBarFinder = find.byType(NavigationBar);
    expect(navBarFinder, findsOneWidget);

    final navBar = tester.widget<NavigationBar>(navBarFinder);
    expect(
      navBar.labelBehavior,
      NavigationDestinationLabelBehavior.alwaysShow,
    );

    expect(
      find.descendant(of: navBarFinder, matching: find.text('Échéances')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: navBarFinder, matching: find.text('Cours')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: navBarFinder, matching: find.text('Profil')),
      findsOneWidget,
    );
  });

  testWidgets(
      'FailingTaskRepository : l\'écran affiche le message d\'erreur et le bouton Réessayer',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(
        initialLocation: '/taches',
        repository: const FailingTaskRepository(
          errorMessage: 'Erreur réseau simulée CampusFlow',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Vérifie le message d'erreur en français et le bouton Réessayer
    expect(find.text('Erreur réseau simulée CampusFlow'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Réessayer'), findsOneWidget);
  });

  testWidgets(
      'Suppression par glissement Dismissible : dialogue de confirmation puis suppression',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestApp(initialLocation: '/taches'),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TaskTile), findsNWidgets(6));

    // Glissement vers la gauche sur la première tâche
    await tester.drag(find.byType(TaskTile).first, const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    // Boîte de dialogue de confirmation
    expect(find.text('Confirmation'), findsOneWidget);
    expect(find.text('Supprimer cette tâche ?'), findsOneWidget);

    // Clic sur Supprimer
    await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
    await tester.pumpAndSettle();

    // La tâche est supprimée (reste 5) et le SnackBar s'affiche
    expect(find.byType(TaskTile), findsNWidgets(5));
    expect(find.text('Tâche supprimée'), findsOneWidget);
  });

  testWidgets(
      'Suppression depuis l\'AppBar de TaskDetailScreen : confirmation puis suppression et retour',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final router = createRouter(
      initialLocation: '/taches',
      navigatorKey: GlobalKey<NavigatorState>(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
        child: CampusFlowApp(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    // Aller sur le détail de t1
    router.push('/taches/t1');
    await tester.pumpAndSettle();

    expect(find.byType(TaskDetailScreen), findsOneWidget);

    // Clic sur l'icône poubelle dans l'AppBar
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    // Confirmation
    expect(find.text('Confirmation'), findsOneWidget);
    expect(find.text('Supprimer cette tâche ?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
    await tester.pumpAndSettle();

    // Retour sur Échéances et SnackBar affiché
    expect(find.text('Échéances'), findsWidgets);
    expect(find.text('Tâche supprimée'), findsOneWidget);
  });
}
