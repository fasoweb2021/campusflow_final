# Séance 2 — Comparaison et choix de la variante de l'écran Échéances

Ce document évalue les trois variantes d'interface conçues pour l'écran principal **Échéances** (`01_echeances_variante_A.svg`, `01_echeances_variante_B.svg`, `01_echeances_variante_C.svg`), sur la grille d'évaluation méthodologique du cours (Besoin, Parcours, Accessibilité, Faisabilité).

---

## 1. Grille d'évaluation comparative (Notes de 1 à 5)

| Critère d'évaluation | Variante A (Liste simple) | Variante B (Groupé par jour) | Variante C (Cartes & Retard visuel) |
|:---|:---:|:---:|:---:|
| **1. Adéquation au besoin**<br>*(Répondre à l'angoisse de Moussa de rater une échéance critique)* | 2 / 5<br>Toutes les tâches se ressemblent ; aucun détachement immédiat de l'urgence. | 4 / 5<br>Structure chronologique intuitive, mais dispersion visuelle si beaucoup de sections vides. | **5 / 5**<br>Mise en exergue immédiate des retards et urgences grâce aux badges et liserés contrastés. |
| **2. Intégration au parcours**<br>*(Fluide lors de la consultation rapide entre deux cours)* | 3 / 5<br>Oblige à lire chaque ligne pour identifier la matière et l'heure limite. | 4 / 5<br>Bonne clarté temporelle, mais défilement plus long avec les en-têtes multiples. | **5 / 5**<br>Lecture en Z instantanée : statut $\rightarrow$ cours $\rightarrow$ date en un seul balayage visuel. |
| **3. Accessibilité & Lisibilité**<br>*(Contraste, lisibilité en plein soleil, cibles tactiles $\ge 48$ dp)* | 3 / 5<br>Lignes compactes de 60 dp, cibles tactiles un peu resserrées, contraste faible. | 3 / 5<br>Lisibilité correcte mais fragmentation des contrastes avec les petits titres de section. | **5 / 5**<br>Cartes spacieuses (84 dp), cibles tactiles généreuses, contrastes WCAG AA renforcés. |
| **4. Faisabilité technique v1**<br>*(Implémentation Flutter / Riverpod simple et sans surcoût)* | **5 / 5**<br>`ListView.builder` standard très simple à brancher sur une liste plate. | 2 / 5<br>Nécessite un partitionnement complexe des données et des `Sliver` ou `ListView` imbriquées. | **4 / 5**<br>`ListView.builder` direct avec une condition simple (`Task.isOverdue`) et filtres par provider. |
| **Note globale pondérée** | **13 / 20** | **13 / 20** | **19 / 20** |

---

## 2. Variante recommandée et justification

### Recommandation : **Variante C (Cartes structurées avec indicateur de retard visuel)**

### Justification détaillée :
1. **Alignement avec le persona Moussa (TP04)** :  
   Moussa consulte souvent son téléphone dans la précipitation entre deux cours ou le soir avec fatigue. La **Variante C** répond directement à sa principale angoisse (« *peur de rater une échéance importante* ») en appliquant un traitement visuel fort et immédiat sur les tâches en retard (liseré contrasté, badge d'alerte, date en rouge d'erreur `#B3261E`).
2. **Cohérence avec le parcours utilisateur (TP05)** :  
   À l'étape *Consulter* du parcours, Moussa dispose de quelques secondes pour prioriser ses révisions. La Variante C dissocie clairement le cours (étiquette neutre), le statut d'urgence et la date limite. Couplée au `SegmentedButton` en tête d'écran, elle permet de basculer instantanément sur le filtre « En retard (2) ».
3. **Faisabilité en Flutter (Séances 5 & 6)** :  
   Contrairement à la Variante B qui imposerait un regroupement dynamique par date avec des en-têtes de section lourds à maintenir avec Riverpod, la Variante C reste une liste plate optimisée (`ListView.builder`) où chaque élément délègue son style au widget `TaskTile` en fonction du résultat booléen de `task.isOverdue(DateTime.now())`.

---

## 3. Décision finale de l'étudiant

**Variante retenue** : **Variante C (Cartes structurées avec indicateur de retard visuel)**

**Justification personnelle** :  
Après analyse des trois maquettes, je choisis la **Variante C** car elle répond le plus efficacement aux angoisses de Moussa et à son parcours de consultation rapide identifié au TP05. Le contraste marqué des cartes, son badge d'urgence et son liseré latéral lui permettent d'isoler en un clin d'œil les devoirs en retard sans devoir relire tout son écran en plein soleil. J'écarte la **Variante A** car son affichage uniforme ne met aucunement en valeur les priorités critiques d'un étudiant débordé. Enfin, j'écarte la **Variante B** dont le regroupement temporel fractionné allonge inutilement le défilement et complexifie la gestion de l'état sans offrir la lisibilité directe de la variante C.

