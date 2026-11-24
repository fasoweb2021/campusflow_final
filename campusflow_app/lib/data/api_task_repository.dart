import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';

import 'task_repository.dart';

/// Implémentation de [TaskRepository] communiquant avec l'API REST via [Dio].
class ApiTaskRepository implements TaskRepository {
  const ApiTaskRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Task>> fetchAll() async {
    try {
      final response = await _dio.get<List<dynamic>>('/taches');
      final data = response.data;
      if (data == null) {
        return const [];
      }
      return data
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e, 'Impossible de récupérer la liste des tâches');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(
        'Erreur inattendue lors de la récupération des tâches : $e',
      );
    }
  }

  @override
  Future<Task> create(Task task) async {
    try {
      final body = task.toJson()..remove('id');
      final response = await _dio.post<Map<String, dynamic>>(
        '/taches',
        data: body,
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Réponse vide lors de la création de la tâche.');
      }
      return Task.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e, 'Impossible de créer la tâche');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur inattendue lors de la création de la tâche : $e');
    }
  }

  @override
  Future<Task> toggleDone(String id, bool done) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/taches/$id',
        data: {'done': done},
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Réponse vide lors de la mise à jour de la tâche.');
      }
      return Task.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e, 'Impossible de modifier le statut de la tâche');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(
        'Erreur inattendue lors de la mise à jour de la tâche : $e',
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _dio.delete<void>('/taches/$id');
    } on DioException catch (e) {
      throw _handleDioError(e, 'Impossible de supprimer la tâche');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(
        'Erreur inattendue lors de la suppression de la tâche : $e',
      );
    }
  }

  Exception _handleDioError(DioException e, String contextMessage) {
    final statusCode = e.response?.statusCode;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Exception('$contextMessage : délai d\'attente réseau dépassé.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception(
        '$contextMessage : impossible de contacter le serveur. Vérifiez votre connexion.',
      );
    }
    if (statusCode != null) {
      if (statusCode == 404) {
        return Exception('$contextMessage : ressource introuvable (404).');
      }
      if (statusCode == 401) {
        return Exception('$contextMessage : non autorisé (401).');
      }
      if (statusCode >= 500) {
        return Exception(
          '$contextMessage : erreur interne du serveur ($statusCode).',
        );
      }
      return Exception('$contextMessage : erreur HTTP $statusCode.');
    }
    return Exception(
      '$contextMessage : ${e.message ?? 'erreur réseau inconnue'}.',
    );
  }
}

