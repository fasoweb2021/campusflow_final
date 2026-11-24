import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/title_screen.dart';

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      theme: AppTheme.lightTheme,
      home: const TitleScreen(),
    );
  }
}

