import 'package:campusflow_models/campusflow_models.dart';

Future<void> main() async {
  print('=== CampusFlow Models — Démonstration asynchrone ===\n');

  // 1. Appel nominal avec succès
  print('[1] Chargement des tâches via MockTaskRepository(shouldFail: false)...');
  final repo = const MockTaskRepository(shouldFail: false);
  final now = DateTime.now();

  try {
    final tasks = await repo.fetchTasks();
    print('-> Succès : ${tasks.length} tâches chargées avec succès :\n');

    for (final task in tasks) {
      final statut = task.done
          ? '[FAIT]'
          : (task.isOverdue(now) ? '[EN RETARD]' : '[À FAIRE]');
      print('  $statut #${task.id} : ${task.title}');
      print('      Échéance : ${task.dueDate.toIso8601String()}');
      if (task.description != null) {
        print('      Description : ${task.description}');
      }
    }
  } catch (e) {
    print('-> Erreur inattendue : $e');
  }

  print('\n----------------------------------------------------\n');

  // 2. Appel en mode erreur avec try / catch
  print('[2] Test de gestion d\'erreur via MockTaskRepository(shouldFail: true)...');
  final errorRepo = const MockTaskRepository(shouldFail: true);

  try {
    await errorRepo.fetchTasks();
    print('-> Échec du test : aucune exception levée.');
  } catch (e) {
    print('-> Exception correctement interceptée dans le bloc catch :');
    print('   Message : $e');
  }

  print('\n=== Fin de la démonstration ===');
}
