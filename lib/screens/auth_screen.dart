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

  void _showMessage(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 4 : 5),
      ),
    );
  }

  Future<void> _submit() async {
    if (_auth.isLoading.value) return;
    if (!_formKey.currentState!.validate()) {
      _showMessage('Please check the highlighted fields.', isError: true);
      return;
    }
    FocusScope.of(context).unfocus();
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
      _showMessage(error, isError: true);
    } else if (_register) {
      setState(() {
        _register = false;
        _username.text = 'emilys';
        _password.clear();
        _confirmPassword.clear();
      });
      _showMessage(
        'Registration request successful. This demo does not save accounts. '
        'Sign in with emilys / emilyspass.',
      );
    } else {
      _showMessage('Login successful. Welcome back!');
      Get.offAll(() => const DashboardScreen());
    }
  }

  Future<void> _demoLogin() async {
    if (_auth.isLoading.value) return;
    FocusScope.of(context).unfocus();
    final error = await _auth.demoLogin();
    if (!mounted) return;
    if (error != null) {
      _showMessage(error, isError: true);
    } else {
      _showMessage('Login successful. Welcome back!');
      Get.offAll(() => const DashboardScreen());
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF6672A9)),
      filled: true,
      fillColor: const Color(0xFFF8FAFF),
      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8EDFF), Color(0xFFF8FAFC)],
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
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3446A5),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Campus Catalog',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: Color(0xFF172554),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your campus. One place to explore.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE8ECF5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D243675),
                            blurRadius: 32,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _register
                                  ? 'Create your account'
                                  : 'Welcome back',
                              style: const TextStyle(
                                color: Color(0xFF172554),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _register
                                  ? 'Fill in your details to get started.'
                                  : 'Sign in to explore products and your community.',
                              style: const TextStyle(color: Color(0xFF65708C)),
                            ),
                            const SizedBox(height: 22),
                            if (_register) ...[
                              TextFormField(
                                controller: _name,
                                textCapitalization: TextCapitalization.words,
                                decoration: _inputDecoration(
                                  'Full name',
                                  Icons.person_outline,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Please enter your name'
                                    : null,
                              ),
                              const SizedBox(height: 14),
                            ],
                            TextFormField(
                              controller: _username,
                              autocorrect: false,
                              decoration: _inputDecoration(
                                'Username',
                                Icons.alternate_email_rounded,
                              ),
                              validator: (v) {
                                final value = v?.trim() ?? '';
                                if (value.isEmpty) {
                                  return 'Username is required';
                                }
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
                                  'Email address',
                                  Icons.mail_outline,
                                ),
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
                              decoration:
                                  _inputDecoration(
                                    'Password',
                                    Icons.lock_outline,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      tooltip: _hidePassword
                                          ? 'Show password'
                                          : 'Hide password',
                                      icon: Icon(
                                        _hidePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () => setState(
                                        () => _hidePassword = !_hidePassword,
                                      ),
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
                                  'Confirm password',
                                  Icons.verified_outlined,
                                ),
                                validator: (v) => v != _password.text
                                    ? 'Passwords do not match'
                                    : null,
                              ),
                            ],
                            const SizedBox(height: 22),
                            Obx(
                              () => SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _auth.isLoading.value
                                      ? null
                                      : _submit,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xFF3446A5),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _auth.isLoading.value
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          _register
                                              ? 'Create account'
                                              : 'Sign in',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => TextButton(
                                onPressed: _auth.isLoading.value
                                    ? null
                                    : () => setState(() {
                                        _register = !_register;
                                        _formKey.currentState?.reset();
                                        _password.clear();
                                        _confirmPassword.clear();
                                      }),
                                child: Text(
                                  _register
                                      ? 'Already registered? Sign in'
                                      : 'New here? Create an account',
                                ),
                              ),
                            ),
                            if (!_register) ...[
                              const Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'or',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => OutlinedButton.icon(
                                  onPressed: _auth.isLoading.value
                                      ? null
                                      : _demoLogin,
                                  icon: const Icon(
                                    Icons.rocket_launch_outlined,
                                  ),
                                  label: const Text('Try demo account'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF3446A5),
                                    side: const BorderSide(
                                      color: Color(0xFFD6DCF2),
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
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
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
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
