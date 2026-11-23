# Séance 2 — Parcours utilisateur « Suivre mes échéances »

Ce document modélise le parcours utilisateur complet de Moussa (notre persona étudiant de Ouagadougou défini au TP04) à travers les cinq étapes types du suivi de ses devoirs et travaux académiques, conformément au cadrage fonctionnel fixé dans `docs/ARCHITECTURE.md`.

---

## 1. Cartographie du parcours utilisateur (5 étapes)

| Étape | Action de Moussa | Friction rencontrée | Opportunité pour l'application |
|:---|:---|:---|:---|
| **1. Planifier** | Le dimanche soir ou en début de semaine, Moussa cherche à anticiper sa charge de travail hebdomadaire pour caler ses plages de révision et de TD. | Les échéances sont dispersées sur des feuilles volantes, des cahiers et dans l'historique surchargé des groupes WhatsApp. Aucune visibilité globale sur les urgences immédiates. | Proposer une vue d'ensemble des échéances triées par date avec des filtres par statut (À faire, Faites, En retard) et le nombre de tâches associées. |
| **2. Consulter** | À la descente des cours ou pendant une pause à l'université, Moussa ouvre son smartphone pour vérifier ce qu'il doit préparer pour le lendemain. | Les applications lourdes nécessitant un chargement continu bloquent sur sa connexion mobile instable ou consomment inutilement son forfait data limité. | Un écran de liste récapitulatif ultra-léger et direct (`EcheancesScreen`), avec affichage contrasté et alerte visuelle en rouge (`#B3261E`) sur les échéances en retard (`Task.isOverdue`). |
| **3. Ajouter** | En fin de séance d'amphithéâtre, un enseignant annonce un devoir maison à rendre sous huitaine. Moussa doit l'enregistrer avant de quitter la salle. | Manque de temps dans le brouhaha de fin de cours. La prise de note rapide dans une app bloc-notes générique sans date structurée ni matière est vite oubliée. | Un formulaire d'ajout rapide (`TaskFormScreen`) accessible en un appui sur le bouton flottant (+), avec sélection guidée du cours et sélecteur de date natif. |
| **4. Être rappelé** | Occupé par ses cours et ses déplacements à moto, Moussa souhaite être prévenu avant qu'une date limite ne soit dépassée. | Tendance naturelle à procrastiner ou à oublier une date butoir sans rappel proactif, particulièrement lorsque la data mobile est désactivée. | Alertes et notifications locales planifiées sur le smartphone pour prévenir l'étudiant la veille et quelques heures avant l'échéance. |
| **5. Rendre** | Son devoir finalisé et déposé au secrétariat ou envoyé par e-mail, Moussa souhaite clore cette tâche de son esprit. | Absence de sentiment de clôture : tant que la tâche reste visible au même endroit, l'étudiant conserve le doute de savoir si tout a bien été fait. | Action claire de validation (case à cocher sur la tuile ou bouton « Marquer comme fait » sur l'écran détail) basculant la tâche en état terminé. |

---

## 2. Opportunités retenues pour la v1

En stricte conformité avec le périmètre architectural de la v1 (`docs/ARCHITECTURE.md`), les 3 opportunités suivantes sont retenues et priorisées dans l'application :

1. **Liste centralisée des échéances avec alerte visuelle des retards** :  
   Un écran principal `/taches` (`EcheancesScreen`) basé sur un `ListView.builder` de composants `TaskTile`, affichant le titre, le cours associé, la date formatée en français (`intl`), avec coloration en couleur d'erreur (`#B3261E`) des tâches non faites dont la date limite est antérieure à aujourd'hui (`Task.isOverdue(DateTime.now())`).
2. **Filtrage instantané par statut (À faire / Faites / En retard)** :  
   Un composant `SegmentedButton` en tête de liste permettant d'isoler en un geste les devoirs urgents en retard, les tâches restantes ou l'historique des travaux terminés, avec calcul dynamique du nombre de tâches par statut via un provider Riverpod dérivé (`tachesFiltreesProvider`).
3. **Formulaire d'ajout rapide et validation de réalisation** :  
   Un flux de création dédié (`TaskFormScreen`) déclenché par un `FloatingActionButton` (champs validés, cours en menu déroulant, date via `showDatePicker`, confirmation par `SnackBar`), couplé à une interaction fluide pour marquer une tâche comme achevée (case à cocher interactive et bouton dédié dans `TaskDetailScreen`).

---

## 3. Opportunités reportées en v2

Les fonctionnalités suivantes dépassent le cadre de la v1 fixé par l'architecte et sont explicitement reportées à la version 2 :

1. **Rappels et notifications proactives** :  
   L'intégration d'un gestionnaire de notifications locales d'arrière-plan (`flutter_local_notifications` ou alarmes système) pour réveiller le téléphone avant l'échéance sans nécessiter de connexion permanente.
2. **Mode hors-ligne persistant avec cache local et synchronisation bidirectionnelle** :  
   Le stockage local persistant (base SQLite, Isar ou Hive) permettant la consultation et la création hors-ligne complète avec réconciliation asynchrone lors du retour du réseau (la v1 assurant la robustesse réseau via les états d'erreur et le bouton « Réessayer » sur l'API REST).
3. **Synchronisation avec agendas externes et partage entre étudiants** :  
   Exportation des échéances vers Google Calendar et partage direct des devoirs entre délégués et étudiants via Bluetooth ou QR code.
