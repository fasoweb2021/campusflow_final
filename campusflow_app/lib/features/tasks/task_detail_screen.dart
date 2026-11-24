import 'package:flutter/material.dart';
import 'package:campusflow_models/campusflow_models.dart';

import 'widgets/task_detail_view.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final List<Course> courses;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    Course? course;
    if (task.courseId != null) {
      for (final c in courses) {
        if (c.id == task.courseId) {
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
                    task: task,
                    course: course,
                  ),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: task.done
                    ? null
                    : () {
                        Navigator.pop(
                          context,
                          task.copyWith(done: true),
                        );
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
