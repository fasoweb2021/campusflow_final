import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow_app/app.dart';
import 'package:campusflow_app/core/storage/token_storage.dart';
import 'package:campusflow_app/data/auth_repository.dart';
import 'package:campusflow_app/data/fake_task_repository.dart';
import 'package:campusflow_app/data/task_repository.dart';
import 'package:campusflow_app/features/auth/auth_notifier.dart';

import 'fake_auth_repository.dart';
import 'in_memory_token_storage.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  group('Flux d\'authentification (TP27)', () {
    testWidgets('Identifiants faux -> affiche le message d\'erreur en rouge',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final tokenStorage = InMemoryTokenStorage();
      final authRepo = const FakeAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStorageProvider.overrideWithValue(tokenStorage),
            authRepositoryProvider.overrideWithValue(authRepo),
            taskRepositoryProvider.overrideWithValue(
              FakeTaskRepository(delay: Duration.zero),
            ),
          ],
          child: const CampusFlowApp(),
        ),
      );
      await tester.pumpAndSettle();

      // On est bien sur la page de connexion
      expect(find.text('CampusFlow'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Se connecter'), findsOneWidget);

      // Saisie d'un mot de passe incorrect
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Mot de passe *'),
        'mauvais_mot_de_passe',
      );
      await tester.pumpAndSettle();

      // Clic sur "Se connecter"
      await tester.tap(find.widgetWithText(FilledButton, 'Se connecter'));
      await tester.pumpAndSettle();

      // Vérifie l'apparition du message d'erreur
      expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
      expect(find.text('Échéances'), findsNothing);
    });

    testWidgets('Bons identifiants -> connecte et redirige vers Échéances',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final tokenStorage = InMemoryTokenStorage();
      final authRepo = const FakeAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStorageProvider.overrideWithValue(tokenStorage),
            authRepositoryProvider.overrideWithValue(authRepo),
            taskRepositoryProvider.overrideWithValue(
              FakeTaskRepository(delay: Duration.zero),
            ),
          ],
          child: const CampusFlowApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Saisie des bons identifiants
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email *'),
        'etudiant@campusflow.bf',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Mot de passe *'),
        'campus2026',
      );
      await tester.pumpAndSettle();

      // Clic sur "Se connecter"
      await tester.tap(find.widgetWithText(FilledButton, 'Se connecter'));
      await tester.pumpAndSettle();

      // Vérifie la redirection automatique vers Échéances
      expect(find.text('Échéances'), findsWidgets);
      expect(find.text('Se connecter'), findsNothing);
      expect(await tokenStorage.read(), equals('fake-jwt-u1-test-token'));
    });

    testWidgets(
        'Déconnexion depuis ProfilScreen -> efface le jeton et redirige vers /login',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final tokenStorage = InMemoryTokenStorage('fake-jwt-u1-test-token');
      final authRepo = const FakeAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStorageProvider.overrideWithValue(tokenStorage),
            authRepositoryProvider.overrideWithValue(authRepo),
            taskRepositoryProvider.overrideWithValue(
              FakeTaskRepository(delay: Duration.zero),
            ),
          ],
          child: const CampusFlowApp(),
        ),
      );
      await tester.pumpAndSettle();

      // L'utilisateur est connecté et sur /taches
      expect(find.text('Échéances'), findsWidgets);

      // Navigation vers Profil
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();

      expect(find.text('Moussa Ouédraogo'), findsOneWidget);
      expect(find.text('Se déconnecter'), findsOneWidget);

      // Clic sur "Se déconnecter"
      await tester.tap(find.text('Se déconnecter'));
      await tester.pumpAndSettle();

      // Boîte de dialogue de confirmation
      expect(find.text('Déconnexion'), findsOneWidget);
      expect(
        find.text('Voulez-vous vraiment vous déconnecter ?'),
        findsOneWidget,
      );

      // Confirmation
      await tester.tap(find.widgetWithText(FilledButton, 'Se déconnecter'));
      await tester.pumpAndSettle();

      // Redirection automatique vers l'écran de login
      expect(find.widgetWithText(FilledButton, 'Se connecter'), findsOneWidget);
      expect(await tokenStorage.read(), isNull);
    });

    testWidgets(
        'Un 401 déclenché force la déconnexion et redirige vers /login',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final tokenStorage = InMemoryTokenStorage('fake-jwt-expired');
      final authRepo = const FakeAuthRepository();

      late WidgetRef capturedRef;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStorageProvider.overrideWithValue(tokenStorage),
            authRepositoryProvider.overrideWithValue(authRepo),
            taskRepositoryProvider.overrideWithValue(
              FakeTaskRepository(delay: Duration.zero),
            ),
          ],
          child: Consumer(
            builder: (context, ref, child) {
              capturedRef = ref;
              return const CampusFlowApp();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // L'utilisateur démarre connecté sur /taches
      expect(find.text('Échéances'), findsWidgets);

      // Simulation de la réception d'un 401 via forceLogout (action effectuée par AuthInterceptor)
      await capturedRef.read(authProvider.notifier).forceLogout();
      await tester.pumpAndSettle();

      // Vérifie la redirection automatique immédiate vers /login
      expect(find.widgetWithText(FilledButton, 'Se connecter'), findsOneWidget);
      expect(await tokenStorage.read(), isNull);
    });
  });
}

