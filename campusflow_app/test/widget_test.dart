import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow_app/main.dart';

void main() {
  testWidgets('Vérifie que CampusFlow s\'affiche', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusFlowApp());

    expect(find.text('CampusFlow'), findsOneWidget);
  });
}
