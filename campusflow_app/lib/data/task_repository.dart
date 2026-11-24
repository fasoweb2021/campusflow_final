import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/dio_client.dart';
import 'api_task_repository.dart';

/// Contrat abstrait définissant les opérations sur les tâches.
abstract class TaskRepository {
  /// Récupère l'ensemble des tâches.
  Future<List<Task>> fetchAll();

  /// Crée une nouvelle tâche.
  Future<Task> create(Task task);

  /// Met à jour l'état d'achèvement d'une tâche existante.
  Future<Task> toggleDone(String id, bool done);

  /// Supprime une tâche par son identifiant.
  Future<void> delete(String id);
}

/// Fournisseur Riverpod du [TaskRepository], utilisant par défaut [ApiTaskRepository].
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiTaskRepository(dio);
});

