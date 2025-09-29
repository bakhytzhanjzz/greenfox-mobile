import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/home/home_page.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/role_selection_page.dart';
import 'core/session.dart';
import 'features/home/resort_details_page.dart'; // <-- import the new page

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
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/role_selection', builder: (context, state) => const RoleSelectionPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),

      // new details route - expects state.extra to be Map<String, dynamic> (resort)
      GoRoute(
        path: '/resort_details',
        builder: (context, state) {
          final resort = state.extra as Map<String, dynamic>? ?? <String, dynamic>{};
          return ResortDetailsPage(resort: resort);
        },
      ),
    ],
    refreshListenable: Session.instance,
  );
}
