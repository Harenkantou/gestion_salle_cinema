# Implémentation de la Fonctionnalité J3: Remise Enfants

## 📋 Résumé des modifications

Cette implémentation ajoute le support des enfants avec réduction tarifaire (15 000Ar au lieu de 20 000Ar pour les places Standard).

### Architecture adoptée:
- **Table `type_billet`** : Distingue les billets ADULTE (isEnfant=FALSE) et ENFANT (isEnfant=TRUE)
- **Table `billet`** : Référence `id_type_billet` pour tracer le type de billet
- **Calcul de prix au paiement** : Appliqué dynamiquement selon le type de place + type de billet

---

## 🗄️ Modifications Base de Données

### 1. Table `type_billet`
```sql
CREATE TABLE type_billet (
    id_type_billet SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    isEnfant BOOLEAN DEFAULT FALSE
);

-- Données initiales
INSERT INTO type_billet (libelle, isEnfant) VALUES
('Adulte', FALSE),
('Enfant', TRUE);
```

### 2. Colonne dans table `billet`
```sql
ALTER TABLE billet ADD COLUMN id_type_billet INTEGER;
ALTER TABLE billet ADD CONSTRAINT fk_billet_type_billet 
    FOREIGN KEY (id_type_billet) REFERENCES type_billet(id_type_billet);
```

---

## 🎯 Tarification

| Type de Place | Adulte  | Enfant  | Réduction |
|---------------|---------|---------|-----------|
| Standard      | 20 000Ar | 15 000Ar | ✅ 5 000Ar |
| Premium       | 50 000Ar | 50 000Ar | ❌ Non    |
| PMR           | 20 000Ar | 20 000Ar | ❌ Non    |

**Règle**: Réduction enfant SEULEMENT pour les places Standard

---

## 📦 Fichiers Java modifiés/créés

### Modèles
- ✅ **Billet.java** : Ajout `TypeBillet typeBillet`
- ✅ **TypeBillet.java** : NOUVEAU modèle
- ✅ **Client.java** : Modifié (colonne `type_client` si besoin)

### Services
- ✅ **BilletService.java** :
  - `creerBillet(client, seance, place, typeBillet)` : Crée billet avec calcul prix
  - `creerBilletAdulte()` : Crée billet adulte
  - `creerBilletEnfant()` : Crée billet enfant
  - `calculerPrixBillet()` : Calcule prix selon type place + type billet

- ✅ **TypeBilletService.java** : NOUVEAU
  - `getTypeBilletAdulte()` : Récupère le type ADULTE
  - `getTypeBilletEnfant()` : Récupère le type ENFANT

- ✅ **RevenuService.java** : NOUVEAU
  - `calculerRevenuSeance()` : CA réel d'une séance (avec billets vendus)
  - `calculerRevenuSalleParDate()` : CA réel par salle/date
  - `obtenirDetailRevenuSeance()` : Détail avec breakdown enfants/adultes

### Repositories
- ✅ **TypeBilletRepository.java** : NOUVEAU

### Contrôleurs
- ✅ **RevenuController.java** : NOUVEAU API REST
  - `GET /api/revenu/seance/{idSeance}` : CA d'une séance
  - `GET /api/revenu/salle/{idSalle}/date/{date}` : CA par salle/date
  - `GET /api/revenu/salle/{idSalle}/periode` : CA sur période
  - `GET /api/revenu/prix` : Calcul prix (paramètres: typePlaceLibelle, isEnfant)

---

## 🚀 Utilisation

### 1. Exécuter le script SQL
```bash
psql -U user -d cinema_db -f SCRIPT_COMPLET_AVEC_NOUVELLE_FONCTIONNALITE.sql
```

### 2. Compiler l'application
```bash
mvn clean install
mvn spring-boot:run
```

### 3. Exemples d'API

#### Calculer le prix d'un billet
```bash
# Billet enfant - Place Standard → 15 000Ar
GET http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true

# Billet adulte - Place Standard → 20 000Ar
GET http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=false

# Billet enfant - Place Premium → 50 000Ar (pas de réduction)
GET http://localhost:8080/api/revenu/prix?typePlaceLibelle=Premium&isEnfant=true
```

#### Consulter le CA d'une séance
```bash
GET http://localhost:8080/api/revenu/seance/1
```

Réponse:
```json
{
  "success": true,
  "revenuMaximum": 45000.0,
  "detail": {
    "idSeance": 1,
    "film": "Avatar",
    "salle": "Salle A",
    "dateSeance": "2026-01-10",
    "heureDebut": "10:00",
    "revenuStandard": 45000.0,
    "revenuPremium": 0.0,
    "revenuTotal": 45000.0,
    "nombreBillets": 3,
    "nombreAdultes": 2,
    "nombreEnfants": 1
  }
}
```

#### Consulter le CA d'une salle par date
```bash
GET http://localhost:8080/api/revenu/salle/1/date/2026-01-10
```

---

## 💾 Création d'un billet (depuis Java)

```java
@Autowired
BilletService billetService;

@Autowired
TypeBilletService typeBilletService;

// Créer un billet enfant
TypeBillet typeEnfant = typeBilletService.getTypeBilletEnfant();
Billet billet = billetService.creerBillet(client, seance, place, typeEnfant);
// Prix automatiquement calculé à 15 000Ar pour place Standard

// Ou directement
Billet billet = billetService.creerBilletEnfant(client, seance, place);
```

---

## ✅ Tests

### Test 1: Vérifier la tarification
```sql
SELECT 
    b.id_billet,
    c.nom || ' ' || c.prenom as client,
    tp.libelle as type_place,
    tb.libelle as type_billet,
    b.prix as prix_applique
FROM billet b
JOIN client c ON b.id_client = c.id_client
JOIN place p ON b.id_place = p.id_place
JOIN type_place tp ON p.id_type_place = tp.id_type_place
LEFT JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet;
```

### Test 2: Revenu par séance avec enfants
```sql
SELECT 
    s.id_seance,
    f.titre as film,
    COUNT(b.id_billet) as nombre_billets,
    SUM(CASE WHEN tb.isEnfant = FALSE THEN 1 ELSE 0 END) as adultes,
    SUM(CASE WHEN tb.isEnfant = TRUE THEN 1 ELSE 0 END) as enfants,
    SUM(b.prix) as revenu_total
FROM seance s
JOIN film f ON s.id_film = f.id_film
LEFT JOIN billet b ON s.id_seance = b.id_seance
LEFT JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
GROUP BY s.id_seance, f.titre;
```

---

## 🎓 Récapitulatif Fonctionnalité J3

✅ **Remise enfant** : 15 000Ar au lieu de 20 000Ar pour places Standard
✅ **Type de place** : Non affecté (un enfant prend une place Standard/Premium/PMR)
✅ **Calcul au paiement** : Prix calculé automatiquement via `calculerPrixBillet()`
✅ **API REST** : Calcul et consultation du CA en temps réel
✅ **Design BD** : Table `type_billet` pour extensibilité future

---

## 📚 Prochaines étapes possibles

1. **Interface Web** : Ajouter une page pour la réservation avec sélection du type de billet
2. **Rapports** : Génération de rapports de revenu avec détail enfants/adultes
3. **Autres réductions** : Ajouter ÉTUDIANT, SENIOR, GROUPE (extensible via type_billet)
4. **Gestion des tarifs** : Interface pour configurer les tarifs par type de billet
