import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnSession();
  }

  Future<void> _navigateBasedOnSession() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash screen delay

    final hasToken = await Session.instance.hasToken();

    if (hasToken) {
      if (mounted) {
        // If token exists, navigate directly to home
        context.go('/home');
      }
    } else {
      if (mounted) {
        // If no token exists, navigate to the role selection screen
        context.go('/role_selection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
