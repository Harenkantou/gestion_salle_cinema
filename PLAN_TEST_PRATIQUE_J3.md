# 🧪 PLAN DE TEST PRATIQUE J3 - ÉTAPE PAR ÉTAPE

## 🚀 PRÉPARATION INITIALE

### **Étape 1: Vérifier que tout est en place**

```powershell
# Terminal PowerShell
cd D:\S5\Mme Baovola\gestion_cinema_farany\gestion_cinema\gestion_cinema

# Vérifier la structure
ls -Path "src\main\java\com\example\cinema"
```

**Fichiers à vérifier:**
- ✅ `model\TypeBillet.java` → créé
- ✅ `model\Billet.java` → modifié
- ✅ `service\TypeBilletService.java` → créé
- ✅ `service\BilletService.java` → modifié
- ✅ `service\RevenuService.java` → créé
- ✅ `controller\RevenuController.java` → créé
- ✅ `controller\BilletController.java` → modifié
- ✅ `repository\TypeBilletRepository.java` → créé

---

### **Étape 2: Nettoyer et compiler le projet**

```powershell
# Terminal PowerShell
mvn clean
mvn compile
```

**Résultat attendu:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: 25 seconds
```

**Si erreur:**
```
❌ [ERROR] COMPILATION ERROR

→ Vérifier les imports dans les classes Java
→ Vérifier les annotations @Repository, @Service, @Controller
→ Vérifier les dépendances Spring Boot
```

---

### **Étape 3: Exécuter les tests unitaires**

```powershell
mvn test -DskipITs
```

**Résultat attendu:**
```
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.example.cinema.service.BilletServiceTest
[INFO] ✅ PASS: calculerPrixBilletEnfantStandard
[INFO] ✅ PASS: calculerPrixBilletAdulteStandard
[INFO] Tests run: 4, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

**Si test échoue:**
```
❌ FAIL: Prix enfant n'est pas 15000

→ Vérifier BilletService.calculerPrixBillet()
→ Vérifier les constantes (PRIX_STANDARD_ENFANT = 15000.0)
```

---

### **Étape 4: Packager l'application**

```powershell
mvn package -DskipTests
```

**Résultat attendu:**
```
[INFO] Building jar: target\vente-app-1.0.0.jar
[INFO] BUILD SUCCESS
```

---

## 🎯 LANCER L'APPLICATION

### **Étape 5: Démarrer Spring Boot**

```powershell
# Terminal PowerShell 1
mvn spring-boot:run
```

**Écran d'affichage:**
```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_|\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v3.x.x)

2026-01-16 10:00:00.000  INFO 12345 --- [main] c.e.c.Application
: Started Application in 3.234 seconds (JVM running for 3.567s)
```

**Attendre le message:**
```
Tomcat initialized with port(s): 8080 (http)
```

**Ne pas fermer ce terminal!**

---

## 📱 TESTER VIA L'INTERFACE WEB

### **Étape 6: Ouvrir le navigateur**

```
URL: http://localhost:8080/
```

**Écran attendu:**

