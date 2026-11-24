import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/task_repository.dart';
import '../data/sample_tasks.dart';

/// Fournisseur principal des tâches géré par un [AsyncNotifier].
final tachesProvider =
    AsyncNotifierProvider<TachesNotifier, List<Task>>(TachesNotifier.new);

/// Fournisseur des cours (local pour ce TP).
final coursProvider = Provider<List<Course>>((ref) => sampleCourses);

/// Notifier asynchrone gérant le cycle de vie et les mutations des tâches.
class TachesNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final repo = ref.read(taskRepositoryProvider);
    final tasks = await repo.fetchAll();
    return [...tasks]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  /// Crée une tâche sur le serveur et insère la tâche créée dans la liste locale ordonnée.
  Future<void> ajouter(Task t) async {
    final repo = ref.read(taskRepositoryProvider);
    final created = await repo.create(t);
    final currentTasks = state.value ?? [];
    state = AsyncData(
      [...currentTasks, created]..sort((a, b) => a.dueDate.compareTo(b.dueDate)),
    );
  }

  /// Bascule le statut d'achèvement d'une tâche via le serveur et met à jour l'état immuable.
  Future<void> basculer(String id) async {
    final currentTasks = state.value ?? [];
    final targetIndex = currentTasks.indexWhere((t) => t.id == id);
    if (targetIndex == -1) return;
    final target = currentTasks[targetIndex];
    final repo = ref.read(taskRepositoryProvider);
    final updated = await repo.toggleDone(id, !target.done);
    state = AsyncData([
      for (final t in currentTasks)
        if (t.id == id) updated else t,
    ]);
  }

  /// Supprime une tâche sur le serveur et la retire de la liste locale immuable.
  Future<void> supprimer(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.delete(id);
    final currentTasks = state.value ?? [];
    state = AsyncData([
      for (final t in currentTasks)
        if (t.id != id) t,
    ]);
  }
}
