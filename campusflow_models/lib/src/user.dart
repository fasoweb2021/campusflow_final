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

  /// Construit un utilisateur depuis une Map JSON.
  /// Lève une [FormatException] avec un message en français si un champ obligatoire manque ou est invalide.
  /// Un identifiant numérique est accepté et automatiquement converti en String.
  factory User.fromJson(Map<String, dynamic> json) {
    // Validation de l'id
    final rawId = json['id'];
    if (rawId == null) {
      throw const FormatException("Le champ 'id' est obligatoire pour un utilisateur.");
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

    // Validation du nom
    final rawName = json['name'];
    if (rawName == null) {
      throw const FormatException("Le champ 'name' est obligatoire pour un utilisateur.");
    }
    if (rawName is! String || rawName.trim().isEmpty) {
      throw const FormatException("Le champ 'name' doit être une chaîne non vide.");
    }

    // Validation de l'email
    final rawEmail = json['email'];
    if (rawEmail == null) {
      throw const FormatException("Le champ 'email' est obligatoire pour un utilisateur.");
    }
    if (rawEmail is! String || rawEmail.trim().isEmpty) {
      throw const FormatException("Le champ 'email' doit être une chaîne non vide.");
    }

    // Validation du programme / de la filière
    final rawProgram = json['program'];
    if (rawProgram == null) {
      throw const FormatException("Le champ 'program' est obligatoire pour un utilisateur.");
    }
    if (rawProgram is! String || rawProgram.trim().isEmpty) {
      throw const FormatException("Le champ 'program' doit être une chaîne non vide.");
    }

    return User(
      id: id,
      name: rawName,
      email: rawEmail,
      program: rawProgram,
    );
  }

  /// Sérialise cet utilisateur en une Map JSON compatible avec l'API REST.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'program': program,
    };
  }

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
