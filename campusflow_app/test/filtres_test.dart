import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusflow_app/data/fake_task_repository.dart';
import 'package:campusflow_app/data/task_repository.dart';
import 'package:campusflow_app/features/tasks/providers/filtres.dart';
import 'package:campusflow_app/features/tasks/providers/taches_notifier.dart';

void main() {
  group('Filtres et compteurs (Riverpod asynchrone)', () {
    test('les compteurs valent 0 pendant le chargement', () {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: const Duration(seconds: 10)),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Avant l'attente du future, le provider est en chargement
      final compteurs = container.read(compteursProvider);
      expect(compteurs[FiltreTaches.aFaire], equals(0));
      expect(compteurs[FiltreTaches.faites], equals(0));
      expect(compteurs[FiltreTaches.enRetard], equals(0));
    });

    test('chaque filtre renvoie les bonnes tâches', () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(tachesProvider.future);

      // 1. Filtre par défaut : aFaire
      expect(container.read(filtreProvider), equals(FiltreTaches.aFaire));
      final tasksAFaire = container.read(tachesFiltreesProvider).value!;
      expect(tasksAFaire.isNotEmpty, isTrue);
      expect(tasksAFaire.every((t) => !t.done), isTrue);

      // 2. Filtre : faites
      container.read(filtreProvider.notifier).choisir(FiltreTaches.faites);
      expect(container.read(filtreProvider), equals(FiltreTaches.faites));
      final tasksFaites = container.read(tachesFiltreesProvider).value!;
      expect(tasksFaites.isNotEmpty, isTrue);
      expect(tasksFaites.every((t) => t.done), isTrue);

      // 3. Filtre : enRetard
      container.read(filtreProvider.notifier).choisir(FiltreTaches.enRetard);
      expect(container.read(filtreProvider), equals(FiltreTaches.enRetard));
      final tasksEnRetard = container.read(tachesFiltreesProvider).value!;
      expect(tasksEnRetard.isNotEmpty, isTrue);
      final now = DateTime.now();
      expect(tasksEnRetard.every((t) => t.isOverdue(now)), isTrue);
    });

    test('les compteurs correspondent exactement aux nombres de tâches par statut',
        () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      final allTasks = await container.read(tachesProvider.future);
      final compteurs = container.read(compteursProvider);
      final now = DateTime.now();

      final expectedAFaire = allTasks.where((t) => !t.done).length;
      final expectedFaites = allTasks.where((t) => t.done).length;
      final expectedEnRetard = allTasks.where((t) => t.isOverdue(now)).length;

      expect(compteurs[FiltreTaches.aFaire], equals(expectedAFaire));
      expect(compteurs[FiltreTaches.faites], equals(expectedFaites));
      expect(compteurs[FiltreTaches.enRetard], equals(expectedEnRetard));
    });

    test('basculer une tâche met à jour les compteurs de manière réactive',
        () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeTaskRepository(delay: Duration.zero),
          ),
        ],
      );
      addTearDown(container.dispose);

      final allTasks = await container.read(tachesProvider.future);
      final initialCompteurs = container.read(compteursProvider);
      final initialAFaire = initialCompteurs[FiltreTaches.aFaire]!;
      final initialFaites = initialCompteurs[FiltreTaches.faites]!;

      // Trouve une tâche non faite dans la liste
      final taskAFaire = allTasks.firstWhere((t) => !t.done);

      // Bascule la tâche non faite -> faite
      await container.read(tachesProvider.notifier).basculer(taskAFaire.id);

      final updatedCompteurs = container.read(compteursProvider);
      expect(updatedCompteurs[FiltreTaches.aFaire], equals(initialAFaire - 1));
      expect(updatedCompteurs[FiltreTaches.faites], equals(initialFaites + 1));
    });
  });
}
