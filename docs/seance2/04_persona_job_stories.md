# Séance 2 — Persona et Job Stories pour CampusFlow

Ce document formalise le profil d'utilisateur type de CampusFlow et ses deux job stories directrices, conformément aux contraintes réelles du terrain burkinabè et aux fonctionnalités prévues dans `docs/ARCHITECTURE.md`.

---

## 1. Persona : Moussa Ouédraogo

### Identité et situation
- **Nom** : Moussa Ouédraogo
- **Âge** : 22 ans
- **Localisation** : Ouagadougou, Burkina Faso
- **Filière** : Licence 3 Informatique à l'Université Joseph Ki-Zerbo (Ouaga 1)

### Équipement et connectivité
- **Appareil** : Smartphone Android d'entrée de gamme (**Tecno Spark 10C**), processeur 8 cœurs Unisoc, 4 Go de RAM, écran 6,6 pouces (résolution compacte ~720 × 1612 px).
- **Stockage** : 64 Go de mémoire interne, dont plus de 50 Go saturés par les médias WhatsApp, les photos de tableaux d'amphithéâtre et les PDF de cours.
- **Forfait data** : Forfait Internet mobile rechargeable par Mobile Money (Orange / Moov), généralement 1 à 2 Go par semaine. Moussa désactive fréquemment la data mobile en journée pour économiser ses mégaoctets et éviter les débits automatiques des applications en arrière-plan.

### Horaires et rythme de vie
- **Emploi du temps** : Cours de 7h30 à 12h30 et de 14h00 à 18h00. Trajets à moto dans la circulation ouagalaise.
- **Organisation** : Révisions, travaux dirigés et projets académiques menés le soir à la maison (20h00 - 23h30) ou en bibliothèque universitaire les week-ends.

### Difficultés concrètes pour suivre ses échéances
1. **Saturation de WhatsApp** : Les annonces d'exercices, de dates d'exposés ou de changements de planning sont dispersées au milieu de centaines de messages dans les groupes de promotion, rendant les informations critiques impossibles à retrouver rapidement.
2. **Notes éparpillées** : Moussa note les dates limites sur des feuilles volantes ou dans les marges de ses cahiers, qui finissent par s'égarer.
3. **Risque d'oubli sous la charge de travail** : Avec 6 à 7 matières en parallèle, il arrive régulièrement que Moussa découvre une échéance la veille ou le matin même d'un TP noté.
4. **Pas de connexion continue** : Les applications nécessitant un accès Internet permanent ou des synchronisations lourdes en tâche de fond échouent à lui fournir ses informations dès qu'il coupe ses données mobiles.

### Citation
> *« Entre les cours qui changent de salle à la dernière minute et les devoirs annoncés au milieu de 500 messages sur WhatsApp, j'ai tout le temps peur de rater une échéance importante. Il me faut un endroit simple où je vois tout de suite ce qui presse. »*

---

## 2. Job Stories (Format strict)

### Job Story n° 1 — Consultation et hiérarchisation des urgences
> **Quand** j'ouvre l'application après une journée de cours,  
> **je veux** consulter immédiatement la liste ordonnée de mes échéances avec une mise en évidence des devoirs en retard,  
> **pour** prioriser mes révisions du soir sans risquer de rater un rendu universitaire.

- **Fonctionnalité qui en découle** :  
  L'écran principal **Échéances** (`EcheancesScreen`), proposant un `ListView.builder` de tuiles de tâches (`TaskTile`) avec le titre, le cours associé, la date formatée en français et un affichage visuel en couleur d'erreur (`#B3261E` sur surface neutre) pour les tâches dont la date limite est dépassée (`Task.isOverdue`), ainsi qu'un filtrage rapide par statut (À faire / Faites / En retard).

---

### Job Story n° 2 — Saisie immédiate d'une échéance
> **Quand** un professeur annonce une date limite de rendu de TP à la fin d'une séance,  
> **je veux** saisir rapidement la nouvelle tâche avec son titre, le cours correspondant et la date d'échéance dans un formulaire dédié,  
> **pour** l'enregistrer instantanément avant de ranger mes affaires sans devoir compter sur ma mémoire.

- **Fonctionnalité qui en découle** :  
  Le formulaire de saisie d'échéance (**TaskFormScreen**), accessible en un appui sur le bouton d'action flottant (`FloatingActionButton`), intégrant un champ de titre validé non vide, une sélection du cours dans un menu déroulant (`DropdownButtonFormField`), un sélecteur de date ergonomique (`showDatePicker`) et une confirmation visuelle par `SnackBar`.
