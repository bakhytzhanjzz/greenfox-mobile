import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/login_page.dart';
import 'features/home/home_page.dart';
import 'core/session.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      // naive redirect: if we have a token, go to /home
      final hasToken = await Session.instance.hasToken();
      final loggingIn = state.matchedLocation == '/login';
      if (hasToken && loggingIn) return '/home';
      if (!hasToken && !loggingIn) return '/login';
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    // Important for async redirect
    refreshListenable: Session.instance,
  );
}
