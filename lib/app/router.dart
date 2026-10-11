import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app/app_routes.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_shell.dart';
import '../features/master_data/presentation/screens/service_locations_screen.dart';
import '../features/master_data/presentation/screens/service_posts_locations_screen.dart';
import '../features/master_data/presentation/screens/shifts_screen.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (location == AppRoutes.splash || location == AppRoutes.login) {
        return null;
      }
      if (FirebaseAuth.instance.currentUser == null) {
        return AppRoutes.login;
      }
      return null;
    },
    routes: routes,
  );

  static final routes = [
    GoRoute(
      path: AppRoutes.shifts,
      builder: (context, state) => const ShiftsScreen(),
    ),

    GoRoute(
      path: AppRoutes.servicePosts,
      builder: (context, state) => const ServicePostsLocationsScreen(),
    ),

    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardShell(),
    ),

    GoRoute(
      path: AppRoutes.personnel,
      builder: (context, state) => const DashboardShell(initialIndex: 1),
    ),
    GoRoute(
      path: AppRoutes.tasks,
      builder: (context, state) => const DashboardShell(initialIndex: 2),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => const DashboardShell(initialIndex: 3),
    ),
    GoRoute(
      path: AppRoutes.serviceLocations,
      builder: (context, state) => const ServiceLocationsScreen(),
    ),
  ];
}
