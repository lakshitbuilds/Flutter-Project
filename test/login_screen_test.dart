import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutterproject/main.dart';

void main() {
  tearDown(() => Get.reset());
  testWidgets('Login opens the registration form', (tester) async {
    await tester.pumpWidget(const CampusCatalogApp());
    expect(find.byType(TextField), findsNWidgets(2));
    await tester.tap(find.widgetWithText(TextButton, 'Register'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNWidgets(4));
    expect(
      find.text(
        'Demo registration only. Accounts are not saved. Use a test password.',
      ),
      findsOneWidget,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
