import 'package:flutter/material.dart';
import 'package:campusflow_models/campusflow_models.dart';

import 'data/sample_tasks.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';
import 'widgets/task_detail_view.dart';
import 'widgets/task_tile.dart';

/// Seuil de largeur responsive (en dp) pour la mise en page adaptative tablette
const double kExpandedBreakpoint = 840.0;

class EcheancesScreen extends StatefulWidget {
  const EcheancesScreen({super.key});

  @override
  State<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends State<EcheancesScreen> {
  late List<Task> _tasks;
  String? _selectedTaskId;
  int _selectedNavigationIndex = 0;

  @override
  void initState() {
    super.initState();
    _tasks = getSampleTasks()..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void _toggleTask(String taskId) {
    setState(() {
      _tasks = [
        for (final task in _tasks)
          if (task.id == taskId) task.copyWith(done: !task.done) else task,
      ];
    });
  }

  void _markTaskDone(String taskId) {
    setState(() {
      _tasks = [
        for (final task in _tasks)
          if (task.id == taskId) task.copyWith(done: true) else task,
      ];
    });
  }

  Future<void> _openDetail(Task task) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          courses: sampleCourses,
        ),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        _tasks = [
          for (final t in _tasks)
            if (t.id == updatedTask.id) updatedTask else t,
        ];
        _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      });
    }
  }

  Future<void> _openAddTaskForm() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(courses: sampleCourses),
      ),
    );

    if (newTask != null) {
      setState(() {
        _tasks = [..._tasks, newTask];
        _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        _selectedTaskId = newTask.id;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tâche ajoutée'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Échéances'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isExpanded = constraints.maxWidth >= kExpandedBreakpoint;

          // Mode Compact (< 840 dp) : liste simple, tap ouvre TaskDetailScreen
          if (!isExpanded) {
            return ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final course = task.courseId != null
                    ? sampleCoursesMap[task.courseId]
                    : null;

                return TaskTile(
                  task: task,
                  course: course,
                  onToggle: () => _toggleTask(task.id),
                  onTap: () => _openDetail(task),
                );
              },
            );
          }

          // Mode Élargi (>= 840 dp, Tablette) : liste (flex 2) + détail (flex 3) côte à côte
          Task? selectedTask;
          if (_selectedTaskId != null) {
            for (final t in _tasks) {
              if (t.id == _selectedTaskId) {
                selectedTask = t;
                break;
              }
            }
          }

          final selectedCourse = selectedTask?.courseId != null
              ? sampleCoursesMap[selectedTask!.courseId]
              : null;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colonne gauche : liste des tâches (flex 2)
              Expanded(
                flex: 2,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final course = task.courseId != null
                        ? sampleCoursesMap[task.courseId]
                        : null;

                    return TaskTile(
                      task: task,
                      course: course,
                      isSelected: task.id == _selectedTaskId,
                      onToggle: () => _toggleTask(task.id),
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
                                  : () => _markTaskDone(selectedTask!.id),
                              child: const Text('Marquer comme fait'),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskForm,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavigationIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            _selectedNavigationIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment),
            label: 'Échéances',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
