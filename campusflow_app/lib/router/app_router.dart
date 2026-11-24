import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/courses/cours_screen.dart';
import '../features/profile/profil_screen.dart';
import '../features/tasks/data/sample_tasks.dart';
import '../features/tasks/echeances_screen.dart';
import '../features/tasks/task_detail_screen.dart';
import '../features/tasks/task_form_screen.dart';
import '../shell/app_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter({
  String initialLocation = '/login',
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  final rootKey = navigatorKey ?? rootNavigatorKey;
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    routes: [
      // Écran de login (hors ShellRoute)
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootKey,
        builder: (context, state) => const LoginScreen(),
      ),

      // ShellRoute avec les 3 onglets principaux
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

      // Routes plein écran (hors ShellRoute, avec parentNavigatorKey racine)
      // /taches/nouvelle déclarée AVANT /taches/:id
      GoRoute(
        path: '/taches/nouvelle',
        parentNavigatorKey: rootKey,
        builder: (context, state) => TaskFormScreen(courses: sampleCourses),
      ),
      GoRoute(
        path: '/taches/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return TaskDetailScreen(taskId: id);
        },
      ),
    ],
  );
}

final GoRouter appRouter = createRouter();

