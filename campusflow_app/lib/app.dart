import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

class CampusFlowApp extends StatelessWidget {
  final RouterConfig<Object>? routerConfig;

  const CampusFlowApp({
    super.key,
    this.routerConfig,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CampusFlow',
      theme: AppTheme.lightTheme,
      routerConfig: routerConfig ?? appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      locale: const Locale('fr', 'FR'),
    );
  }
}
