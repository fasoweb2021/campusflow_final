import 'task.dart';

/// Dépôt de tâches simulé pour le développement et les tests.
///
/// Charge des données asynchrones après un délai simulé de 300 ms.
/// Si [shouldFail] est vrai, lève une [Exception] pour tester la gestion des erreurs.
class MockTaskRepository {
  final bool shouldFail;

  const MockTaskRepository({this.shouldFail = false});

  /// Données initiales en dur sous forme de Map JSON.
  static const List<Map<String, dynamic>> rawMockTasks = [
    {
      'id': '1',
      'title': 'Fiche comparative Android/iOS',
      'description': 'Comparer les 14 critères et parts de marché StatCounter.',
      'dueDate': '2026-11-20T23:59:00.000Z',
      'done': true,
      'courseId': 'course-1',
    },
    {
      'id': '2',
      'title': 'Autopsie de BlackBerry OS',
      'description': 'Analyser les 3 causes majeures de la disparition de RIM.',
      'dueDate': '2026-11-21T23:59:00.000Z',
      'done': true,
      'courseId': 'course-1',
    },
    {
      'id': '3',
      'title': 'TP06 Wireframes basse fidélité',
      'description': 'Concevoir les 5 écrans SVG et les 3 variantes dévaluation.',
      'dueDate': '2026-11-22T23:59:00.000Z',
      'done': false,
      'courseId': 'course-1',
    },
    {
      'id': 4, // Id numérique pour tester la conversion automatique en String
      'title': 'Rapport d algorithmique avancée',
      'description': 'Étude de complexité et arbres binaires équilibrés.',
      'dueDate': '2026-11-21T18:00:00.000Z',
      'done': false,
      'courseId': 'course-2',
    },
    {
      'id': '5',
      'title': 'Configuration VLAN & Routage',
      'description': 'Préparer le compte rendu du laboratoire Cisco Packet Tracer.',
      'dueDate': '2026-11-28T12:00:00.000Z',
      'done': false,
      'courseId': 'course-3',
    },
    {
      'id': '6',
      'title': 'Projet synthèse Flutter - Sprint 1',
      'description': 'Mettre en place la navigation GoRouter et le thème Material 3.',
      'dueDate': '2026-12-05T23:59:00.000Z',
      'done': false,
      'courseId': 'course-1',
    },
  ];

  /// Charge la liste des tâches de manière asynchrone après un délai de 300 ms.
  Future<List<Task>> fetchTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (shouldFail) {
      throw Exception('Erreur de connexion au serveur de tâches simulé.');
    }

    return rawMockTasks.map((json) => Task.fromJson(json)).toList();
  }
}
