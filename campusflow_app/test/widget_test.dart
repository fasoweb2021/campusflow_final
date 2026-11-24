import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow_app/app.dart';

void main() {
  testWidgets('Affiche CampusFlow et Commencer sur l\'écran de titre',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusFlowApp());

    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
    expect(
      find.text('Vos cours, vos échéances, sans stress'),
      findsOneWidget,
    );
  });
}
