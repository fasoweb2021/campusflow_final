import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final formattedDate =
        DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_campusflow.png',
                  height: 120.0,
                  width: 120.0,
                  semanticLabel: 'Logo CampusFlow',
                ),
                const SizedBox(height: 24.0),
                Text(
                  'CampusFlow',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Vos cours, vos échéances, sans stress',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  formattedDate,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Commencer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
