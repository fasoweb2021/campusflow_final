import 'package:flutter/material.dart';
import 'package:campusflow_models/campusflow_models.dart';

import 'data/sample_tasks.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';
import 'widgets/task_tile.dart';

class EcheancesScreen extends StatefulWidget {
  const EcheancesScreen({super.key});

  @override
  State<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends State<EcheancesScreen> {
  late List<Task> _tasks;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Échéances'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
