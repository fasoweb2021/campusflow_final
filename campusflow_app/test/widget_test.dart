import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:campusflow_app/app.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('Affiche le logo, CampusFlow, la date du jour et Commencer',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusFlowApp());

    expect(find.bySemanticsLabel('Logo CampusFlow'), findsOneWidget);
    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
    expect(
      find.text('Vos cours, vos échéances, sans stress'),
      findsOneWidget,
    );

    final expectedDate =
        DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now());
    expect(find.text(expectedDate), findsOneWidget);
  });
}
