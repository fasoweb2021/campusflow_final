import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:campusflow_models/campusflow_models.dart';

import 'data/sample_tasks.dart';
import 'providers/taches_notifier.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final List<Course> courses;

  const TaskFormScreen({
    super.key,
    this.courses = sampleCourses,
  });

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCourseId;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Date d'échéance par défaut = demain
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        dueDate: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          23,
          59,
        ),
        done: false,
        courseId: _selectedCourseId,
      );

      // Ajout de la tâche via Riverpod
      ref.read(tachesProvider.notifier).ajouter(newTask);

      // Affichage du SnackBar avant de fermer l'écran
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tâche ajoutée'),
        ),
      );

      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/taches');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final formattedDate =
        DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_selectedDate);

    // Si courses n'a pas été passé explicitement, utilise coursProvider
    final courses = ref.watch(coursProvider);
    final effectiveCourses =
        widget.courses.isNotEmpty ? widget.courses : courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle tâche'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Champ Titre
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre *',
                    hintText: 'Ex : Rendu de projet Flutter',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre est obligatoire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Champ Description (multiligne facultatif)
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Détails ou consignes...',
                  ),
                ),
                const SizedBox(height: 16.0),

                // Sélecteur de Cours
                DropdownButtonFormField<String>(
                  initialValue: _selectedCourseId,
                  decoration: const InputDecoration(
                    labelText: 'Cours *',
                  ),
                  items: effectiveCourses.map((course) {
                    return DropdownMenuItem<String>(
                      value: course.id,
                      child: Text(course.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCourseId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un cours';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Choix de la date d'échéance
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12.0),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date d\'échéance',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      formattedDate,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),

                // Bouton Enregistrer
                FilledButton(
                  onPressed: _submit,
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
