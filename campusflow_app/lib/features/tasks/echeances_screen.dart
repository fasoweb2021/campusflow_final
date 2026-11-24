import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:go_router/go_router.dart';

import 'data/sample_tasks.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Lecture de la liste partagée des tâches via Riverpod
    final tasks = ref.watch(tachesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= kExpandedBreakpoint;

        // Tâche sélectionnée en mode large
        Task? selectedTask;
        if (_selectedTaskId != null) {
          for (final t in tasks) {
            if (t.id == _selectedTaskId) {
              selectedTask = t;
              break;
            }
          }
        }

        final selectedCourse = selectedTask?.courseId != null
            ? sampleCoursesMap[selectedTask!.courseId]
            : null;

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
                    // Colonne gauche : liste des tâches (flex 2)
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final course = task.courseId != null
                              ? sampleCoursesMap[task.courseId]
                              : null;

                          return TaskTile(
                            task: task,
                            course: course,
                            isSelected: task.id == _selectedTaskId,
                            onToggle: () => ref
                                .read(tachesProvider.notifier)
                                .basculer(task.id),
                            onTap: () {
                              setState(() {
                                _selectedTaskId = task.id;
                              });
                            },
                          );
                        },
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
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final course = task.courseId != null
                        ? sampleCoursesMap[task.courseId]
                        : null;

                    return TaskTile(
                      task: task,
                      course: course,
                      onToggle: () => ref
                          .read(tachesProvider.notifier)
                          .basculer(task.id),
                      onTap: () => _openDetail(task),
                    );
                  },
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
