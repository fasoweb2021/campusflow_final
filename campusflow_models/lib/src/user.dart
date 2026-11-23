/// Modèle immuable représentant un utilisateur étudiant dans CampusFlow.
///
/// Remarque de sécurité : le mot de passe n'apparaît JAMAIS dans ce modèle.
class User {
  final String id;
  final String name;
  final String email;
  final String program;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.program,
  });

  /// Crée une copie de cet utilisateur avec les champs modifiés spécifiés.
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? program,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      program: program ?? this.program,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, program: $program)';
  }
}
