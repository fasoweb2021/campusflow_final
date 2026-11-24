import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/token_storage.dart';
import '../../features/auth/auth_notifier.dart';

/// Intercepteur Dio qui ajoute le jeton Bearer aux requêtes et gère l'invalidation 401.
class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Ne pas injecter de jeton sur la route de login
    if (!options.path.endsWith('/login')) {
      final token = await _ref.read(tokenStorageProvider).read();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Si code 401 hors /login, effacer le jeton et forcer la déconnexion
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.endsWith('/login')) {
      await _ref.read(tokenStorageProvider).clear();
      _ref.read(authProvider.notifier).forceLogout();
    }
    handler.next(err);
  }
}

