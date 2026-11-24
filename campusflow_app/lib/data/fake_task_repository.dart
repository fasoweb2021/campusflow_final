import 'package:campusflow_models/campusflow_models.dart';

import '../features/tasks/data/sample_tasks.dart';
import 'task_repository.dart';

/// Implémentation en mémoire de [TaskRepository] pour les tests et le développement.
class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({
    List<Task>? initialTasks,
    this.delay = const Duration(milliseconds: 100),
  }) : _tasks = List.of(initialTasks ?? sampleTasks);

  final List<Task> _tasks;
  final Duration delay;

  @override
  Future<List<Task>> fetchAll() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> create(Task task) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final newTask = task.id.isEmpty
        ? task.copyWith(id: 'fake-${DateTime.now().millisecondsSinceEpoch}')
        : task;
    _tasks.add(newTask);
    return newTask;
  }

  @override
  Future<Task> toggleDone(String id, bool done) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw Exception('Tâche avec l\'identifiant "$id" introuvable.');
    }
    final updated = _tasks[index].copyWith(done: done);
    _tasks[index] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw Exception('Tâche avec l\'identifiant "$id" introuvable.');
    }
    _tasks.removeAt(index);
  }
}

