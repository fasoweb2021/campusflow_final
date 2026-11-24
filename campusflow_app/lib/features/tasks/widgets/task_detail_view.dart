import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:campusflow_models/campusflow_models.dart';

class TaskDetailView extends StatelessWidget {
  final Task task;
  final Course? course;

  const TaskDetailView({
    super.key,
    required this.task,
    this.course,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isOverdue = task.isOverdue(DateTime.now());
    final formattedDate =
        DateFormat('EEEE d MMMM yyyy à HH:mm', 'fr_FR').format(task.dueDate);

    final String statusText;
    final Color statusColor;
    if (task.done) {
      statusText = 'Faite';
      statusColor = colorScheme.primary;
    } else if (isOverdue) {
      statusText = 'En retard';
      statusColor = colorScheme.error;
    } else {
      statusText = 'À faire';
      statusColor = colorScheme.onSurfaceVariant;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          task.title,
          style: textTheme.headlineSmall,
        ),
        if (course != null) ...[
          const SizedBox(height: 12.0),
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 18.0,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  course!.name,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12.0),
        Row(
          children: [
            Icon(
              Icons.event_outlined,
              size: 18.0,
              color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Échéance : $formattedDate',
                style: textTheme.bodySmall?.copyWith(
                  color: isOverdue ? colorScheme.error : colorScheme.onSurfaceVariant,
                  fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          'Description',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 4.0),
        Text(
          (task.description != null && task.description!.trim().isNotEmpty)
              ? task.description!
              : 'Aucune description',
          style: textTheme.bodyMedium?.copyWith(
            color: (task.description != null && task.description!.trim().isNotEmpty)
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Text(
              'Statut : ',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                statusText,
                style: textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
