import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_services/api_services.dart';
import '../home_screen.dart';

class LoginController extends GetxController {
  final username = TextEditingController();
  final password = TextEditingController();
  final isLoading = false.obs;
  Future<void> login() async {
    if (isLoading.value) return;
    if (username.text.trim().isEmpty || password.text.isEmpty) {
      Get.snackbar('Login', 'Please fill all details');
      return;
    }

    isLoading.value = true;
    try {
      final user = await ApiServices().login(
        username: username.text,
        password: password.text,
      );
      Get.offAll(() => HomeScreen(name: user['firstName'].toString()));
    } catch (e) {
      Get.snackbar('Login failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }
}
