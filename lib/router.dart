import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart'; // Import RegisterPage
import 'features/home/home_page.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/role_selection_page.dart';
import 'core/session.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) async {
      final hasToken = await Session.instance.hasToken();
      final loggingIn = state.matchedLocation == '/login';
      if (hasToken && loggingIn) return '/home';
      if (!hasToken && !loggingIn) return '/role_selection';
      return null;
    },
    routes: <RouteBase>[
      // Splash screen route
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Role selection route
      GoRoute(
        path: '/role_selection',
        builder: (context, state) => const RoleSelectionPage(),
      ),
      // Login route
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      // Register route
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      // Home route
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    refreshListenable: Session.instance,
  );
}
