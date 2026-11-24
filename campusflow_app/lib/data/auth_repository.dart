import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/dio_client.dart';

/// Données renvoyées lors d'une authentification réussie.
class AuthResponse {
  final String token;
  final User user;

  const AuthResponse({
    required this.token,
    required this.user,
  });
}

/// Contrat du dépôt d'authentification.
abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
}

/// Implémentation de [AuthRepository] via Dio et l'API CampusFlow.
class ApiAuthRepository implements AuthRepository {
  final Dio _dio;

  const ApiAuthRepository(this._dio);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final data = response.data;
      if (data == null ||
          !data.containsKey('token') ||
          !data.containsKey('user')) {
        throw Exception('Réponse invalide du serveur d\'authentification');
      }
      return AuthResponse(
        token: data['token'] as String,
        user: User.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email ou mot de passe incorrect');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Délai d\'attente dépassé lors de la connexion');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Impossible de contacter le serveur d\'authentification',
        );
      }
      throw Exception(
        'Erreur de connexion : ${e.message ?? 'erreur inconnue'}',
      );
    }
  }
}

/// Fournisseur Riverpod pour le dépôt d'authentification.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiAuthRepository(dio);
});

