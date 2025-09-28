import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Text(
              'Please select your role:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                // Navigate directly to login as Client
                context.go('/login');
              },
              child: const Text('Client'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                // Partner option (will do nothing for now)
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Partner'),
                    content: const Text('This feature is coming soon!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Partner (coming soon)'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
