import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_notifier.dart';

const sampleProfileUser = User(
  id: 'u1',
  name: 'Moussa Ouédraogo',
  email: 'etudiant@campusflow.bf',
  program: 'Licence 3 Informatique',
);

class ProfilScreen extends ConsumerWidget {
  final User user;

  const ProfilScreen({
    super.key,
    this.user = sampleProfileUser,
  });

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48.0,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: Text(
                    user.name
                        .split(' ')
                        .map((e) => e.isNotEmpty ? e[0] : '')
                        .take(2)
                        .join(),
                    style: textTheme.headlineMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                user.name,
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              Text(
                user.program,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.school_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Filière'),
                      subtitle: Text(user.program),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Adresse email'),
                      subtitle: Text(user.email),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.badge_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Identifiant'),
                      subtitle: Text(user.id),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                  ),
                  onPressed: () => _confirmLogout(context, ref),
                  icon: const Icon(Icons.logout),
                  label: const Text('Se déconnecter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
