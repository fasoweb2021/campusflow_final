import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_tasks.dart';

final tachesProvider =
    NotifierProvider<TachesNotifier, List<Task>>(TachesNotifier.new);

final coursProvider = Provider<List<Course>>((ref) => sampleCourses);

class TachesNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    return [...sampleTasks]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void ajouter(Task t) {
    final newList = [...state, t]
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    state = newList;
  }

  void basculer(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(done: !t.done) else t,
    ];
  }
}

