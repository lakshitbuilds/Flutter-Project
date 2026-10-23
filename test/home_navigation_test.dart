import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutterproject/home_screen.dart';
import 'package:flutterproject/products/products_controller.dart';
import 'package:flutterproject/users/users_controller.dart';

class TestProductsController extends ProductsController {
  @override
  Future<void> loadData() async {}
}

class TestUsersController extends UsersController {
  @override
  Future<void> loadData() async {}
}

void main() {
  tearDown(() => Get.reset());
  testWidgets('Bottom navigation switches sections and shows login snackbar', (
    tester,
  ) async {
    Get.put<ProductsController>(TestProductsController());
    Get.put<UsersController>(TestUsersController());
    await tester.pumpWidget(
      const GetMaterialApp(home: HomeScreen(name: 'Emily')),
    );
    await tester.pump();
    expect(
      find.text('Login successful. Welcome to Campus Catalog!'),
      findsOneWidget,
    );
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('Products'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      1,
    );
    expect(find.text('No Data Found'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('Users'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      2,
    );
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('Dashboard'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hello, Emily'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
