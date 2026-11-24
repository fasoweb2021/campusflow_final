import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'taches_notifier.dart';

enum FiltreTaches { aFaire, faites, enRetard }

final filtreProvider =
    NotifierProvider<FiltreNotifier, FiltreTaches>(FiltreNotifier.new);

class FiltreNotifier extends Notifier<FiltreTaches> {
  @override
  FiltreTaches build() => FiltreTaches.aFaire;

  void choisir(FiltreTaches f) {
    state = f;
  }
}

/// Liste filtrée dérivée de l'AsyncValue de [tachesProvider] via [whenData].
final tachesFiltreesProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final asyncTasks = ref.watch(tachesProvider);
  final filtre = ref.watch(filtreProvider);
  final now = DateTime.now();

  return asyncTasks.whenData((tasks) {
    switch (filtre) {
      case FiltreTaches.aFaire:
        return tasks.where((t) => !t.done).toList();
      case FiltreTaches.faites:
        return tasks.where((t) => t.done).toList();
      case FiltreTaches.enRetard:
        return tasks.where((t) => t.isOverdue(now)).toList();
    }
  });
});

/// Compteurs par statut dérivés de l'AsyncValue ; valent 0 pendant le chargement.
final compteursProvider = Provider<Map<FiltreTaches, int>>((ref) {
  final asyncTasks = ref.watch(tachesProvider);
  final now = DateTime.now();

  return asyncTasks.whenData((tasks) {
    int aFaire = 0;
    int faites = 0;
    int enRetard = 0;

    for (final t in tasks) {
      if (!t.done) aFaire++;
      if (t.done) faites++;
      if (t.isOverdue(now)) enRetard++;
    }

    return {
      FiltreTaches.aFaire: aFaire,
      FiltreTaches.faites: faites,
      FiltreTaches.enRetard: enRetard,
    };
  }).value ??
      {
        FiltreTaches.aFaire: 0,
        FiltreTaches.faites: 0,
        FiltreTaches.enRetard: 0,
      };
});
