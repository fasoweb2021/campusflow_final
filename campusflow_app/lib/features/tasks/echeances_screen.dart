import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:go_router/go_router.dart';

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

  Future<void> _handleDeleteTask(BuildContext context, Task task) async {
    try {
      await ref.read(tachesProvider.notifier).supprimer(task.id);
      if (_selectedTaskId == task.id) {
        setState(() {
          _selectedTaskId = null;
        });
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tâche supprimée')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression : $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Lecture des providers Riverpod pour les filtres, tâches et compteurs
    final filtre = ref.watch(filtreProvider);
    final asyncFilteredTasks = ref.watch(tachesFiltreesProvider);
    final compteurs = ref.watch(compteursProvider);
    final courses = ref.watch(coursProvider);
    final coursesMap = {for (final c in courses) c.id: c};

    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= kExpandedBreakpoint;

        // Tâche sélectionnée en mode large (doit appartenir à la liste filtrée)
        Task? selectedTask;
        final currentFilteredList = asyncFilteredTasks.value ?? [];
        if (_selectedTaskId != null) {
          for (final t in currentFilteredList) {
            if (t.id == _selectedTaskId) {
              selectedTask = t;
              break;
            }
          }
        }

        final selectedCourse = selectedTask?.courseId != null
            ? coursesMap[selectedTask!.courseId]
            : null;

        Widget buildFilterSelector() {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          return asyncFilteredTasks.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.0,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      err.toString().replaceFirst('Exception: ', ''),
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(tachesProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),
            data: (tasks) {
              return RefreshIndicator(
                onRefresh: () => ref.refresh(tachesProvider.future),
                child: tasks.isEmpty
                    ? LayoutBuilder(
                        builder: (context, viewport) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: viewport.maxHeight,
                            ),
                            child: Center(
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
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final course = task.courseId != null
                              ? coursesMap[task.courseId]
                              : null;

                          return Dismissible(
                            key: Key(task.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              color: colorScheme.errorContainer,
                              child: Icon(
                                Icons.delete_outline,
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Confirmation'),
                                  content:
                                      const Text('Supprimer cette tâche ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(false),
                                      child: const Text('Annuler'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(true),
                                      child: const Text('Supprimer'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              _handleDeleteTask(context, task);
                            },
                            child: TaskTile(
                              task: task,
                              course: course,
                              isSelected: task.id == _selectedTaskId,
                              onToggle: () async {
                                try {
                                  await ref
                                      .read(tachesProvider.notifier)
                                      .basculer(task.id);
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erreur : $e'),
                                      backgroundColor: colorScheme.error,
                                    ),
                                  );
                                }
                              },
                              onTap: isExpanded
                                  ? () {
                                      setState(() {
                                        _selectedTaskId = task.id;
                                      });
                                    }
                                  : () => _openDetail(task),
                            ),
                          );
                        },
                      ),
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
                                        : () async {
                                            try {
                                              await ref
                                                  .read(
                                                      tachesProvider.notifier)
                                                  .basculer(selectedTask!.id);
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text('Erreur : $e'),
                                                  backgroundColor:
                                                      colorScheme.error,
                                                ),
                                              );
                                            }
                                          },
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
