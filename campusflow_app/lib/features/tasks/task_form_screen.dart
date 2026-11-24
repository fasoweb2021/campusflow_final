import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:campusflow_models/campusflow_models.dart';

import 'providers/taches_notifier.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final List<Course>? courses;

  const TaskFormScreen({
    super.key,
    this.courses,
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
  bool _isSubmitting = false;

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

  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: '', // Le serveur attribue l'identifiant
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

      setState(() {
        _isSubmitting = true;
      });

      try {
        await ref.read(tachesProvider.notifier).ajouter(newTask);
        if (!mounted) return;

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
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout : $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
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

    final List<Course> courses = widget.courses ?? ref.watch(coursProvider);

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
                  enabled: !_isSubmitting,
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
                  enabled: !_isSubmitting,
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
                  items: courses.map((course) {
                    return DropdownMenuItem<String>(
                      value: course.id,
                      child: Text(course.name),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
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
                  onTap: _isSubmitting ? null : _pickDate,
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
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        )
                      : Text(
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
