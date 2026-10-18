import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import '../models/product_model.dart';

class ApiServices {
  static const String firebaseApiKey =
      String.fromEnvironment('FIREBASE_API_KEY');

  static const Duration _timeout = Duration(seconds: 20);

  bool get firebaseConfigured => firebaseApiKey.isNotEmpty;

  Future<List<Product>> getProducts() async {
    final response = await http
        .get(Uri.parse('https://dummyjson.com/products?limit=100'))
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('Products API returned ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['products'] as List<dynamic>? ?? [];
    return items
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<AppUser>> getUsers() async {
    final response = await http
        .get(Uri.parse('https://dummyjson.com/users?limit=100'))
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('Users API returned ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['users'] as List<dynamic>? ?? [];
    return items
        .map((item) => AppUser.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> firebaseAuth({
    required String email,
    required String password,
    required bool register,
  }) async {
    if (!firebaseConfigured) {
      throw Exception(
        'Firebase is not configured. See README for the FIREBASE_API_KEY setup.',
      );
    }
    final action = register ? 'signUp' : 'signInWithPassword';
    final uri = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:$action',
      {'key': firebaseApiKey},
    );

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
            'returnSecureToken': true,
          }),
        )
        .timeout(_timeout);

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      final error = (data['error'] as Map<String, dynamic>?)?['message']
              ?.toString() ??
          'Authentication failed';
      throw Exception(_firebaseError(error));
    }
    if ((data['idToken'] ?? '').toString().isEmpty) {
      throw Exception('Authentication server did not return a session.');
    }
    return data;
  }

  // Demo authentication uses DummyJSON's real test-login endpoint.
  Future<Map<String, dynamic>> demoLogin() async {
    final response = await http
        .post(
          Uri.parse('https://dummyjson.com/user/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': 'emilys',
            'password': 'emilyspass',
          }),
        )
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('Demo login failed. Please retry.');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if ((data['accessToken'] ?? '').toString().isEmpty) {
      throw Exception('Demo login did not return an access token.');
    }
    return data;
  }

  String _firebaseError(String error) {
    if (error.startsWith('EMAIL_EXISTS')) {
      return 'An account with this email already exists.';
    }
    if (error.startsWith('EMAIL_NOT_FOUND') ||
        error.startsWith('INVALID_PASSWORD') ||
        error.startsWith('INVALID_LOGIN_CREDENTIALS')) {
      return 'Incorrect email or password.';
    }
    if (error.startsWith('WEAK_PASSWORD')) {
      return 'Password is too weak. Use at least 6 characters.';
    }
    if (error.startsWith('INVALID_EMAIL')) {
      return 'Please enter a valid email address.';
    }
    if (error.startsWith('OPERATION_NOT_ALLOWED')) {
      return 'Enable Email/Password in Firebase Authentication.';
    }
    if (error.startsWith('TOO_MANY_ATTEMPTS_TRY_LATER')) {
      return 'Too many attempts. Please try again later.';
    }
    return error.replaceAll('_', ' ');
  }
}
