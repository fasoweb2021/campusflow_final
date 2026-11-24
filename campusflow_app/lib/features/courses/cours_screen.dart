import 'package:flutter/material.dart';

import '../tasks/data/sample_tasks.dart';

class CoursScreen extends StatelessWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cours'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        itemCount: sampleCourses.length,
        itemBuilder: (context, index) {
          final course = sampleCourses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                child: Text(
                  course.name.isNotEmpty ? course.name.substring(0, 1) : 'C',
                  style: textTheme.titleMedium,
                ),
              ),
              title: Text(
                course.name,
                style: textTheme.titleMedium,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16.0,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          course.teacher,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (course.room != null) ...[
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.room_outlined,
                            size: 16.0,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            course.room!,
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

