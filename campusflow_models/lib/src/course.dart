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