```
┌─────────────────────────────────────────────────┐
│  🎬 GESTION CINÉMA                              │
│─────────────────────────────────────────────────│
│                                                  │
│  ➕ Accueil    📽️ Films    🎭 Salles    👤 Login │
│                                                  │
│  Bienvenue sur Gestion Cinéma!                 │
│                                                  │
│  Films actuellement à l'affiche:               │
│  ┌──────────────┐  ┌──────────────┐            │
│  │   AVATAR     │  │  INCEPTION   │            │
│  │   4/5 ⭐    │  │   4/5 ⭐    │            │
│  └──────────────┘  └──────────────┘            │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

### **Étape 7: Se connecter**

```
URL: http://localhost:8080/auth/login
```

**Écran:**
```
┌─────────────────────────────────┐
│  📝 Connexion                    │
├─────────────────────────────────┤
│                                  │
│  Email: [____________]           │
│  Mot de passe: [____________]    │
│                                  │
│  [🔐 Se connecter]  [📝 S'inscrire]│
│                                  │
└─────────────────────────────────┘
```

**Données de test (à vérifier dans la BD):**

```sql
-- Requête pour vérifier les clients existants
SELECT * FROM client;
```

**Clients de test possibles:**
- Email: `jean@example.com` | Mot de passe: `password123`
- Email: `marie@example.com` | Mot de passe: `password123`

**Si pas de compte:**
1. Cliquer "S'inscrire"
2. Remplir: Nom, Prénom, Email, Mot de passe
3. Cliquer "Créer un compte"

**Résultat attendu:**
```
✅ Compte créé avec succès!
→ Redirection vers page d'accueil (connecté)
```

---

### **Étape 8: Sélectionner un film pour réserver**

**Cliquer sur film "AVATAR"**

**Écran attendu:**
```
┌─────────────────────────────────────────┐
│  🎬 AVATAR                               │
├─────────────────────────────────────────┤
│                                          │
│  ⭐ 4/5 (125 avis)                       │
│  ⏱️ Durée: 162 minutes                  │
│  📝 Réalisateur: James Cameron           │
│                                          │
│  Prochaines séances:                    │
│  ┌────────────────────────────────────┐ │
│  │ 2026-01-10 (Vendredi)              │ │
│  │ • 10:00 - Salle A (95/100 places)  │ │
│  │ • 14:00 - Salle B (87/100 places)  │ │
│  │ • 18:00 - Salle C (42/100 places)  │ │
│  ├────────────────────────────────────┤ │
│  │ 2026-01-11 (Samedi)                │ │
│  │ • 10:00 - Salle A (100/100 places) │ │
│  └────────────────────────────────────┘ │
│                                          │
└─────────────────────────────────────────┘
```

**Cliquer:** "2026-01-10 10:00 - Salle A"

---

### **Étape 9: IMPORTANT - Choisir les places ET le type de billet**

**URL:** `http://localhost:8080/billets/reserver/1`

**Écran CRITIQUE (à vérifier!) :**

```
┌───────────────────────────────────────────────────────┐
│  🎫 Réserver des places - AVATAR                       │
├───────────────────────────────────────────────────────┤
│                                                        │
│  📽️ Séance: 2026-01-10 à 10:00                        │
│  🎭 Salle: Salle A (Capacité: 100)                    │
│  💰 Tarif enfant: 15 000Ar ⭐ (RÉDUIT!)               │
│                                                        │
│  ═══════════════════════════════════════════════════  │
│  📊 TABLEAU TARIFAIRE:                                │
│  ┌─────────────────────────────────────────────────┐  │
│  │ Standard Adulte:  20 000Ar                      │  │
│  │ Standard Enfant:  15 000Ar ⭐ (Réduction!)      │  │
│  │ Premium:          50 000Ar (Pas de réduction)   │  │
│  └─────────────────────────────────────────────────┘  │
│                                                        │
│  ═══════════════════════════════════════════════════  │
│                                                        │
│  🪑 Sélectionner les places:                          │
│                                                        │
│  Place: Rang A - Numéro 1 (Standard)                 │
│    ☐ Sélectionner                                    │
│    Adulte: 20 000Ar        Enfant: 15 000Ar ⭐        │
│    ◯ Adulte              ◯ Enfant                     │
│                                                        │
│  Place: Rang A - Numéro 2 (Standard)                 │
│    ☑ Sélectionner                                    │
│    Adulte: 20 000Ar        Enfant: 15 000Ar ⭐        │
│    ◯ Adulte              ◉ Enfant                     │
│                                                        │
│  Place: Rang A - Numéro 3 (Premium)                  │
│    ☑ Sélectionner                                    │
│    Adulte: 50 000Ar        Enfant: 50 000Ar ❌        │
│    ◉ Adulte              ◯ Enfant                     │
│                                                        │
│  [✅ Confirmer]  [🔄 Réinitialiser]                   │
│                                                        │
└───────────────────────────────────────────────────────┘
```

### ✅ **TEST 1: Réserver 1 place adulte + 1 place enfant standard**

**Actions:**

1. **Cliquer la case** "Rang A - Numéro 1"
2. **Sélectionner radio button** "Enfant" (15 000Ar)
3. **Cliquer la case** "Rang A - Numéro 2"
4. **Sélectionner radio button** "Adulte" (20 000Ar)
5. **Cliquer** "[✅ Confirmer]"

**Résultat attendu:**

```
┌─────────────────────────────────────────┐
│  ✅ Réservation confirmée!               │
├─────────────────────────────────────────┤
│                                          │
│  2 places réservées avec succès!         │
│  Prix total: 35 000Ar                   │
│  • Place A-1 (Enfant): 15 000Ar ⭐      │
│  • Place A-2 (Adulte): 20 000Ar         │
│                                          │
│  Redirection vers séance...             │
│  [🔙 Retour aux films]                  │
│                                          │
└─────────────────────────────────────────┘
```

**Vérification en BD:**

```powershell
# Terminal PowerShell 2 (nouveau terminal)
psql -U postgres -d gestion_cinema
```

```sql
-- Vérifier les billets créés
SELECT 
    b.id_billet,
    c.nom || ' ' || c.prenom as client,
    p.rangee || p.numero as place,
    tp.libelle as type_place,
    tb.libelle as type_billet,
    b.prix
FROM billet b
JOIN client c ON b.id_client = c.id_client
JOIN place p ON b.id_place = p.id_place
JOIN type_place tp ON p.id_type_place = tp.id_type_place
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
ORDER BY b.id_billet DESC
LIMIT 5;
```

**Résultat attendu:**
```
 id_billet | client      | place | type_place | type_billet | prix
───────────┼─────────────┼───────┼────────────┼─────────────┼────────
 1         | Jean Dupont | A1    | Standard   | Enfant      | 15000
 2         | Jean Dupont | A2    | Standard   | Adulte      | 20000
```

✅ **SUCCÈS TEST 1** si:
- Billets créés en BD
- Prix enfant = 15000
- Prix adulte = 20000
- type_billet correct (Adulte/Enfant)

---

### ✅ **TEST 2: Vérifier les réservations personnelles**

**URL:** `http://localhost:8080/billets/mes-reservations`

**Écran attendu:**

```
┌────────────────────────────────────────────────────────┐
│  🎫 Mes Réservations (Jean Dupont)                     │
├────────────────────────────────────────────────────────┤
│                                                         │
│  📊 Résumé personnalisé:                               │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Total dépensé: 35 000Ar                          │  │
│  │ Nombre de billets: 2                             │  │
│  │ • Adultes: 1 👤                                  │  │
│  │ • Enfants: 1 👶 ⭐                               │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  📋 Détail des billets:                                │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Film    │ Date       │ Heure │ Place │ Type │ Pr  │
│  ├──────────────────────────────────────────────────┤  │
│  │ AVATAR  │2026-01-10  │ 10:00 │ A-1   │👶 En│15k │  │
│  │         │            │       │       │fant ⭐    │  │
│  │ AVATAR  │2026-01-10  │ 10:00 │ A-2   │👤 Ad│20k │  │
│  │         │            │       │       │ulte │    │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  👶 Légende: ⭐ = Prix réduit enfant                   │
│                                                         │
└────────────────────────────────────────────────────────┘
```

**Vérifications:**
- ✅ Nombre de billets = 2
- ✅ Adultes = 1
- ✅ Enfants = 1
- ✅ Badge "Enfant ⭐" visible
- ✅ Prix enfant = 15 000Ar affiché
- ✅ Prix adulte = 20 000Ar affiché
- ✅ Total = 35 000Ar

---

### ✅ **TEST 3: Vérifier le rapport financier (ADMIN)**

**URL:** `http://localhost:8080/billets/rapport-financier`

**Écran attendu:**

```
┌──────────────────────────────────────────────────────────┐
│  💰 Rapport Financier - Administration                  │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  ┌─────────────┬──────────────┬─────────────────────────┐│
│  │ CA TOTAL    │ NOMBRE DE    │ RÉPARTITION CLIENTS     ││
│  │             │ BILLETS      │                         ││
│  │ 35 000Ar    │ 2            │ Adultes: 1 👤           ││
│  │             │              │ Enfants: 1 👶 ⭐        ││
│  └─────────────┴──────────────┴─────────────────────────┘│
│                                                           │
│  ┌──────────────────────────┐  ┌──────────────────────┐ │
│  │ 👤 REVENU ADULTES        │  │ 👶 REVENU ENFANTS    │ │
│  │                          │  │    (RÉDUCTION)       │ │
│  │ CA: 20 000Ar             │  │ CA: 15 000Ar         │ │
│  │ Billets: 1               │  │ Billets: 1           │ │
│  │ Moyen: 20 000Ar/billet   │  │ Moyen: 15 000Ar/bill │ │
│  │                          │  │ Économie: 5 000Ar ⭐ │ │
│  └──────────────────────────┘  └──────────────────────┘ │
│                                                           │
│  📊 Détail par Film:                                     │
│  ┌─────────────────────────────────────────────────────┐│
│  │ Film    │ Revenu      │ % du Total    │ Enfants    ││
│  ├─────────────────────────────────────────────────────┤│
│  │ AVATAR  │ 35 000Ar    │ 100% ████████ │ 1 👶 ⭐    ││
│  └─────────────────────────────────────────────────────┘│
│                                                           │
└──────────────────────────────────────────────────────────┘
```

**Vérifications CRITIQUES:**
- ✅ CA Total = 35 000Ar
- ✅ Revenu Adultes = 20 000Ar
- ✅ Revenu Enfants = 15 000Ar
- ✅ Enfants = 1, Adultes = 1
- ✅ Économie enfants = 5 000Ar affiché

---

## 🔌 TESTER VIA LES APIs REST

### **Étape 10: Ouvrir Postman (ou utiliser curl)**

#### **REQUEST 1: Calculer le prix enfant**

```
Method: GET
URL: http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true

Headers:
Accept: application/json
```

**Résultat attendu (200 OK):**

```json
{
  "typePlaceLibelle": "Standard",
  "isEnfant": true,
  "prix": 15000.0
}
```

✅ **Si prix = 15000.0** → TEST RÉUSSI

---

#### **REQUEST 2: Calculer le prix adulte**

```
Method: GET
URL: http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=false

Headers:
Accept: application/json
```

**Résultat attendu (200 OK):**

```json
{
  "typePlaceLibelle": "Standard",
  "isEnfant": false,
  "prix": 20000.0
}
```

✅ **Si prix = 20000.0** → TEST RÉUSSI

---

#### **REQUEST 3: Obtenir le revenu d'une séance**

```
Method: GET
URL: http://localhost:8080/api/revenu/seance/1

Headers:
Accept: application/json
```

**Résultat attendu (200 OK):**

```json
{
  "success": true,
  "detail": {
    "idSeance": 1,
    "film": "AVATAR",
    "salle": "Salle A",
    "dateSeance": "2026-01-10",
    "heureDebut": "10:00",
    "revenuTotal": 35000.0,
    "revenuStandard": 35000.0,
    "revenuPremium": 0.0,
    "nombreBillets": 2,
    "nombreAdultes": 1,
    "nombreEnfants": 1
  }
}
```

✅ **Si nombreEnfants = 1 et nombreAdultes = 1** → TEST RÉUSSI

---

#### **REQUEST 4: Revenu d'une salle par date**

```
Method: GET
URL: http://localhost:8080/api/revenu/salle/1/date/2026-01-10

Headers:
Accept: application/json
```

**Résultat attendu (200 OK):**

```json
{
  "success": true,
  "detail": {
    "salle": "Salle A",
    "date": "2026-01-10",
    "revenuTotal": 35000.0,
    "nombreBillets": 2,
    "nombreAdultes": 1,
    "nombreEnfants": 1
  }
}
```

✅ **Si separation adultes/enfants visible** → TEST RÉUSSI

---

## 📊 TESTER AVEC CURL (Terminal PowerShell)

```powershell
# TEST 1: Prix enfant standard
$response = Invoke-WebRequest -Uri "http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true"
$response.Content | ConvertFrom-Json
# Attendre: "prix": 15000.0

# TEST 2: Prix adulte standard
$response = Invoke-WebRequest -Uri "http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=false"
$response.Content | ConvertFrom-Json
# Attendre: "prix": 20000.0

# TEST 3: Revenu séance
$response = Invoke-WebRequest -Uri "http://localhost:8080/api/revenu/seance/1"
$response.Content | ConvertFrom-Json
# Attendre: nombreEnfants = 1, nombreAdultes = 1
```

---

## 🗄️ TESTER LA BASE DE DONNÉES

### **Étape 11: Vérifier les données en PostgreSQL**

```powershell
# Terminal PowerShell 2
psql -U postgres -d gestion_cinema
```

#### **Query 1: Vérifier type_billet table**

```sql
SELECT * FROM type_billet ORDER BY id_type_billet;
```

**Résultat attendu:**
```
 id_type_billet | libelle | isenfant
────────────────┼─────────┼──────────
 1              | Adulte  | false
 2              | Enfant  | true
(2 rows)
```

✅ **Si 2 lignes et isenfant correct** → SUCCÈS

---

#### **Query 2: Vérifier les billets créés**

```sql
SELECT 
    b.id_billet,
    c.nom || ' ' || c.prenom as client,
    f.titre as film,
    p.rangee || p.numero as place,
    tp.libelle as type_place,
    tb.libelle as type_billet,
    tb.isenfant,
    b.prix
FROM billet b
JOIN client c ON b.id_client = c.id_client
JOIN seance s ON b.id_seance = s.id_seance
JOIN film f ON s.id_film = f.id_film
JOIN place p ON b.id_place = p.id_place
JOIN type_place tp ON p.id_type_place = tp.id_type_place
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
ORDER BY b.id_billet DESC
LIMIT 10;
```

**Résultat attendu:**
```
 id_billet | client      | film   | place | type_place | type_billet | isenfant | prix
───────────┼─────────────┼────────┼───────┼────────────┼─────────────┼──────────┼────────
 1         | Jean Dupont | AVATAR | A1    | Standard   | Enfant      | t        | 15000
 2         | Jean Dupont | AVATAR | A2    | Standard   | Adulte      | f        | 20000
(2 rows)
```

✅ **Vérifier:**
- `type_billet` = "Enfant" ou "Adulte"
- `isenfant` = true/false
- `prix` = 15000 (enfant) ou 20000 (adulte)

---

#### **Query 3: Revenu avec séparation enfants/adultes**

```sql
SELECT 
    tb.libelle as type_billet,
    COUNT(*) as nombre_billets,
    SUM(b.prix) as revenu_total,
    AVG(b.prix) as prix_moyen
FROM billet b
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
GROUP BY tb.libelle
ORDER BY tb.isenfant;
```

**Résultat attendu:**
```
 type_billet | nombre_billets | revenu_total | prix_moyen
─────────────┼────────────────┼──────────────┼────────────
 Adulte      | 1              | 20000        | 20000.00
 Enfant      | 1              | 15000        | 15000.00
(2 rows)
```

✅ **Vérifier:** Total revenu = 35000

---

#### **Query 4: Économies enfants (IMPORTANT!)**

```sql
SELECT 
    COUNT(CASE WHEN tb.isenfant = true THEN 1 END) as nombre_enfants,
    COUNT(CASE WHEN tb.isenfant = false THEN 1 END) as nombre_adultes,
    SUM(b.prix) as revenu_reel,
    COUNT(CASE WHEN tb.isenfant = true THEN 1 END) * 20000 as revenu_sans_reduction,
    (COUNT(CASE WHEN tb.isenfant = true THEN 1 END) * 20000) - SUM(CASE WHEN tb.isenfant = true THEN b.prix ELSE 0 END) as economie_totale
FROM billet b
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet;
```

**Résultat attendu:**
```
 nombre_enfants | nombre_adultes | revenu_reel | revenu_sans_reduction | economie_totale
────────────────┼────────────────┼─────────────┼──────────────────────┼────────────────
 1              | 1              | 35000       | 40000                 | 5000
```

✅ **Vérifier:** economie_totale = 5000 Ar

---

## 📋 CHECKLIST DE TEST FINAL

### ✅ INTERFACE WEB

- [ ] Page de connexion accessible
- [ ] Bouton sélection "Enfant" visible dans reserver.jsp
- [ ] Prix enfant (15 000Ar) affiché à côté du prix adulte (20 000Ar)
- [ ] Après réservation → mes-reservations.jsp montre badge "Enfant ⭐"
- [ ] Rapport financier affiche "Revenu Enfants: 15 000Ar"
- [ ] Calcul économies visible (5 000Ar)

### ✅ APIs REST

- [ ] GET /api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true → 15000.0
- [ ] GET /api/revenu/prix?typePlaceLibelle=Standard&isEnfant=false → 20000.0
- [ ] GET /api/revenu/seance/1 → nombreEnfants > 0
- [ ] GET /api/revenu/salle/1/date/2026-01-10 → JSON valide

### ✅ BASE DE DONNÉES

- [ ] Table `type_billet` contient (1, 'Adulte', false) et (2, 'Enfant', true)
- [ ] Colonne `id_type_billet` remplie dans table `billet`
- [ ] Query revenu montre séparation enfants/adultes
- [ ] Query économies montre 5000Ar de réduction

### ✅ LOGIQUE

- [ ] Prix enfant = 15 000Ar (pas 20 000Ar)
- [ ] Réduction enfant = 5 000Ar
- [ ] Pas de réduction premium (50 000Ar pour tous)
- [ ] Type de billet ≠ type de place
- [ ] Calcul au moment de la réservation

---

## 🎯 CAS DE TEST SUPPLÉMENTAIRES

### **TEST BONUS 1: Réserver place premium enfant**

**Actions:**
1. Sélectionner place Premium (rang B)
2. Choisir type "Enfant"
3. Vérifier prix = 50 000Ar (PAS de réduction)

**Résultat attendu:**
```
❌ Pas de réduction - Prix 50 000Ar
```

---

### **TEST BONUS 2: Réserver 3 places (2 enfants + 1 adulte)**

**Réservation:**
- Place A-1 → Enfant → 15 000Ar
- Place A-2 → Enfant → 15 000Ar
- Place A-3 → Adulte → 20 000Ar

**Total attendu:** 50 000Ar

**En BD:**
```sql
SELECT COUNT(*) WHERE isenfant = true;
→ Attendre: 2 enfants
SELECT SUM(prix) WHERE isenfant = true;
→ Attendre: 30 000Ar
```

---

### **TEST BONUS 3: Plusieurs séances**

1. Réserver AVATAR (séance 1) → 1 adulte
2. Réserver INCEPTION (séance 2) → 1 enfant
3. Vérifier rapport financier affiche stats séparées

---

## 🚨 ERREURS COURANTES ET SOLUTIONS

| Erreur | Cause | Solution |
|--------|-------|----------|
| **404 - Page not found** | URL incorrecte | Vérifier `localhost:8080` |
| **TypeError undefined isEnfant** | JSP ne reçoit pas typesBillets | Vérifier form submit en JavaScript |
| **Prix enfant = 20 000Ar** | BilletService pas modifié | Recompiler avec `mvn clean compile` |
| **Pas de badge "Enfant"** | JSP not rendering | Vérifier `${billet.typeBillet.isEnfant}` |
| **FK constraint error** | type_billet n'existe pas | Exécuter migration SQL |
| **API retourne null** | Service pas autowired | Vérifier `@Service @Repository` annotations |

---

## 📞 AIDE RAPIDE

```powershell
# Arrêter l'application
Ctrl+C

# Relancer après modification
mvn spring-boot:run

# Vider cache Spring Boot
mvn clean spring-boot:run

# Voir logs d'erreur
mvn spring-boot:run > logs.txt 2>&1

# Tester connexion BD
psql -U postgres -d gestion_cinema -c "SELECT COUNT(*) FROM type_billet;"

# Réinitialiser BD (ATTENTION!)
psql -U postgres -d gestion_cinema -f src/main/resources/sql/SCRIPT_COMPLET_AVEC_NOUVELLE_FONCTIONNALITE.sql
```

