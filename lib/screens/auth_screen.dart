import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();

  bool _register = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _showError(String message) {
    Get.snackbar(
      'Please try again',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFFE4E6),
      colorText: const Color(0xFF9F1239),
      margin: const EdgeInsets.all(14),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final error = _register
        ? await _auth.register(
            _name.text.trim(),
            _username.text.trim(),
            _email.text.trim(),
            _password.text,
          )
        : await _auth.login(_username.text.trim(), _password.text);
    if (!mounted) return;
    if (error != null) {
      _showError(error);
    } else if (_register) {
      // DummyJSON registration returns a user ID but never saves the user.
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration request accepted'),
          content: const Text(
            'DummyJSON returned a new user ID, but it does not save '
            'registered accounts. New details cannot be used to sign in. '
            'Use the demo account: emilys / emilyspass.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go to login'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      setState(() {
        _register = false;
        _username.text = 'emilys';
        _password.clear();
        _confirmPassword.clear();
      });
    } else {
      Get.offAll(() => const DashboardScreen());
    }
  }

  Future<void> _demoLogin() async {
    final error = await _auth.demoLogin();
    if (!mounted) return;
    if (error != null) {
      _showError(error);
    } else {
      Get.offAll(() => const DashboardScreen());
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF6672A9)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF4E5BB6), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF253784), Color(0xFF6075D0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0x33FFFFFF),
                      child: Icon(Icons.dashboard_customize_rounded,
                          size: 38, color: Colors.white),
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'Campus Catalog',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Mobile Computing • Internal Examination',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFDDE4FF)),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F6FF),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x330D1950),
                            blurRadius: 28,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _register ? 'Create account' : 'Welcome back!',
                              style: const TextStyle(
                                color: Color(0xFF172554),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _register
                                  ? 'Try the DummyJSON registration API'
                                  : 'Sign in using your DummyJSON username',
                              style: const TextStyle(color: Color(0xFF65708C)),
                            ),
                            const SizedBox(height: 22),
                            if (_register) ...[
                              TextFormField(
                                controller: _name,
                                textCapitalization: TextCapitalization.words,
                                decoration: _inputDecoration(
                                    'Full name', Icons.person_outline),
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? 'Please enter your name'
                                    : null,
                              ),
                              const SizedBox(height: 14),
                            ],
                            TextFormField(
                              controller: _username,
                              autocorrect: false,
                              decoration: _inputDecoration(
                                'Username', Icons.alternate_email_rounded),
                              validator: (v) {
                                final value = v?.trim() ?? '';
                                if (value.isEmpty) return 'Username is required';
                                if (value.length < 3) {
                                  return 'Enter at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            if (_register) ...[
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: _inputDecoration(
                                    'Email address', Icons.mail_outline),
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) return 'Email is required';
                                  if (!GetUtils.isEmail(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                            ],
                            TextFormField(
                              controller: _password,
                              obscureText: _hidePassword,
                              decoration: _inputDecoration(
                                  'Password', Icons.lock_outline).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(_hidePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () => setState(() =>
                                      _hidePassword = !_hidePassword),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password is required';
                                }
                                if (v.length < 6) {
                                  return 'Minimum 6 characters';
                                }
                                return null;
                              },
                            ),
                            if (_register) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _confirmPassword,
                                obscureText: _hidePassword,
                                decoration: _inputDecoration(
                                    'Confirm password', Icons.verified_outlined),
                                validator: (v) => v != _password.text
                                    ? 'Passwords do not match'
                                    : null,
                              ),
                            ],
                            const SizedBox(height: 22),
                            Obx(() => SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _auth.isLoading.value
                                    ? null
                                    : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3446A5),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: _auth.isLoading.value
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white),
                                      )
                                    : Text(
                                        _register ? 'Create account' : 'Sign in',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            )),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => setState(() {
                                _register = !_register;
                                _formKey.currentState?.reset();
                                _password.clear();
                                _confirmPassword.clear();
                              }),
                              child: Text(_register
                                  ? 'Already registered? Sign in'
                                  : 'New here? Create an account'),
                            ),
                            if (!_register) ...[
                              const Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('or',
                                        style: TextStyle(color: Colors.grey)),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Obx(() => OutlinedButton.icon(
                                onPressed: _auth.isLoading.value
                                    ? null
                                    : _demoLogin,
                                icon: const Icon(Icons.play_circle_outline),
                                label: const Text('Sign in with demo API account'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              )),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              _register
                                  ? 'Demo only: the API returns a user ID but '
                                    'does not save your account. Use test details, '
                                    'not a real password.'
                                  : 'Test account: emilys / emilyspass',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A5A19),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Built with Flutter • GetX • REST APIs',
                      style: TextStyle(color: Color(0xFFDDE4FF), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
