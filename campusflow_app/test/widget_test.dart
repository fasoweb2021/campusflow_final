import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow_app/app.dart';
import 'package:campusflow_app/features/tasks/echeances_screen.dart';
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

    await tester.pumpWidget(const CampusFlowApp());

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
      const MaterialApp(
        home: EcheancesScreen(),
      ),
    );

    // Vérifie la présence des 8 tuiles
    expect(find.byType(TaskTile), findsNWidgets(8));

    // La première tâche (t1) est initialement non cochée (done == false)
    final firstCheckbox = tester.widget<Checkbox>(
      find.descendant(
        of: find.byType(TaskTile).first,
        matching: find.byType(Checkbox),
      ),
    );
    expect(firstCheckbox.value, isFalse);

    // Clic sur la première case à cocher pour la cocher
    await tester.tap(
      find.descendant(
        of: find.byType(TaskTile).first,
        matching: find.byType(Checkbox),
      ),
    );
    await tester.pump();

    // Vérifie que l'état a basculé à true
    final updatedCheckbox = tester.widget<Checkbox>(
      find.descendant(
        of: find.byType(TaskTile).first,
        matching: find.byType(Checkbox),
      ),
    );
    expect(updatedCheckbox.value, isTrue);
  });
}
