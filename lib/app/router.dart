import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ],
  );
}
