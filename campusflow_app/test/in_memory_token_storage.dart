import 'package:campusflow_app/core/storage/token_storage.dart';

/// Implémentation en mémoire de [TokenStorage] pour les tests sans plateforme native.
class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  InMemoryTokenStorage([this._token]);

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async {
    _token = token;
  }

  @override
  Future<void> clear() async {
    _token = null;
  }
}

