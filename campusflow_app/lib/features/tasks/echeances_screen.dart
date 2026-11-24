import 'package:flutter/material.dart';
import 'package:campusflow_models/campusflow_models.dart';

import 'data/sample_tasks.dart';
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
