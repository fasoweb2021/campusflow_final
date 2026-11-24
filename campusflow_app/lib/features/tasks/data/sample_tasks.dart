import 'package:campusflow_models/campusflow_models.dart';

final sampleCourses = <Course>[
  const Course(
    id: 'c1',
    name: 'Algorithmique Avancée',
    teacher: 'Dr. Koné',
    room: 'Amphi A',
  ),
  const Course(
    id: 'c2',
    name: 'Programmation Mobile',
    teacher: 'M. Traoré',
    room: 'Labo 3',
  ),
  const Course(
    id: 'c3',
    name: 'Bases de Données Réparties',
    teacher: 'Dr. Sawadogo',
    room: 'Salle 12',
  ),
];

final sampleCoursesMap = {
  for (final course in sampleCourses) course.id: course,
};

List<Task> getSampleTasks([DateTime? referenceDate]) {
  final now = referenceDate ?? DateTime.now();

  return <Task>[
    // 2 tâches en retard (non faites avec date antérieure à aujourd'hui)
    Task(
      id: 't1',
      title: 'Devoir maison : Arbres B+ et indexation',
      description: 'Implémentation en C des opérations d\'insertion et recherche',
      dueDate: now.subtract(const Duration(days: 3)),
      done: false,
      courseId: 'c1',
    ),
    Task(
      id: 't2',
      title: 'Rapport de TP : Architecture Flutter',
      description: 'Analyse comparative du cycle de vie des widgets',
      dueDate: now.subtract(const Duration(days: 1)),
      done: false,
      courseId: 'c2',
    ),

    // 2 tâches déjà faites
    Task(
      id: 't3',
      title: 'Installation SDK Android & Émulateur Pixel',
      description: 'Configuration sur disque D: et validation flutter doctor',
      dueDate: now.subtract(const Duration(days: 4)),
      done: true,
      courseId: 'c2',
    ),
    Task(
      id: 't4',
      title: 'Fiche de synthèse NoSQL vs SQL',
      description: 'Comparaison des modèles relationnels et orientés documents',
      dueDate: now.add(const Duration(days: 1)),
      done: true,
      courseId: 'c3',
    ),

    // 4 tâches à venir (non faites)
    Task(
      id: 't5',
      title: 'Projet Mobile : Écran Échéances avec ListView',
      description: 'Création du widget TaskTile selon la variante C',
      dueDate: now.add(const Duration(days: 2)),
      done: false,
      courseId: 'c2',
    ),
    Task(
      id: 't6',
      title: 'Exercices sur les graphes et flot maximal',
      description: 'Algorithme de Ford-Fulkerson et Edmonds-Karp',
      dueDate: now.add(const Duration(days: 4)),
      done: false,
      courseId: 'c1',
    ),
    Task(
      id: 't7',
      title: 'TP Noté : Réplication et consensus Raft',
      description: 'Simulation de quorum sur environnement distribué',
      dueDate: now.add(const Duration(days: 6)),
      done: false,
      courseId: 'c3',
    ),
    Task(
      id: 't8',
      title: 'Préparation Examen Blanc d\'Algorithmique',
      description: 'Révision des annales de Master 1 des trois dernières années',
      dueDate: now.add(const Duration(days: 8)),
      done: false,
      courseId: 'c1',
    ),
  ];
}

