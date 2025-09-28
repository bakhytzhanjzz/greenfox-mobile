import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final phoneCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    phoneCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => loading = true);

    final api = ApiClient.create();
    try {
      final res = await api.dio.post('/auth/register', data: {
        'phoneNumber': phoneCtrl.text.trim(),
        'firstName': firstNameCtrl.text.trim(),
        'lastName': lastNameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'password': passwordCtrl.text,
      });

      // Handle successful registration (navigate to login)
      final data = res.data;
      if (data['message'] == 'User created successfully') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          context.go('/login'); // Redirect to login after successful registration
        }
      } else {
        throw Exception('Registration failed: ${data['message']}');
      }
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
    return 'Registration failed';
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text('Create your account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone (+7...)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: firstNameCtrl,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastNameCtrl,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: loading ? null : _register,
              child: loading
                  ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
