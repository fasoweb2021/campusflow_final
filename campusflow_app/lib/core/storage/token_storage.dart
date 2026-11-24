import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Gestionnaire du stockage sécurisé du jeton d'authentification.
class TokenStorage {
  const TokenStorage([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  Future<String?> read() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> write(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
  }
}

/// Fournisseur Riverpod pour l'accès au stockage sécurisé du jeton.
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return const TokenStorage();
});

