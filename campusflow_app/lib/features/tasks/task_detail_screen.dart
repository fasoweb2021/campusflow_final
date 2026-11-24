import 'package:flutter/material.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:go_router/go_router.dart';

import 'data/sample_tasks.dart';
import 'widgets/task_detail_view.dart';

class TaskDetailScreen extends StatelessWidget {
  final String? taskId;
  final Task? task;
  final List<Course> courses;

  const TaskDetailScreen({
    super.key,
    this.taskId,
    this.task,
    this.courses = sampleCourses,
  });

  @override
  Widget build(BuildContext context) {
    Task? effectiveTask = task;
    if (effectiveTask == null && taskId != null) {
      for (final t in sampleTasks) {
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
      for (final c in courses) {
        if (c.id == effectiveTask.courseId) {
          course = c;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail'),
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
                    : () {
                        context.pop(effectiveTask!.copyWith(done: true));
                      },
                child: const Text('Marquer comme fait'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
