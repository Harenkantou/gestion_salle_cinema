# 💰 Fonctionnalité : Calcul du Revenu Maximum par Salle

## 📋 Description
Cette fonctionnalité permet de calculer la valeur maximale qu'une salle de cinéma peut générer lors d'une diffusion de film, en tenant compte des différents types de places (Standard et Premium) et de leurs tarifs respectifs.

## 📐 Règles de Gestion Implémentées

### Types de Places avec Tarifs
- **Standard** : 20 000 Ar par place
- **Premium** : 50 000 Ar par place
- **PMR (Personnes à Mobilité Réduite)** : 20 000 Ar par place

### Formule de Calcul
```
Revenu Maximum = Σ(Nombre de places type i × Prix type i)
```

**Exemple pour la Salle A :**
- 40 places Standard × 20 000 Ar = 800 000 Ar
- 40 places Premium × 50 000 Ar = 2 000 000 Ar
- **Revenu Total Maximum = 2 800 000 Ar**

## 🏗️ Architecture Implémentée

### 1. Modèles (Entity Classes)
- **TypePlace.java** : Entité JPA pour les types de places avec prix
  - `idTypePlace` (PK)
  - `libelle` (String, unique)
  - `prix` (Double)

- **Place.java** (modifié)
  - Relation ManyToOne vers TypePlace
  - Permet d'accéder au prix via `place.getTypePlace().getPrix()`

### 2. Repositories
- **TypePlaceRepository.java** : CRUD pour les types de places

### 3. Services
- **SalleService.java** (enrichi)
  - `calculerRevenuMaximum(Long idSalle)` : Calcule le revenu total
  - `obtenirDetailRevenu(Long idSalle)` : Retourne les détails complets (par type, par salle, etc.)

### 4. Contrôleurs
- **SalleController.java** (nouveau)
  - `GET /salles/list` : Affiche la liste des salles
  - `GET /salles/{idSalle}` : Affiche les détails d'une salle avec revenu maximum
  - `GET /salles/api/revenu-max/{idSalle}` : API REST pour obtenir le revenu en JSON

### 5. Views (JSP)
- **salles/list.jsp** : Liste des salles avec lien vers détails
- **salles/detail.jsp** : Détails d'une salle avec :
  - Revenu maximum en évidence (💰)
  - Tableau récapitulatif par type de place
  - Plan des places visualisé avec codes couleur
- **salles/revenu-detail.jsp** : Vue JSON pour l'API REST

### 6. DTOs
- **RevenuDTO.java** : Classe pour structurer les réponses API

## 📊 Données Test Intégrées

### Salle A
- Capacité : 100 places
- Configuration : 40 Standard + 40 Premium
- **Revenu Maximum : 2 800 000 Ar**

### Salle B
- Capacité : 80 places
- Configuration : 30 Standard + 20 Premium + 2 PMR
- **Revenu Maximum : 1 640 000 Ar**

### Salle C
- Capacité : 120 places
- Configuration : 50 Standard + 35 Premium + 2 PMR
- **Revenu Maximum : 2 790 000 Ar**

## 🔗 Points d'Accès

### Interface Web
- **Page d'accueil** : Lien "Gestion des salles"
- **Menu** : `/salles/list` (si implémenté dans la barre de navigation)
- **Détails salle** : `/salles/{idSalle}`

### API REST
```bash
# Obtenir le revenu maximum d'une salle (format JSON)
GET http://localhost:8000/salles/api/revenu-max/1
```

### Réponse JSON
```json
{
  "success": true,
  "revenuMaximum": 2800000,
  "detail": {
    "salle": {
      "id": 1,
      "nom": "Salle A",
      "capaciteTotal": 80
    },
    "placesParType": {
      "Standard": 40,
      "Premium": 40
    },
    "prixParType": {
      "Standard": 20000,
      "Premium": 50000
    },
    "revenuParType": {
      "Standard": 800000,
      "Premium": 2000000
    }
  }
}
```

## 🔧 Fichiers Modifiés/Créés

### Créés
- `src/main/java/com/example/cinema/model/TypePlace.java`
- `src/main/java/com/example/cinema/repository/TypePlaceRepository.java`
- `src/main/java/com/example/cinema/controller/SalleController.java`
- `src/main/java/com/example/cinema/dto/RevenuDTO.java`
- `src/main/webapp/WEB-INF/views/salles/list.jsp`
- `src/main/webapp/WEB-INF/views/salles/detail.jsp`
- `src/main/webapp/WEB-INF/views/salles/revenu-detail.jsp`

### Modifiés
- `src/main/java/com/example/cinema/model/Place.java` : Ajout de la relation TypePlace
- `src/main/java/com/example/cinema/service/SalleService.java` : Ajout des méthodes de calcul
- `src/main/resources/sql/test-data.sql` : Intégration des prix pour TypePlace
- `src/main/webapp/WEB-INF/views/home.jsp` : Ajout du lien vers la gestion des salles

## 🚀 Utilisation

### Pour un utilisateur
1. Accéder à `/salles/list`
2. Cliquer sur "Voir Détails & Revenu" d'une salle
3. Voir le revenu maximum et la répartition des places

### Pour un développeur (API)
```java
// Dans un contrôleur ou service
Long idSalle = 1L;
Double revenuMax = salleService.calculerRevenuMaximum(idSalle);
Map<String, Object> details = salleService.obtenirDetailRevenu(idSalle);
```

## ✅ Vérification

Pour vérifier le bon fonctionnement :
1. Redémarrer le projet : `mvn spring-boot:run`
2. Accéder à http://localhost:8000
3. Cliquer sur "Gestion des salles"
4. Les revenus maximums doivent s'afficher correctement

## 📝 Notes

- Les prix sont stockés en Ariary (Ar)
- Les calculs sont effectués en temps réel (pas de cache)
- La formule s'adapte dynamiquement au nombre de places configurées par salle
- Tous les clients ont maintenant le même mot de passe : `mdp123`
