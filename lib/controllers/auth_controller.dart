import 'package:get/get.dart';

import '../services/api_services.dart';

class AuthController extends GetxController {
  final ApiServices _api = ApiServices();
  final isLoading = false.obs;
  final email = ''.obs;
  final displayName = ''.obs;

  // Login calls the real DummyJSON authentication endpoint.
  // Returns null on success, or an error message on failure.
  Future<String?> login(String username, String password) async {
    isLoading.value = true;
    try {
      final user = await _api.login(
        username: username,
        password: password,
      );
      email.value = (user['email'] ?? '').toString();
      final first = (user['firstName'] ?? '').toString();
      final last = (user['lastName'] ?? '').toString();
      displayName.value = ('$first $last').trim().isNotEmpty
          ? ('$first $last').trim()
          : username;
      return null;
    } catch (error) {
      return error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // Quick login still makes an actual HTTP API request.
  Future<String?> demoLogin() => login('emilys', 'emilyspass');

  // Registration is a simulated POST, not a persisted account.
  Future<String?> register(
    String fullName,
    String username,
    String userEmail,
    String password,
  ) async {
    isLoading.value = true;
    try {
      await _api.registerUser(
        fullName: fullName,
        username: username,
        email: userEmail,
        password: password,
      );
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
  }
}
