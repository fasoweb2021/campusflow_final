/// Modèle immuable représentant une tâche / échéance dans CampusFlow.
class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool done;
  final String? courseId;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.done = false,
    this.courseId,
  });

  /// Indique si la tâche est en retard par rapport à l'instant [now].
  /// Une tâche est en retard si elle n'est pas faite et que sa date d'échéance est antérieure à [now].
  bool isOverdue(DateTime now) => !done && dueDate.isBefore(now);

  /// Crée une copie de cette tâche avec les champs modifiés spécifiés.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? done,
    String? courseId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      done: done ?? this.done,
      courseId: courseId ?? this.courseId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, dueDate: $dueDate, done: $done, courseId: $courseId)';
  }
}
