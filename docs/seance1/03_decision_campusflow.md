# Séance 1 — Décision de plateforme pour CampusFlow

Ce document formalise les choix stratégiques d'architecture et de ciblage technologique pour l'application **CampusFlow**, en application directe de la section 1 du dossier d'architecture (`docs/ARCHITECTURE.md`), des enseignements de la fiche comparative (`docs/seance1/01_fiche_comparative.md`) et des leçons tirées de la disparition de BlackBerry OS (`docs/seance1/02_autopsie_blackberry.md`).

---

## 1. Décision argumentée : Cible, plateformes et approche technologique

Le projet CampusFlow a pour vocation d'accompagner les étudiants d'Afrique francophone — avec
le Burkina Faso comme terrain d'expérimentation prioritaire — dans la gestion rigoureuse de
leurs cours, tâches et échéances académiques. Au vu des réalités économiques et matérielles
observées dans la fiche comparative, Android est retenu comme plateforme prioritaire absolue,
iOS ne constituant qu'une cible secondaire. Les données de parts de marché d'octobre 2026 sont
sans appel (fiche comparative, critère 12) : Android représente 92,72 % du parc mobile au
Burkina Faso et 83,03 % à l'échelle du continent, reléguant iOS à un rôle marginal (~7 %)
réservé à une minorité aisée. Cette écrasante domination est confortée par le coût d'acquisition
du matériel (critère 11) : le pouvoir d'achat étudiant oriente massivement les choix vers des
smartphones d'entrée de gamme (Tecno, Infinix, Itel) vendus entre 30 000 et 60 000 FCFA,
rendant l'écosystème Apple financièrement hors de portée. Pour autant, afin de ne pas exclure
les détenteurs d'iPhone et pour éviter l'écueil d'un double développement natif coûteux et
redondant (critères 3 et 10), l'approche retenue est le développement cross-platform avec Flutter.
Ce choix s'appuie directement sur les leçons de l'autopsie de BlackBerry OS : la chute brutale
de RIM nous a enseigné qu'un isolement technologique ou un retard de livraison est fatal face
aux leaders du marché (cause 1 : effondrement de l'écosystème ; cause 3 : timing et inertie).
Flutter apporte un code source unique et compilé nativement (AOT), éliminant tout décalage
temporel entre plateformes, tout en garantissant des performances graphiques fluides sur des
processeurs modestes grâce à son moteur de rendu propre. Enfin, en s'appuyant sur les standards
ergonomiques actuels (cibles tactiles de 48 dp, formulaires adaptés au clavier virtuel),
CampusFlow évite le rejet d'interface qui avait coûté si cher à BlackBerry lors du passage
au tout-tactile (cause 2 : rupture d'interface).

---

## 2. Conséquences concrètes pour la suite

En application directe de cette décision, les choix de conception et de développement des prochaines séances respecteront les contraintes suivantes :

1. **Appareils visés (Parc matériel modeste)** :
   - Ciblage prioritaire des smartphones Android d'entrée et de milieu de gamme (processeurs 4 à 8 cœurs modestes type MediaTek/Unisoc, 2 à 3 Go de mémoire vive).
   - Optimisation des gabarits d'écran pour les résolutions compactes (format de référence 360 × 800 dp), tout en assurant l'extensibilité sur écran large/tablette (seuil à 840 dp).
   - Niveau d'API minimal conservateur pour supporter les appareils plus anciens encore en circulation.

2. **Mode hors-ligne partiel et résilience réseau** :
   - La connectivité étant intermittente et la data mobile onéreuse en Afrique de l'Ouest, l'application ne doit jamais afficher un écran blanc ou bloquer la saisie en cas de perte de réseau.
   - Les données des cours et échéances doivent être consultables localement, et les modifications enregistrées avec synchronisation asynchrone dès le rétablissement de la connexion.

3. **Taille de l'application (Poids de l'APK)** :
   - Maîtrise rigoureuse de la taille du binaire final (APK) pour limiter la consommation du forfait data lors de l'installation.
   - Sélection stricte des dépendances et compression des ressources graphiques.
   - Distribution facilitée en direct (sideloading via Bluetooth, Xender ou stockage local) sans contraindre l'étudiant à repasser par le Play Store.

4. **Langue française et contextualisation locale** :
   - Interface utilisateur, slogans, libellés de formulaires, validations et messages d'erreur intégralement rédigés en français.
   - Formatage des dates conforme aux conventions francophones (via le package `intl` en locale `fr_FR`).
   - Préparation future de la monétisation orientée Mobile Money (Orange Money, Moov Money, Wave) plutôt que carte bancaire internationale.
