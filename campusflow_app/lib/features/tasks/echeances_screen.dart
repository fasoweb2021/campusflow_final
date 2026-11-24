import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:go_router/go_router.dart';

import 'data/sample_tasks.dart';
import 'providers/filtres.dart';
import 'providers/taches_notifier.dart';
import 'widgets/task_detail_view.dart';
import 'widgets/task_tile.dart';

/// Seuil de largeur responsive (en dp) pour la mise en page adaptative tablette
const double kExpandedBreakpoint = 840.0;

class EcheancesScreen extends ConsumerStatefulWidget {
  const EcheancesScreen({super.key});

  @override
  ConsumerState<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends ConsumerState<EcheancesScreen> {
  String? _selectedTaskId;

  void _openDetail(Task task) {
    context.push('/taches/${task.id}');
  }

  void _openAddTaskForm() {
    context.push('/taches/nouvelle');
  }

  String _getEmptyMessage(FiltreTaches filtre) {
    switch (filtre) {
      case FiltreTaches.aFaire:
        return 'Aucune tâche à faire 🎉';
      case FiltreTaches.faites:
        return 'Aucune tâche terminée';
      case FiltreTaches.enRetard:
        return 'Aucune tâche en retard 🎉';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Lecture des providers Riverpod pour les filtres, tâches filtrées et compteurs
    final filtre = ref.watch(filtreProvider);
    final filteredTasks = ref.watch(tachesFiltreesProvider);
    final compteurs = ref.watch(compteursProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= kExpandedBreakpoint;

        // Tâche sélectionnée en mode large (doit appartenir à la liste filtrée)
        Task? selectedTask;
        if (_selectedTaskId != null) {
          for (final t in filteredTasks) {
            if (t.id == _selectedTaskId) {
              selectedTask = t;
              break;
            }
          }
        }

        final selectedCourse = selectedTask?.courseId != null
            ? sampleCoursesMap[selectedTask!.courseId]
            : null;

        Widget buildFilterSelector() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<FiltreTaches>(
                showSelectedIcon: false,
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                segments: [
                  ButtonSegment<FiltreTaches>(
                    value: FiltreTaches.aFaire,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'À faire (${compteurs[FiltreTaches.aFaire] ?? 0})',
                      ),
                    ),
                  ),
                  ButtonSegment<FiltreTaches>(
                    value: FiltreTaches.faites,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Faites (${compteurs[FiltreTaches.faites] ?? 0})',
                      ),
                    ),
                  ),
                  ButtonSegment<FiltreTaches>(
                    value: FiltreTaches.enRetard,
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'En retard (${compteurs[FiltreTaches.enRetard] ?? 0})',
                      ),
                    ),
                  ),
                ],
                selected: {filtre},
                onSelectionChanged: (newSelection) {
                  ref.read(filtreProvider.notifier).choisir(newSelection.first);
                },
              ),
            ),
          );
        }

        Widget buildTaskList() {
          if (filteredTasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _getEmptyMessage(filtre),
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              final course = task.courseId != null
                  ? sampleCoursesMap[task.courseId]
                  : null;

              return TaskTile(
                task: task,
                course: course,
                isSelected: task.id == _selectedTaskId,
                onToggle: () =>
                    ref.read(tachesProvider.notifier).basculer(task.id),
                onTap: isExpanded
                    ? () {
                        setState(() {
                          _selectedTaskId = task.id;
                        });
                      }
                    : () => _openDetail(task),
              );
            },
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Échéances'),
            actions: isExpanded
                ? [
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'Nouvelle tâche',
                      onPressed: _openAddTaskForm,
                    ),
                  ]
                : null,
          ),
          body: isExpanded
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Colonne gauche : sélecteur de filtres + liste des tâches filtrées (flex 2)
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          buildFilterSelector(),
                          Expanded(child: buildTaskList()),
                        ],
                      ),
                    ),

                    const VerticalDivider(width: 1.0),

                    // Colonne droite : panneau de détail (flex 3)
                    Expanded(
                      flex: 3,
                      child: selectedTask == null
                          ? Center(
                              child: Text(
                                'Sélectionnez une tâche',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TaskDetailView(
                                            task: selectedTask,
                                            course: selectedCourse,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  FilledButton(
                                    onPressed: selectedTask.done
                                        ? null
                                        : () => ref
                                            .read(tachesProvider.notifier)
                                            .basculer(selectedTask!.id),
                                    child: const Text('Marquer comme fait'),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    buildFilterSelector(),
                    Expanded(child: buildTaskList()),
                  ],
                ),
          floatingActionButton: isExpanded
              ? null
              : FloatingActionButton(
                  onPressed: _openAddTaskForm,
                  child: const Icon(Icons.add),
                ),
        );
      },
    );
  }
}
