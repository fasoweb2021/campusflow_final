/// Modèle immuable représentant une matière / un cours dans CampusFlow.
class Course {
  final String id;
  final String name;
  final String teacher;
  final String? room;

  const Course({
    required this.id,
    required this.name,
    required this.teacher,
    this.room,
  });

  /// Construit un cours depuis une Map JSON.
  /// Lève une [FormatException] avec un message en français si un champ obligatoire manque ou est invalide.
  /// Un identifiant numérique est accepté et automatiquement converti en String.
  factory Course.fromJson(Map<String, dynamic> json) {
    // Validation de l'id
    final rawId = json['id'];
    if (rawId == null) {
      throw const FormatException("Le champ 'id' est obligatoire pour un cours.");
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

    // Validation du nom du cours
    final rawName = json['name'];
    if (rawName == null) {
      throw const FormatException("Le champ 'name' est obligatoire pour un cours.");
    }
    if (rawName is! String || rawName.trim().isEmpty) {
      throw const FormatException("Le champ 'name' doit être une chaîne non vide.");
    }

    // Validation de l'enseignant
    final rawTeacher = json['teacher'];
    if (rawTeacher == null) {
      throw const FormatException("Le champ 'teacher' est obligatoire pour un cours.");
    }
    if (rawTeacher is! String || rawTeacher.trim().isEmpty) {
      throw const FormatException("Le champ 'teacher' doit être une chaîne non vide.");
    }

    // Salle (optionnelle)
    final rawRoom = json['room'];
    if (rawRoom != null && rawRoom is! String) {
      throw const FormatException("Le champ 'room' doit être une chaîne de caractères.");
    }

    return Course(
      id: id,
      name: rawName,
      teacher: rawTeacher,
      room: rawRoom as String?,
    );
  }

  /// Sérialise ce cours en une Map JSON compatible avec l'API REST.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacher': teacher,
      'room': room,
    };
  }

  /// Crée une copie de ce cours avec les champs modifiés spécifiés.
  Course copyWith({
    String? id,
    String? name,
    String? teacher,
    String? room,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      room: room ?? this.room,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Course(id: $id, name: $name, teacher: $teacher, room: $room)';
  }
}
