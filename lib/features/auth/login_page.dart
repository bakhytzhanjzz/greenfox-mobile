import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => loading = true);
    final api = ApiClient.create();
    try {
      // IMPORTANT: adapt the payload keys to your backend contract.
      // Common variants: phone/phoneNumber, password.
      final res = await api.dio.post('/auth/login', data: {
        'phoneNumber': phoneCtrl.text.trim(), // change to 'phone' if needed
        'password': passCtrl.text,
      });

      // Token field variants we’ll try in order:
      final data = res.data;
      final token = (data['token'] ?? data['accessToken'] ?? data['jwt'])?.toString();

      if (token == null || token.isEmpty) {
        throw Exception('No token in response. Please confirm the /auth/login response shape.');
      }

      await Session.instance.saveToken(token);
      if (mounted) context.go('/home');
    } on DioException catch (e) {
      final msg = _extractError(e);
      _showSnack(msg);
    } catch (e) {
      _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String _extractError(DioException e) {
    final d = e.response?.data;
    if (d is Map && d['message'] != null) return d['message'].toString();
    if (e.message != null) return e.message!;
    return 'Login failed';
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('Welcome to GreenFox', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 24),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone (+7...)',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: loading ? null : _login,
                child: loading
                    ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Sign in'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to RegisterPage
                  context.go('/register');
                },
                child: const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
