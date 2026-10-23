import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_services/api_services.dart';

class RegisterController extends GetxController {
  final name = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final isLoading = false.obs;
  Future<void> register() async {
    if (isLoading.value) return;
    if (name.text.trim().isEmpty ||
        username.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        password.text.isEmpty) {
      Get.snackbar('Register', 'Please fill all details');
      return;
    }
    if (!GetUtils.isEmail(email.text.trim())) {
      Get.snackbar('Register', 'Please enter a valid email');
      return;
    }
    isLoading.value = true;
    try {
      await ApiServices().registerUser(
        fullName: name.text,
        username: username.text,
        email: email.text,
        password: password.text,
      );
      Get.back();
      Get.snackbar(
        'Registration successful',
        'Demo accounts are not saved. Login with emilys / emilyspass.',
      );
    } catch (e) {
      Get.snackbar('Register failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
