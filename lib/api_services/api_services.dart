import 'dart:convert';

import 'package:http/http.dart' as http;

import '../users/user_model.dart';
import '../products/product_model.dart';

class ApiServices {
  static const Duration _timeout = Duration(seconds: 20);
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<Product>> getProducts() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products?limit=100'))
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
        .get(Uri.parse('$_baseUrl/users?limit=100'))
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

  // Authentic login with a pre-existing DummyJSON test user.
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username.trim(),
            'password': password,
            'expiresInMins': 30,
          }),
        )
        .timeout(_timeout);
    final data = _decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(_message(data, 'Incorrect username or password.'));
    }
    if ((data['accessToken'] ?? '').toString().isEmpty) {
      throw Exception('Login failed: access token was not returned.');
    }
    return data;
  }

  // This is a SIMULATED create-user API. DummyJSON does not persist users.
  // Do not use a personal or reused password with this demo API.
  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final names = fullName.trim().split(RegExp(r'\s+'));
    final firstName = names.first;
    final lastName = names.skip(1).join(' ');
    final response = await http
        .post(
          Uri.parse('$_baseUrl/users/add'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'firstName': firstName,
            'lastName': lastName,
            'username': username.trim(),
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(_timeout);
    final data = _decode(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(_message(data, 'Could not submit registration request.'));
    }
    if (data['id'] == null) {
      throw Exception('Registration API did not return a user ID.');
    }
    return data;
  }

  Map<String, dynamic> _decode(String body) {
    final value = jsonDecode(body);
    if (value is Map<String, dynamic>) return value;
    throw Exception('Unexpected API response format.');
  }

  String _message(Map<String, dynamic> data, String fallback) {
    final message = data['message']?.toString();
    return message == null || message.isEmpty ? fallback : message;
  }
}
