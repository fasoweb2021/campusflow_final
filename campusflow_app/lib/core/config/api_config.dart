import 'package:flutter/foundation.dart';

/// Configuration de l'accès à l'API CampusFlow.
class ApiConfig {
  /// URL de base de l'API.
  ///
  /// Sur le web ou machine physique : http://localhost:3000
  /// Sur l'émulateur Android : http://10.0.2.2:3000
  ///
  /// Pourquoi 10.0.2.2 ?
  /// Dans l'émulateur Android (QEMU), l'adresse 127.0.0.1 pointe vers le système
  /// Android émulé lui-même (sa propre interface de boucle locale).
  /// L'adresse 10.0.2.2 est une passerelle virtuelle spéciale gérée par QEMU
  /// qui redirige directement vers l'interface loopback (127.0.0.1) de la machine
  /// hôte exécutant le serveur json-server.
  static const String baseUrl =
      kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
}

