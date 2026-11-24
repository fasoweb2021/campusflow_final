import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:campusflow_app/features/tasks/data/sample_tasks.dart';
import 'package:campusflow_app/features/tasks/providers/taches_notifier.dart';

void main() {
  group('TachesNotifier (Riverpod)', () {
    test('build() renvoie sampleTasks triées par date d\'échéance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final tasks = container.read(tachesProvider);
      expect(tasks.length, equals(sampleTasks.length));

      for (var i = 0; i < tasks.length - 1; i++) {
        expect(
          tasks[i].dueDate.isBefore(tasks[i + 1].dueDate) ||
              tasks[i].dueDate.isAtSameMomentAs(tasks[i + 1].dueDate),
          isTrue,
        );
      }
    });

    test(
        'ajouter(Task t) augmente la liste, conserve le tri et n\'altère pas la liste précédente (immuabilité)',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialList = container.read(tachesProvider);
      final initialCount = initialList.length;

      // Tâche avec une date très ancienne pour tester qu'elle se retrouve au début du tri
      final urgentTask = Task(
        id: 't_nouvelle_urgente',
        title: 'TP urgent de test',
        dueDate: DateTime.now().subtract(const Duration(days: 30)),
        done: false,
        courseId: 'c1',
      );

      container.read(tachesProvider.notifier).ajouter(urgentTask);

      final updatedList = container.read(tachesProvider);

      // Vérifie l'augmentation de la taille
      expect(updatedList.length, equals(initialCount + 1));

      // Vérifie l'immuabilité : l'ancienne liste initiale n'est pas modifiée
      expect(initialList.length, equals(initialCount));
      expect(identical(initialList, updatedList), isFalse);

      // Vérifie le maintien du tri : la tâche avec la date la plus ancienne est au début
      expect(updatedList.first.id, equals('t_nouvelle_urgente'));

      // Vérifie que toutes les échéances restent bien ordonnées
      for (var i = 0; i < updatedList.length - 1; i++) {
        expect(
          updatedList[i].dueDate.isBefore(updatedList[i + 1].dueDate) ||
              updatedList[i].dueDate.isAtSameMomentAs(updatedList[i + 1].dueDate),
          isTrue,
        );
      }
    });

    test(
        'basculer(String id) bascule le statut done sans modifier l\'ancienne liste (immuabilité)',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialList = container.read(tachesProvider);
      final targetTask = initialList.first;
      final originalDone = targetTask.done;

      container.read(tachesProvider.notifier).basculer(targetTask.id);

      final updatedList = container.read(tachesProvider);
      final toggledTask =
          updatedList.firstWhere((t) => t.id == targetTask.id);

      // L'état a bien basculé
      expect(toggledTask.done, equals(!originalDone));

      // Immuabilité : la tâche dans la liste précédente et la référence de liste sont intactes
      expect(targetTask.done, equals(originalDone));
      expect(identical(initialList, updatedList), isFalse);
    });

    test('coursProvider renvoie sampleCourses', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final courses = container.read(coursProvider);
      expect(courses, equals(sampleCourses));
    });
  });
}

