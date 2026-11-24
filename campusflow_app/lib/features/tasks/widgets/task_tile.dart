import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:campusflow_models/campusflow_models.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Course? course;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.task,
    this.course,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isOverdue = task.isOverdue(DateTime.now());
    final formattedDate =
        DateFormat('d MMM yyyy', 'fr_FR').format(task.dueDate);

    // Couleurs selon l'état de la tâche
    final borderColor = isOverdue
        ? colorScheme.error
        : colorScheme.outlineVariant;
    final dateColor = isOverdue
        ? colorScheme.error
        : colorScheme.onSurfaceVariant;
    final titleColor = task.done
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: borderColor,
          width: isOverdue ? 2.0 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap ?? onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Case à cocher tactile >= 48x48 dp
              SizedBox(
                width: 48.0,
                height: 48.0,
                child: Checkbox(
                  value: task.done,
                  onChanged: (_) => onToggle?.call(),
                ),
              ),
              const SizedBox(width: 8.0),
              // Contenu principal : Titre + Cours (ligne 1) + Date et badge (ligne 2)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: titleColor,
                        decoration:
                            task.done ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (course != null) ...[
                      const SizedBox(height: 4.0),
                      Text(
                        course!.name,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          formattedDate,
                          style: textTheme.bodySmall?.copyWith(
                            color: dateColor,
                            fontWeight: isOverdue
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        if (isOverdue) ...[
                          const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              'EN RETARD',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.error,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
