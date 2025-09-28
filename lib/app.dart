import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';
import 'theme/theme.dart';

class GreenFoxApp extends StatelessWidget {
  const GreenFoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = buildRouter();
    return MaterialApp.router(
      title: 'GreenFox',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: router,
    );
  }
}
