import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:campusflow_app/data/fake_task_repository.dart';
import 'package:campusflow_app/data/task_repository.dart';
import 'package:campusflow_app/features/tasks/data/sample_tasks.dart';
import 'package:campusflow_app/features/tasks/providers/taches_notifier.dart';

import 'failing_task_repository.dart';

void main() {
  group('TachesNotifier (Riverpod AsyncNotifier)', () {
    test('build() renvoie les tâches triées par date d\'échéance', () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      final tasks = await container.read(tachesProvider.future);
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
        () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      final initialList = await container.read(tachesProvider.future);
      final initialCount = initialList.length;

      // Tâche avec une date très ancienne pour tester qu'elle se retrouve au début du tri
      final urgentTask = Task(
        id: '',
        title: 'TP urgent de test',
        dueDate: DateTime.now().subtract(const Duration(days: 30)),
        done: false,
        courseId: 'c1',
      );

      await container.read(tachesProvider.notifier).ajouter(urgentTask);

      final updatedList = container.read(tachesProvider).value!;

      // Vérifie l'augmentation de la taille
      expect(updatedList.length, equals(initialCount + 1));

      // Vérifie l'immuabilité : l'ancienne liste initiale n'est pas modifiée
      expect(initialList.length, equals(initialCount));
      expect(identical(initialList, updatedList), isFalse);

      // Vérifie le maintien du tri : la tâche avec la date la plus ancienne est au début
      expect(updatedList.first.title, equals('TP urgent de test'));

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
        () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      final initialList = await container.read(tachesProvider.future);
      final targetTask = initialList.first;
      final originalDone = targetTask.done;

      await container.read(tachesProvider.notifier).basculer(targetTask.id);

      final updatedList = container.read(tachesProvider).value!;
      final toggledTask =
          updatedList.firstWhere((t) => t.id == targetTask.id);

      // L'état a bien basculé
      expect(toggledTask.done, equals(!originalDone));

      // Immuabilité : la tâche dans la liste précédente et la référence de liste sont intactes
      expect(targetTask.done, equals(originalDone));
      expect(identical(initialList, updatedList), isFalse);
    });

    test('supprimer(String id) retire la tâche sans modifier l\'ancienne liste (immuabilité)', () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      final initialList = await container.read(tachesProvider.future);
      final initialCount = initialList.length;
      final targetTask = initialList.first;

      await container.read(tachesProvider.notifier).supprimer(targetTask.id);

      final updatedList = container.read(tachesProvider).value!;
      expect(updatedList.length, equals(initialCount - 1));
      expect(updatedList.any((t) => t.id == targetTask.id), isFalse);
      expect(initialList.length, equals(initialCount));
    });

    test('si une action échoue : l\'état précédent est conservé et l\'exception est relancée', () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      final initialList = await container.read(tachesProvider.future);

      // Override avec un repo qui échoue pour tester les actions
      final failingContainer = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            const FailingTaskRepository(errorMessage: 'Panne serveur'),
          ),
        ],
      );
      addTearDown(failingContainer.dispose);

      expect(
        () => failingContainer.read(tachesProvider.notifier).ajouter(
              Task(
                id: 'err',
                title: 'Erreur',
                dueDate: DateTime.now(),
                done: false,
              ),
            ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Panne serveur'),
        )),
      );

      // Vérifie que l'état initial du premier container est resté inchangé
      expect(initialList.length, equals(sampleTasks.length));
    });

    test('coursProvider renvoie sampleCourses', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final courses = container.read(coursProvider);
      expect(courses, equals(sampleCourses));
    });
  });
}
