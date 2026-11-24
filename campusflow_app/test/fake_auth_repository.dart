import 'package:campusflow_app/data/auth_repository.dart';
import 'package:campusflow_models/campusflow_models.dart';

/// Implémentation simulée de [AuthRepository] pour les tests unitaires et de widgets.
class FakeAuthRepository implements AuthRepository {
  final bool shouldFail;

  const FakeAuthRepository({this.shouldFail = false});

  @override
  Future<AuthResponse> login(String email, String password) async {
    if (shouldFail ||
        email != 'etudiant@campusflow.bf' ||
        password != 'campus2026') {
      throw Exception('Email ou mot de passe incorrect');
    }

    return const AuthResponse(
      token: 'fake-jwt-u1-test-token',
      user: User(
        id: 'u1',
        name: 'Moussa Ouédraogo',
        email: 'etudiant@campusflow.bf',
        program: 'Licence 3 Informatique',
      ),
    );
  }
}

