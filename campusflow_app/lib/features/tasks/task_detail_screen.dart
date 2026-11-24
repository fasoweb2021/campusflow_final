import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:go_router/go_router.dart';

import 'providers/taches_notifier.dart';
import 'widgets/task_detail_view.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String? taskId;
  final Task? task;
  final List<Course>? courses;

  const TaskDetailScreen({
    super.key,
    this.taskId,
    this.task,
    this.courses,
  });

  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Supprimer cette tâche ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(tachesProvider.notifier).supprimer(id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tâche supprimée')),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/taches');
        }
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(tachesProvider);
    final List<Course> availableCourses = courses ?? ref.watch(coursProvider);

    return asyncTasks.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Détail')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Détail')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.0,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16.0),
                Text(
                  err.toString().replaceFirst('Exception: ', ''),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
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
      ),
      data: (tasks) {
        Task? effectiveTask = task;
        if (taskId != null) {
          for (final t in tasks) {
            if (t.id == taskId) {
              effectiveTask = t;
              break;
            }
          }
        }

        if (effectiveTask == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Détail'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 64.0,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Tâche introuvable',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24.0),
                    FilledButton(
                      onPressed: () => context.go('/taches'),
                      child: const Text('Retour aux échéances'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        Course? course;
        if (effectiveTask.courseId != null) {
          for (final c in availableCourses) {
            if (c.id == effectiveTask.courseId) {
              course = c;
              break;
            }
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Détail'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Supprimer',
                onPressed: () =>
                    _confirmAndDelete(context, ref, effectiveTask!.id),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TaskDetailView(
                        task: effectiveTask,
                        course: course,
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: effectiveTask.done
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(tachesProvider.notifier)
                                  .basculer(effectiveTask!.id);
                              if (!context.mounted) return;
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/taches');
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erreur : $e'),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
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
        );
      },
    );
  }
}
