# Séance 2 — Design System v1

Ce document formalise les spécifications visuelles et ergonomiques de **CampusFlow v1**, en reprenant exactement les choix architecturaux fixés dans la section 3 de `docs/ARCHITECTURE.md`. Il intègre la **Variante C** (Cartes structurées avec indicateur de retard visuel) validée lors du TP06.

---

## 1. Palette de couleurs & Conformité des contrastes

Les couleurs ont été choisies et testées pour respecter scrupuleusement le standard d'accessibilité **WCAG 2.1 AA** (ratio de contraste minimal de **4,5:1** pour le texte normal).

| Rôle sémantique | Code Hexadécimal | Texte posé dessus | Ratio de contraste | Conformité WCAG AA |
|:---|:---:|:---|:---:|:---:|
| **primary** | `#0B6E4F` *(vert)* | onPrimary `#FFFFFF` | **6,25:1** | ✅ Conforme |
| **secondary** | `#F2A541` *(ambre)* | onSecondary `#1C1B1F` | **8,35:1** | ✅ Conforme |
| **surface** | `#FAFAF7` *(fond neutre)* | onSurface `#1C1B1F` | **16,38:1** | ✅ Conforme |
| **surface** | `#FAFAF7` *(fond neutre)* | Texte secondaire `#4A4F4C` | **7,99:1** | ✅ Conforme |
| **primaryContainer** | `#D8EFE5` *(vert clair)*| onPrimaryContainer `#1C1B1F` | **14,19:1** | ✅ Conforme |
| **error** | `#B3261E` *(rouge)* | onError `#FFFFFF` | **6,54:1** | ✅ Conforme |
| **surface** | `#FAFAF7` *(fond neutre)* | Texte « en retard » `#B3261E` | **6,25:1** | ✅ Conforme |

> ⚠️ **Règle absolue d'accessibilité** : Le blanc (`#FFFFFF`) n'est **jamais** posé sur l'ambre (`#F2A541`) en raison d'un contraste insuffisant (~1,7:1). Tout texte sur fond ambre utilise impérativement `onSecondary` (`#1C1B1F`).

---

## 2. Échelle typographique

CampusFlow s'appuie sur la police système standard Material 3 (**Roboto** sur Android) pour optimiser les performances de rendu sans surcharge de police web :

| Style typographique | Taille (sp) | Graisse (Weight) | Usage dans l'application |
|:---|:---:|:---:|:---|
| **headlineSmall** | 24 | w600 *(Semi-bold)* | Titres d'écran principaux (ex. *Échéances*, *Mes Cours*, *Connexion*) |
| **titleMedium** | 16 | w600 *(Semi-bold)* | Titre d'une tâche, en-tête d'une carte de cours |
| **bodyMedium** | 14 | w400 *(Regular)* | Corps de texte courant, descriptions d'échéances |
| **labelLarge** | 14 | w600 *(Semi-bold)* | Boutons d'action, étiquettes de filtres |
| **bodySmall** | 12 | w400 *(Regular)* | Dates d'échéance, métadonnées de cours, badges |

---

## 3. Spécifications des 3 composants clés et leurs états

Conformément aux directives Material 3 et aux contraintes ergonomiques mobiles, les cibles tactiles sont toutes de **hauteur minimale 48 dp**. Les espacements respectent une grille à base de multiples de 8 dp (8, 16, 24 dp).

### 3.1. Bouton principal (`FilledButton`)
- **Rôle** : Actions primaires décisives (*Enregistrer la tâche*, *Marquer comme fait*, *Entrer*).
- **Géométrie** : Hauteur minimale 48 dp, coins arrondis à 12 dp (`BorderRadius.circular(12)`), typographie `labelLarge`.
- **États** :
  - **État Normal** : Fond `primary` (`#0B6E4F`), texte `onPrimary` (`#FFFFFF`).
  - **État Désactivé (Disabled)** : Fond neutre à faible contraste (`#E4E4E2`), texte grisé (`#A8A8A6`), inerte au clic.
  - **État Erreur / Destructif** : Fond `error` (`#B3261E`), texte `onError` (`#FFFFFF`).

### 3.2. Carte de tâche (`TaskTile` / `Card` — Variante C retenue)
- **Rôle** : Affichage d'une échéance dans la liste, avec priorisation visuelle immédiate des urgences.
- **Géométrie** : Conteneur de hauteur ~84 dp, coins arrondis à 12 dp, case à cocher tactile de 24 × 24 dp (cible globale $\ge 48$ dp), badge de cours et étiquette d'échéance.
- **États** :
  - **État Normal (À faire, dans les délais)** : Fond `surface` (`#FAFAF7`), liseré latéral neutre (`#ADB5BD`), titre `titleMedium` (`#1C1B1F`), date en texte secondaire (`#4A4F4C`).
  - **État Fait (Désactivé / Achevé)** : Case cochée verte (`#0B6E4F`), titre barré en gris estompé (`#A8A8A6`), fond légèrement atténué, liseré inactif.
  - **État Erreur (En retard / `isOverdue`)** : Liseré latéral rouge épais (`#B3261E`), badge d'alerte « EN RETARD » (`#B3261E`), libellé de la date limite en rouge (`#B3261E`, ratio 6,25:1 garanti).

### 3.3. Champ de saisie (`TextFormField`)
- **Rôle** : Saisie de données textuelles dans les formulaires (titre, mot de passe, e-mail).
- **Géométrie** : Hauteur minimale 48 dp, bordure `OutlineInputBorder` avec coins arrondis à 12 dp, libellé flottant permanent (`floatingLabelBehavior: always`).
- **États** :
  - **État Normal** : Bordure grise (`#79747E`), texte saisi `onSurface` (`#1C1B1F`), libellé en texte secondaire (`#4A4F4C`).
  - **État Désactivé (Disabled)** : Bordure et fond estompés, saisie inactive.
  - **État Erreur (Validation échouée)** : Bordure rouge `error` (`#B3261E`), message explicatif sous le champ en rouge (`#B3261E`), texte saisi préservé.

---

## 4. Tailles de fenêtre visées (Adaptabilité responsive)

L'application CampusFlow est pensée pour s'adapter dynamiquement aux variations d'écran des terminaux étudiants :

- **Fenêtre Compacte (< 600 dp)** :
  - Cible principale (smartphones en orientation portrait, gabarit de référence 360 × 800 dp).
  - Navigation par écran simple, liste verticale défilante, formulaire en `SingleChildScrollView` pour absorber le clavier virtuel.
- **Fenêtre Moyenne (600–839 dp)** :
  - Petites tablettes ou smartphones en mode paysage.
  - Mise en page téléphone élargie et centrée avec marges latérales confortables.
- **Fenêtre Étendue ($\ge$ 840 dp)** :
  - Tablettes ou ordinateurs portables.
  - **Mise en page split-view (liste + détail côte à côte)** via un `LayoutBuilder` (flex 2 pour la liste, flex 3 pour le détail).
