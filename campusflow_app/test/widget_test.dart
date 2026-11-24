import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow_app/app.dart';
import 'package:campusflow_app/features/tasks/data/sample_tasks.dart';
import 'package:campusflow_app/features/tasks/echeances_screen.dart';
import 'package:campusflow_app/features/tasks/task_detail_screen.dart';
import 'package:campusflow_app/features/tasks/task_form_screen.dart';
import 'package:campusflow_app/features/tasks/widgets/task_detail_view.dart';
import 'package:campusflow_app/features/tasks/widgets/task_tile.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('Écran de titre affiche les éléments et ouvre Échéances',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: CampusFlowApp(),
      ),
    );

    expect(find.bySemanticsLabel('Logo CampusFlow'), findsOneWidget);
    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
    expect(
      find.text('Vos cours, vos échéances, sans stress'),
      findsOneWidget,
    );

    // Clic sur "Commencer"
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    // Vérifie l'arrivée sur l'écran Échéances
    expect(find.text('Échéances'), findsWidgets);
    expect(find.byType(TaskTile), findsNWidgets(8));
  });

  testWidgets(
      'Écran Échéances affiche 8 tuiles et cocher une tâche change son état',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: EcheancesScreen(),
        ),
      ),
    );

    // Vérifie la présence des 8 tuiles
    expect(find.byType(TaskTile), findsNWidgets(8));

    // Récupère l'état initial de la première case à cocher
    final firstCheckbox = tester.widget<Checkbox>(
      find.descendant(
        of: find.byType(TaskTile).first,
        matching: find.byType(Checkbox),
      ),
    );
    final initialValue = firstCheckbox.value!;

    // Clic sur la première case à cocher pour basculer son état
    await tester.tap(
      find.descendant(
        of: find.byType(TaskTile).first,
        matching: find.byType(Checkbox),
      ),
    );
    await tester.pump();

    // Vérifie que l'état a bien basculé
    final updatedCheckbox = tester.widget<Checkbox>(
      find.descendant(
        of: find.byType(TaskTile).first,
        matching: find.byType(Checkbox),
      ),
    );
    expect(updatedCheckbox.value, equals(!initialValue));
  });

  testWidgets(
      'Ouvrir le détail d\'une tâche à faire, appuyer sur Marquer comme fait et vérifier qu\'au retour elle est cochée',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: EcheancesScreen(),
        ),
      ),
    );

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

    // Vérifie le retour sur Échéances et que la tâche est maintenant cochée
    expect(find.text('Échéances'), findsWidgets);
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
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr', 'FR')],
          locale: const Locale('fr', 'FR'),
          home: TaskFormScreen(courses: sampleCourses),
        ),
      ),
    );

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
      const ProviderScope(
        child: CampusFlowApp(),
      ),
    );

    // Naviguer vers l'écran Échéances
    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskTile), findsNWidgets(8));

    // Clic sur le FAB (+) pour ouvrir le formulaire
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Nouvelle tâche'), findsOneWidget);

    // Saisie du Titre
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Titre'),
      'Nouveau devoir TP18',
    );

    // Sélection du Cours
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Programmation Mobile').last);
    await tester.pumpAndSettle();

    // Appui sur Enregistrer
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    // Vérifie le retour sur la liste avec 9 tuiles et le SnackBar
    expect(find.text('Échéances'), findsWidgets);
    expect(find.byType(TaskTile), findsNWidgets(9));
    expect(find.text('Nouveau devoir TP18'), findsOneWidget);
    expect(find.text('Tâche ajoutée'), findsOneWidget);
  });

  testWidgets(
      'Mise en page tablette (1280x800) : liste et détail côte à côte',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: EcheancesScreen(),
        ),
      ),
    );

    // Vérifie que les tuiles sont présentes
    expect(find.byType(TaskTile), findsWidgets);

    // Au départ, aucune tâche n'est sélectionnée : le panneau droit affiche "Sélectionnez une tâche"
    expect(find.text('Sélectionnez une tâche'), findsOneWidget);

    // Tap sur une tâche dans la colonne de gauche (ex: "Devoir maison : Arbres B+ et indexation")
    await tester.tap(find.text('Devoir maison : Arbres B+ et indexation'));
    await tester.pump();

    // Le message initial disparaît et le composant TaskDetailView s'affiche dans le panneau droit
    expect(find.text('Sélectionnez une tâche'), findsNothing);
    expect(find.byType(TaskDetailView), findsOneWidget);
    expect(find.text('Marquer comme fait'), findsOneWidget);

    // Vérifie que la tuile correspondante est marquée sélectionnée
    final selectedTile = tester.widget<TaskTile>(
      find.ancestor(
        of: find.text('Devoir maison : Arbres B+ et indexation'),
        matching: find.byType(TaskTile),
      ),
    );
    expect(selectedTile.isSelected, isTrue);

    // Tap sur "Marquer comme fait" dans le panneau de droite
    await tester.tap(find.text('Marquer comme fait'));
    await tester.pump();

    // Vérifie que la tâche est marquée comme faite
    final updatedTile = tester.widget<TaskTile>(
      find.ancestor(
        of: find.text('Devoir maison : Arbres B+ et indexation'),
        matching: find.byType(TaskTile),
      ),
    );
    expect(updatedTile.task.done, isTrue);
  });
}
