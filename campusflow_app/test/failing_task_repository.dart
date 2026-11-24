import 'package:campusflow_app/data/task_repository.dart';
import 'package:campusflow_models/campusflow_models.dart';

/// Implémentation de [TaskRepository] qui échoue systématiquement pour simuler les pannes réseau ou serveur.
class FailingTaskRepository implements TaskRepository {
  final String errorMessage;

  const FailingTaskRepository({
    this.errorMessage = 'Erreur serveur simulée : impossible de contacter le serveur',
  });

  @override
  Future<List<Task>> fetchAll() async {
    throw Exception(errorMessage);
  }

  @override
  Future<Task> create(Task task) async {
    throw Exception(errorMessage);
  }

  @override
  Future<Task> toggleDone(String id, bool done) async {
    throw Exception(errorMessage);
  }

  @override
  Future<void> delete(String id) async {
    throw Exception(errorMessage);
  }
}

