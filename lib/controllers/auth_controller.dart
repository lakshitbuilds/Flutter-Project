import 'package:get/get.dart';

import '../services/api_services.dart';

class AuthController extends GetxController {
  final ApiServices _api = ApiServices();
  final isLoading = false.obs;
  final email = ''.obs;
  final displayName = ''.obs;
  final isDemo = false.obs;

  bool get firebaseConfigured => _api.firebaseConfigured;

  Future<String?> login(String userEmail, String password) async {
    return _authenticate(
      emailAddress: userEmail,
      password: password,
      register: false,
    );
  }

  Future<String?> register(String name, String userEmail, String password) {
    return _authenticate(
      emailAddress: userEmail,
      password: password,
      register: true,
      name: name,
    );
  }

  // Return null when successful, or a user-friendly error message.
  Future<String?> _authenticate({
    required String emailAddress,
    required String password,
    required bool register,
    String? name,
  }) async {
    isLoading.value = true;
    try {
      final result = await _api.firebaseAuth(
        email: emailAddress,
        password: password,
        register: register,
      );
      email.value = (result['email'] ?? emailAddress).toString();
      displayName.value = name?.trim().isNotEmpty == true
          ? name!.trim()
          : email.value.split('@').first;
      isDemo.value = false;
      return null;
    } catch (error) {
      return error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> demoLogin() async {
    isLoading.value = true;
    try {
      final user = await _api.demoLogin();
      email.value = (user['email'] ?? '').toString();
      displayName.value = (user['firstName'] ?? 'Demo Student').toString();
      isDemo.value = true;
      return null;
    } catch (error) {
      return error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    email.value = '';
    displayName.value = '';
    isDemo.value = false;
  }
}
