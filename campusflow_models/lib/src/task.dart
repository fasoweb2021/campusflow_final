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

  /// Construit une tâche depuis une Map JSON.
  /// Lève une [FormatException] avec un message en français en cas de champ manquant ou de mauvais type.
  /// Un identifiant numérique est accepté et automatiquement converti en String.
  factory Task.fromJson(Map<String, dynamic> json) {
    // Validation et conversion de l'identifiant (obligatoire)
    final rawId = json['id'];
    if (rawId == null) {
      throw const FormatException("Le champ 'id' est obligatoire pour une tâche.");
    }
    final String id;
    if (rawId is String) {
      if (rawId.trim().isEmpty) {
        throw const FormatException("Le champ 'id' ne peut pas être vide.");
      }
      id = rawId;
    } else if (rawId is num) {
      id = rawId.toString();
    } else {
      throw const FormatException("Le champ 'id' doit être une chaîne ou un nombre.");
    }

    // Validation du titre (obligatoire, non vide)
    final rawTitle = json['title'];
    if (rawTitle == null) {
      throw const FormatException("Le champ 'title' est obligatoire pour une tâche.");
    }
    if (rawTitle is! String || rawTitle.trim().isEmpty) {
      throw const FormatException("Le champ 'title' doit être une chaîne non vide.");
    }

    // Description (optionnelle)
    final rawDescription = json['description'];
    if (rawDescription != null && rawDescription is! String) {
      throw const FormatException("Le champ 'description' doit être une chaîne de caractères.");
    }

    // Date d'échéance (obligatoire, format ISO 8601)
    final rawDueDate = json['dueDate'];
    if (rawDueDate == null) {
      throw const FormatException("Le champ 'dueDate' est obligatoire pour une tâche.");
    }
    final DateTime dueDate;
    if (rawDueDate is String) {
      final parsed = DateTime.tryParse(rawDueDate);
      if (parsed == null) {
        throw const FormatException("Le champ 'dueDate' doit être une date au format ISO 8601 valide.");
      }
      dueDate = parsed;
    } else {
      throw const FormatException("Le champ 'dueDate' doit être une chaîne au format ISO 8601.");
    }

    // Statut fait (optionnel, booléen, défaut false)
    final rawDone = json['done'];
    final bool done;
    if (rawDone == null) {
      done = false;
    } else if (rawDone is bool) {
      done = rawDone;
    } else {
      throw const FormatException("Le champ 'done' doit être un booléen.");
    }

    // Référence du cours (optionnelle)
    final rawCourseId = json['courseId'];
    final String? courseId;
    if (rawCourseId == null) {
      courseId = null;
    } else if (rawCourseId is String) {
      courseId = rawCourseId;
    } else if (rawCourseId is num) {
      courseId = rawCourseId.toString();
    } else {
      throw const FormatException("Le champ 'courseId' doit être une chaîne ou un nombre.");
    }

    return Task(
      id: id,
      title: rawTitle,
      description: rawDescription as String?,
      dueDate: dueDate,
      done: done,
      courseId: courseId,
    );
  }

  /// Sérialise cette tâche en une Map JSON compatible avec l'API REST.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'done': done,
      'courseId': courseId,
    };
  }

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
