import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/catalog_controller.dart';
import 'screens/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController(), permanent: true);
  Get.put(CatalogController(), permanent: true);
  runApp(const CampusCatalogApp());
}

class CampusCatalogApp extends StatelessWidget {
  const CampusCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Catalog',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3446A5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF172554),
          elevation: 0,
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
