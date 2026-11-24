import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/token_storage.dart';
import '../../data/auth_repository.dart';
import '../tasks/providers/taches_notifier.dart';

/// Notifier gérant l'état d'authentification (true = connecté, false = non connecté).
class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await ref.read(tokenStorageProvider).read();
    return token != null && token.isNotEmpty;
  }

  /// Tente de connecter l'utilisateur avec ses identifiants.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final response =
          await ref.read(authRepositoryProvider).login(email, password);
      await ref.read(tokenStorageProvider).write(response.token);
      state = const AsyncData(true);
      ref.invalidate(tachesProvider);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Déconnecte l'utilisateur et efface son jeton de session.
  Future<void> logout() async {
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncData(false);
    ref.invalidate(tachesProvider);
  }

  /// Déconnexion forcée suite à une invalidation de jeton (code 401).
  Future<void> forceLogout() async {
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncData(false);
    ref.invalidate(tachesProvider);
  }
}

/// Fournisseur de l'état d'authentification de l'application.
final authProvider =
    AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

