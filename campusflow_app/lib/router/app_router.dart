import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_notifier.dart';
import '../features/auth/login_screen.dart';
import '../features/courses/cours_screen.dart';
import '../features/profile/profil_screen.dart';
import '../features/tasks/echeances_screen.dart';
import '../features/tasks/task_detail_screen.dart';
import '../features/tasks/task_form_screen.dart';
import '../shell/app_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Listenable alimenté par les changements d'état d'authentification pour rafraîchir GoRouter.
class AuthListenable extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final authListenableProvider = Provider<AuthListenable>((ref) {
  final listenable = AuthListenable();
  ref.listen<AsyncValue<bool>>(authProvider, (previous, next) {
    listenable.refresh();
  });
  return listenable;
});

/// Fournisseur officiel du routeur de l'application avec protection par redirection auth.
final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = ref.watch(authListenableProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/taches',
    refreshListenable: authListenable,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.value ?? false;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/taches';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/taches',
            builder: (context, state) => const EcheancesScreen(),
          ),
          GoRoute(
            path: '/cours',
            builder: (context, state) => const CoursScreen(),
          ),
          GoRoute(
            path: '/profil',
            builder: (context, state) => const ProfilScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/taches/nouvelle',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const TaskFormScreen(),
      ),
      GoRoute(
        path: '/taches/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final taskId = state.pathParameters['id'];
          return TaskDetailScreen(taskId: taskId);
        },
      ),
    ],
  );
});

/// Fonction de création manuelle de routeur pour les tests unitaires / d'intégration.
GoRouter createRouter({
  String initialLocation = '/login',
  GlobalKey<NavigatorState>? navigatorKey,
  String? Function(BuildContext, GoRouterState)? redirect,
  Listenable? refreshListenable,
}) {
  final rootKey = navigatorKey ?? rootNavigatorKey;
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    refreshListenable: refreshListenable,
    redirect: redirect,
    routes: [
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootKey,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/taches',
            builder: (context, state) => const EcheancesScreen(),
          ),
          GoRoute(
            path: '/cours',
            builder: (context, state) => const CoursScreen(),
          ),
          GoRoute(
            path: '/profil',
            builder: (context, state) => const ProfilScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/taches/nouvelle',
        parentNavigatorKey: rootKey,
        builder: (context, state) => const TaskFormScreen(),
      ),
      GoRoute(
        path: '/taches/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) {
          final taskId = state.pathParameters['id'];
          return TaskDetailScreen(taskId: taskId);
        },
      ),
    ],
  );
}
