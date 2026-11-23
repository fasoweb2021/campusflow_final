import 'package:campusflow_models/campusflow_models.dart';
import 'package:test/test.dart';

void main() {
  group('Modèle Task', () {
    // 1. copyWith change done sans modifier les autres champs ni l'original
    test('copyWith change done sans modifier les autres champs ni l\'original', () {
      final original = Task(
        id: 'task-1',
        title: 'Devoir de Programmation Mobile',
        description: 'Implémenter les modèles immuables.',
        dueDate: DateTime.utc(2026, 11, 25, 18, 0),
        done: false,
        courseId: 'course-mobile',
      );

      final copy = original.copyWith(done: true);

      // Vérification des modifications sur la copie
      expect(copy.done, isTrue);
      expect(copy.id, equals(original.id));
      expect(copy.title, equals(original.title));
      expect(copy.description, equals(original.description));
      expect(copy.dueDate, equals(original.dueDate));
      expect(copy.courseId, equals(original.courseId));

      // Vérification stricte de l'immuabilité de l'original
      expect(original.done, isFalse);
    });

    // 2. Task.fromJson construit correctement une tâche
    test('Task.fromJson construit correctement une tâche (id numérique converti et date ISO 8601)', () {
      final json = {
        'id': 42, // Identifiant numérique volontaire
        'title': 'Rapport d\'algorithmique',
        'description': 'Arbres équilibrés et complexité',
        'dueDate': '2026-11-28T14:30:00.000Z',
        'done': false,
        'courseId': 'course-algo',
      };

      final task = Task.fromJson(json);

      expect(task.id, equals('42'));
      expect(task.title, equals('Rapport d\'algorithmique'));
      expect(task.description, equals('Arbres équilibrés et complexité'));
      expect(task.dueDate, equals(DateTime.parse('2026-11-28T14:30:00.000Z')));
      expect(task.done, isFalse);
      expect(task.courseId, equals('course-algo'));
    });

    // 3. Task.fromJson sans "title" lève une FormatException
    test('Task.fromJson sans "title" lève une FormatException', () {
      final jsonSansTitre = {
        'id': '1',
        'dueDate': '2026-11-28T14:30:00.000Z',
      };

      expect(() => Task.fromJson(jsonSansTitre), throwsFormatException);

      final jsonTitreVide = {
        'id': '1',
        'title': '   ',
        'dueDate': '2026-11-28T14:30:00.000Z',
      };

      expect(() => Task.fromJson(jsonTitreVide), throwsFormatException);
    });

    // 4. Test toJson -> fromJson qui redonne une tâche équivalente
    test('toJson -> fromJson redonne une tâche équivalente', () {
      final taskInitiale = Task(
        id: 'task-99',
        title: 'Préparer l\'exposé réseau',
        description: 'Diapositives sur le routage BGP.',
        dueDate: DateTime.utc(2026, 12, 1, 10, 0),
        done: true,
        courseId: 'course-reseau',
      );

      final json = taskInitiale.toJson();
      final taskReconstruite = Task.fromJson(json);

      expect(taskReconstruite, equals(taskInitiale));
      expect(taskReconstruite.id, equals(taskInitiale.id));
      expect(taskReconstruite.title, equals(taskInitiale.title));
      expect(taskReconstruite.description, equals(taskInitiale.description));
      expect(taskReconstruite.dueDate, equals(taskInitiale.dueDate));
      expect(taskReconstruite.done, equals(taskInitiale.done));
      expect(taskReconstruite.courseId, equals(taskInitiale.courseId));
    });

    test('isOverdue retourne true pour une tâche non faite échue', () {
      final now = DateTime.utc(2026, 11, 23, 12, 0);
      final taskEnRetard = Task(
        id: '1',
        title: 'TP dépassé',
        dueDate: DateTime.utc(2026, 11, 22, 12, 0),
        done: false,
      );
      final taskFaite = Task(
        id: '2',
        title: 'TP fait',
        dueDate: DateTime.utc(2026, 11, 22, 12, 0),
        done: true,
      );

      expect(taskEnRetard.isOverdue(now), isTrue);
      expect(taskFaite.isOverdue(now), isFalse);
    });
  });

  group('Dépôt MockTaskRepository', () {
    // 5. MockTaskRepository(shouldFail: true).fetchTasks() lève une Exception
    test('MockTaskRepository(shouldFail: true).fetchTasks() lève une Exception', () async {
      const repo = MockTaskRepository(shouldFail: true);

      await expectLater(
        repo.fetchTasks(),
        throwsException,
      );
    });

    test('MockTaskRepository(shouldFail: false).fetchTasks() retourne les tâches simulées', () async {
      const repo = MockTaskRepository(shouldFail: false);
      final tasks = await repo.fetchTasks();

      expect(tasks, isNotEmpty);
      expect(tasks.length, equals(6));
    });
  });
}
