import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/session.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GreenFox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Session.instance.clear();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: const Center(child: Text('You are logged in ✅')),
    );
  }
}
