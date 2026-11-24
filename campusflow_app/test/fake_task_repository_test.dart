import 'package:campusflow_app/data/fake_task_repository.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeTaskRepository', () {
    late FakeTaskRepository repository;

    setUp(() {
      repository = FakeTaskRepository(
        initialTasks: [
          Task(
            id: '1',
            title: 'Tâche existante',
            description: 'Description 1',
            dueDate: DateTime(2026, 12, 1),
            done: false,
            courseId: 'c1',
          ),
        ],
        delay: Duration.zero,
      );
    });

    test('create puis fetchAll contient la tâche ajoutée', () async {
      final newTask = Task(
        id: '2',
        title: 'Nouvelle tâche de test',
        description: 'Description de test',
        dueDate: DateTime(2026, 12, 15),
        done: false,
        courseId: 'c2',
      );

      final created = await repository.create(newTask);
      expect(created.id, equals('2'));
      expect(created.title, equals('Nouvelle tâche de test'));

      final allTasks = await repository.fetchAll();
      expect(allTasks.length, equals(2));
      expect(
        allTasks.any((t) => t.id == '2' && t.title == 'Nouvelle tâche de test'),
        isTrue,
      );
    });

    test('toggleDone met à jour le statut done de la tâche', () async {
      final initialTasks = await repository.fetchAll();
      expect(initialTasks.first.done, isFalse);

      final updated = await repository.toggleDone('1', true);
      expect(updated.done, isTrue);

      final tasksAfterToggle = await repository.fetchAll();
      expect(tasksAfterToggle.first.done, isTrue);

      final toggledBack = await repository.toggleDone('1', false);
      expect(toggledBack.done, isFalse);
    });

    test('delete supprime la tâche du repository', () async {
      final initialTasks = await repository.fetchAll();
      expect(initialTasks.length, equals(1));

      await repository.delete('1');

      final tasksAfterDelete = await repository.fetchAll();
      expect(tasksAfterDelete.isEmpty, isTrue);
      expect(tasksAfterDelete.any((t) => t.id == '1'), isFalse);
    });

    test('toggleDone ou delete avec un id inexistant lance une exception en français', () async {
      expect(
        () => repository.toggleDone('999', true),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('introuvable'),
          ),
        ),
      );

      expect(
        () => repository.delete('999'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('introuvable'),
          ),
        ),
      );
    });
  });
}

