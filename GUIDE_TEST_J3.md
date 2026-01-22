# 🧪 GUIDE DE TEST - FONCTIONNALITÉ J3 (Réduction Enfants)

## 📋 TABLE DE TEST

---

## 1️⃣ PHASE 1: TESTS UNITAIRES (JUnit + Mockito)

### ✅ Test 1: BilletService - Calcul du prix

```java
// Fichier: src/test/java/com/example/cinema/service/BilletServiceTest.java

@SpringBootTest
public class BilletServiceTest {
    
    @Autowired
    private BilletService billetService;
    
    /**
     * TEST: Vérifier que le prix enfant standard est 15 000Ar
     * RÉSULTAT ATTENDU: 15000.0
     */
    @Test
    public void testCalculerPrixBilletEnfantStandard() {
        Double prix = billetService.calculerPrixBillet("Standard", true);
        
        assertEquals(15000.0, prix, 0.01);
        System.out.println("✅ PASS: Prix enfant standard = 15 000Ar");
    }
    
    /**
     * TEST: Vérifier que le prix adulte standard est 20 000Ar
     * RÉSULTAT ATTENDU: 20000.0
     */
    @Test
    public void testCalculerPrixBilletAdulteStandard() {
        Double prix = billetService.calculerPrixBillet("Standard", false);
        
        assertEquals(20000.0, prix, 0.01);
        System.out.println("✅ PASS: Prix adulte standard = 20 000Ar");
    }
    
    /**
     * TEST: Vérifier que Premium enfant = 50 000Ar (pas de réduction)
     * RÉSULTAT ATTENDU: 50000.0
     */
    @Test
    public void testCalculerPrixBilletEnfantPremium() {
        Double prix = billetService.calculerPrixBillet("Premium", true);
        
        assertEquals(50000.0, prix, 0.01);
        System.out.println("✅ PASS: Prix enfant premium = 50 000Ar (pas de réduction)");
    }
    
    /**
     * TEST: Vérifier réduction enfant = 5 000Ar
     * RÉSULTAT ATTENDU: 20 000 - 15 000 = 5 000Ar
     */
    @Test
    public void testReductionEnfantStandard() {
        Double prixAdulte = billetService.calculerPrixBillet("Standard", false);
        Double prixEnfant = billetService.calculerPrixBillet("Standard", true);
        Double reduction = prixAdulte - prixEnfant;
        
        assertEquals(5000.0, reduction, 0.01);
        System.out.println("✅ PASS: Réduction enfant standard = 5 000Ar");
    }
}
```

### ✅ Test 2: TypeBilletService

```java
// Fichier: src/test/java/com/example/cinema/service/TypeBilletServiceTest.java

@SpringBootTest
public class TypeBilletServiceTest {
    
    @Autowired
    private TypeBilletService typeBilletService;
    
    /**
     * TEST: Vérifier que TypeBillet "Enfant" existe
     * RÉSULTAT ATTENDU: typeBillet.isEnfant = true, libelle = "Enfant"
     */
    @Test
    public void testGetTypeBilletEnfant() {
        TypeBillet typeBillet = typeBilletService.getTypeBilletEnfant();
        
        assertNotNull(typeBillet);
        assertTrue(typeBillet.getIsEnfant());
        assertEquals("Enfant", typeBillet.getLibelle());
        System.out.println("✅ PASS: TypeBillet Enfant récupéré correctement");
    }
    
    /**
     * TEST: Vérifier que TypeBillet "Adulte" existe
     * RÉSULTAT ATTENDU: typeBillet.isEnfant = false, libelle = "Adulte"
     */
    @Test
    public void testGetTypeBilletAdulte() {
        TypeBillet typeBillet = typeBilletService.getTypeBilletAdulte();
        
        assertNotNull(typeBillet);
        assertFalse(typeBillet.getIsEnfant());
        assertEquals("Adulte", typeBillet.getLibelle());
        System.out.println("✅ PASS: TypeBillet Adulte récupéré correctement");
    }
    
    /**
     * TEST: Vérifier qu'on peut récupérer un TypeBillet par libellé
     * RÉSULTAT ATTENDU: TypeBillet avec libelle = "Enfant"
     */
    @Test
    public void testFindByLibelle() {
        TypeBillet typeBillet = typeBilletService.findByLibelle("Enfant");
        
        assertNotNull(typeBillet);
        assertEquals("Enfant", typeBillet.getLibelle());
        System.out.println("✅ PASS: Recherche TypeBillet par libellé OK");
    }
}
```

### ✅ Test 3: RevenuService

```java
// Fichier: src/test/java/com/example/cinema/service/RevenuServiceTest.java

@SpringBootTest
public class RevenuServiceTest {
    
    @Autowired
    private RevenuService revenuService;
    
    /**
     * TEST: Vérifier le calcul du revenu d'une séance
     * CONDITION: Séance ID=1 a 3 billets (2 adultes + 1 enfant)
     * RÉSULTAT ATTENDU: 20000 + 20000 + 15000 = 55 000Ar
     */
    @Test
    public void testCalculerRevenuSeance() {
        Long idSeance = 1L;
        Double revenu = revenuService.calculerRevenuSeance(idSeance);
        
        assertNotNull(revenu);
        assertEquals(55000.0, revenu, 0.01);
        System.out.println("✅ PASS: Revenu séance 1 = " + revenu + "Ar");
    }
    
    /**
     * TEST: Vérifier les détails du revenu (avec enfants/adultes)
     * RÉSULTAT ATTENDU: Map contenant nombreAdultes=2, nombreEnfants=1
     */
    @Test
    public void testObtenirDetailRevenuSeance() {
        Long idSeance = 1L;
        Map<String, Object> detail = revenuService.obtenirDetailRevenuSeance(idSeance);
        
        assertNotNull(detail);
        assertEquals(2L, detail.get("nombreAdultes"));
        assertEquals(1L, detail.get("nombreEnfants"));
        System.out.println("✅ PASS: Détail revenu OK - Adultes: 2, Enfants: 1");
    }
    
    /**
     * TEST: Calculer prix avec API
     * RÉSULTAT ATTENDU: 15000.0 pour Standard + Enfant
     */
    @Test
    public void testCalculerPrixBilletAPI() {
        Double prix = revenuService.calculerPrixBillet("Standard", true);
        
        assertEquals(15000.0, prix, 0.01);
        System.out.println("✅ PASS: Prix API = 15 000Ar");
    }
}
```

---

## 2️⃣ PHASE 2: TESTS D'INTÉGRATION (Base de données)

### ✅ Test 4: Créer un billet enfant et vérifier le prix

```java
@SpringBootTest
@Transactional
public class BilletIntegrationTest {
    
    @Autowired
    private BilletService billetService;
    
    @Autowired
    private BilletRepository billetRepository;
    
    @Autowired
    private TypeBilletService typeBilletService;
    
    /**
     * TEST: Créer un billet enfant et vérifier qu'il est sauvegardé avec le bon prix
     * ÉTAPES:
     * 1. Récupérer Client, Seance, Place, TypeBillet Enfant
     * 2. Appeler billetService.creerBillet()
     * 3. Vérifier que billet.prix = 15 000Ar
     * 4. Vérifier que billet.typeBillet.isEnfant = true
     */
    @Test
    public void testCreerBilletEnfantStandard() {
        // Setup
        Client client = new Client(1L, "Jean", "Dupont", "jean@example.com", ...);
        Seance seance = new Seance(1L, ...);
        Place place = new Place(1L, "A", 1, ...);
        TypeBillet typeBilletEnfant = typeBilletService.getTypeBilletEnfant();
        
        // Action
        Billet billet = billetService.creerBillet(client, seance, place, typeBilletEnfant);
        
        // Assertions
        assertNotNull(billet.getIdBillet());
        assertEquals(15000.0, billet.getPrix(), 0.01);
        assertTrue(billet.getTypeBillet().getIsEnfant());
        System.out.println("✅ PASS: Billet enfant créé - Prix: " + billet.getPrix() + "Ar");
    }
    
    /**
     * TEST: Créer un billet adulte et vérifier qu'il est sauvegardé avec le bon prix
     * RÉSULTAT ATTENDU: billet.prix = 20 000Ar, billet.typeBillet.isEnfant = false
     */
    @Test
    public void testCreerBilletAdulteStandard() {
        // Setup
        Client client = new Client(1L, "Jean", "Dupont", "jean@example.com", ...);
        Seance seance = new Seance(1L, ...);
        Place place = new Place(2L, "A", 2, ...);
        TypeBillet typeBilletAdulte = typeBilletService.getTypeBilletAdulte();
        
        // Action
        Billet billet = billetService.creerBillet(client, seance, place, typeBilletAdulte);
        
        // Assertions
        assertEquals(20000.0, billet.getPrix(), 0.01);
        assertFalse(billet.getTypeBillet().getIsEnfant());
        System.out.println("✅ PASS: Billet adulte créé - Prix: " + billet.getPrix() + "Ar");
    }
}
```

---

## 3️⃣ PHASE 3: TESTS API REST (RestTemplate ou MockMvc)

### ✅ Test 5: API /api/revenu/prix

```java
@SpringBootTest
@AutoConfigureMockMvc
public class RevenuControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    /**
     * TEST: GET /api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true
     * RÉSULTAT ATTENDU: 
     * {
     *   "typePlaceLibelle": "Standard",
     *   "isEnfant": true,
     *   "prix": 15000.0
     * }
     */
    @Test
    public void testAPICalculerPrixEnfantStandard() throws Exception {
        mockMvc.perform(get("/api/revenu/prix")
                .param("typePlaceLibelle", "Standard")
                .param("isEnfant", "true"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.prix").value(15000.0))
            .andExpect(jsonPath("$.isEnfant").value(true))
            .andDo(print());
        
        System.out.println("✅ PASS: API prix enfant standard");
    }
    
    /**
     * TEST: GET /api/revenu/prix?typePlaceLibelle=Standard&isEnfant=false
     * RÉSULTAT ATTENDU: prix = 20000.0
     */
    @Test
    public void testAPICalculerPrixAdulteStandard() throws Exception {
        mockMvc.perform(get("/api/revenu/prix")
                .param("typePlaceLibelle", "Standard")
                .param("isEnfant", "false"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.prix").value(20000.0))
            .andExpect(jsonPath("$.isEnfant").value(false))
            .andDo(print());
        
        System.out.println("✅ PASS: API prix adulte standard");
    }
    
    /**
     * TEST: GET /api/revenu/prix?typePlaceLibelle=Premium&isEnfant=true
     * RÉSULTAT ATTENDU: prix = 50000.0 (pas de réduction)
     */
    @Test
    public void testAPICalculerPrixEnfantPremium() throws Exception {
        mockMvc.perform(get("/api/revenu/prix")
                .param("typePlaceLibelle", "Premium")
                .param("isEnfant", "true"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.prix").value(50000.0))
            .andDo(print());
        
        System.out.println("✅ PASS: API prix enfant premium (pas de réduction)");
    }
    
    /**
     * TEST: GET /api/revenu/seance/1
     * RÉSULTAT ATTENDU: JSON avec nombreAdultes et nombreEnfants
     */
    @Test
    public void testAPIRevenuSeance() throws Exception {
        mockMvc.perform(get("/api/revenu/seance/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.detail.nombreAdultes").exists())
            .andExpect(jsonPath("$.detail.nombreEnfants").exists())
            .andExpect(jsonPath("$.detail.revenuTotal").exists())
            .andDo(print());
        
        System.out.println("✅ PASS: API revenu séance");
    }
}
```

---

## 4️⃣ PHASE 4: TESTS MANUELS (Interface Web)

### ✅ Test 6: Flux complet de réservation

**SCÉNARIO:** Jean Dupont réserve 2 places pour AVATAR (1 adulte + 1 enfant)

#### 📍 **Étape 1: Démarrer l'application**
```bash
# Terminal PowerShell
cd D:\S5\Mme Baovola\gestion_cinema_farany\gestion_cinema\gestion_cinema
mvn clean install
mvn spring-boot:run
```

**Résultat attendu:**
```
[INFO] BUILD SUCCESS
[INFO] Tomcat initialized with port(s): 8080 (http)
[INFO] Started Application in 5.234 seconds
```

#### 📍 **Étape 2: Accéder à la page d'accueil**
```
URL: http://localhost:8080/
Résultat attendu: Page d'accueil avec liste des films
```

#### 📍 **Étape 3: Se connecter**
```
URL: http://localhost:8080/auth/login
Email: jean@example.com
Mot de passe: password123
Résultat attendu: Redirection vers page d'accueil, connecté en tant que Jean Dupont
```

#### 📍 **Étape 4: Réserver une séance**
```
1. Cliquer sur film "AVATAR"
2. Choisir date: 2026-01-10
3. Choisir heure: 10:00
4. Cliquer "Réserver des places"
Résultat attendu: Redirection vers /billets/reserver/1
```

#### 📍 **Étape 5: Sélectionner les places ET LE TYPE (IMPORTANT!)**

**Écran de réservation:**
```
┌─────────────────────────────────────────────────┐
│ Tarification:                                    │
│ • Standard Adulte: 20 000Ar                      │
│ • Standard Enfant: 15 000Ar ⭐ (Réduction!)      │
│ • Premium: 50 000Ar                              │
└─────────────────────────────────────────────────┘

Place: Rang A - Numéro 1  [✓]  
  ◯ Adulte (20 000Ar)   ◉ Enfant (15 000Ar) ← SÉLECTIONNER ENFANT

Place: Rang A - Numéro 2  [✓]  
  ◉ Adulte (20 000Ar)   ◯ Enfant (15 000Ar) ← SÉLECTIONNER ADULTE

[✅ Confirmer la réservation]
```

**Étapes:**
- Cocher place Rang A - Numéro 1 → Sélectionner "Enfant"
- Cocher place Rang A - Numéro 2 → Sélectionner "Adulte"
- Cliquer "Confirmer la réservation"

**Résultat attendu:**
```
✅ Redirection vers fiche séance
✅ Message: "2 places réservées avec succès!"
```

#### 📍 **Étape 6: Vérifier les réservations**
```
URL: http://localhost:8080/billets/mes-reservations
```

**Résultat attendu:**

| Film  | Salle   | Date      | Heure | Place | Type    | Prix    |
|-------|---------|-----------|-------|-------|---------|---------|
| AVATAR | Salle A | 2026-01-10 | 10:00 | A-1   | 👶 Enfant ⭐ | 15 000Ar |
| AVATAR | Salle A | 2026-01-10 | 10:00 | A-2   | 👤 Adulte | 20 000Ar |

**Somme:**
```
Résumé:
• Nombre de réservations: 2
• Dépense totale: 35 000Ar ✅ (20k + 15k = 35k)
• Billets adultes: 1 👤
• Billets enfants: 1 👶 ⭐
```

#### 📍 **Étape 7: Vérifier le rapport financier**
```
URL: http://localhost:8080/billets/rapport-financier
```

**Résultat attendu:**

```
┌──────────────┬──────────────┐
│ Revenu Total │ Revenu Adultes: 20 000Ar |
│ 35 000Ar     │ Revenu Enfants: 15 000Ar ⭐|
└──────────────┴──────────────┘

Économies pour enfants: 5 000Ar
(Au lieu de 20k, paient 15k = 5k d'économie)
```

---

## 5️⃣ PHASE 5: TESTS API AVEC POSTMAN

### ✅ Test 7: Tester les endpoints REST

#### 📍 **Request 1: Calculer prix enfant standard**
```
Method: GET
URL: http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true
Headers: Content-Type: application/json

Réponse attendue (200 OK):
{
  "typePlaceLibelle": "Standard",
  "isEnfant": true,
  "prix": 15000.0
}
```

#### 📍 **Request 2: Calculer prix adulte standard**
```
Method: GET
URL: http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=false

Réponse attendue (200 OK):
{
  "typePlaceLibelle": "Standard",
  "isEnfant": false,
  "prix": 20000.0
}
```

#### 📍 **Request 3: Obtenir le revenu d'une séance**
```
Method: GET
URL: http://localhost:8080/api/revenu/seance/1

Réponse attendue (200 OK):
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

#### 📍 **Request 4: Revenu d'une salle pour une date**
```
Method: GET
URL: http://localhost:8080/api/revenu/salle/1/date/2026-01-10

Réponse attendue (200 OK):
{
  "success": true,
  "detail": {
    "salle": "Salle A",
    "date": "2026-01-10",
    "revenuTotal": 35000.0,
    "nombreBillets": 2,
    "nombreAdultes": 1,
    "nombreEnfants": 1,
    "seances": [...]
  }
}
```

---

## 6️⃣ PHASE 6: VÉRIFICATION DE LA BASE DE DONNÉES

### ✅ Test 8: Vérifier les données en BD

#### 📍 **Connexion à PostgreSQL**
```bash
# Terminal PowerShell
psql -U postgres -d gestion_cinema
```

#### 📍 **Query 1: Vérifier la table type_billet**
```sql
SELECT * FROM type_billet;
```

**Résultat attendu:**
```
 id_type_billet | libelle | isenfant
────────────────┼─────────┼─────────
 1              | Adulte  | f
 2              | Enfant  | t
```

#### 📍 **Query 2: Vérifier les billets créés**
```sql
SELECT 
    b.id_billet,
    c.nom,
    p.rangee || p.numero as place,
    tb.libelle as type_billet,
    b.prix
FROM billet b
JOIN client c ON b.id_client = c.id_client
JOIN place p ON b.id_place = p.id_place
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
ORDER BY b.id_billet;
```

**Résultat attendu:**
```
 id_billet | nom        | place | type_billet | prix
───────────┼────────────┼───────┼─────────────┼────────
 1         | Jean Dupont| A1    | Enfant      | 15000
 2         | Jean Dupont| A2    | Adulte      | 20000
```

#### 📍 **Query 3: Calcul revenu avec réduction**
```sql
SELECT 
    tb.libelle as type,
    COUNT(*) as nombre,
    SUM(b.prix) as total_revenu
FROM billet b
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
GROUP BY tb.libelle;
```

**Résultat attendu:**
```
 type   | nombre | total_revenu
────────┼────────┼──────────────
 Adulte | 1      | 20000
 Enfant | 1      | 15000
```

**Vérification économie enfants:**
```sql
SELECT 
    COUNT(CASE WHEN tb.isEnfant = true THEN 1 END) as enfants,
    SUM(CASE WHEN tb.isEnfant = true THEN (20000 - b.prix) ELSE 0 END) as economie_totale
FROM billet b
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
WHERE b.id_seance = 1;
```

**Résultat attendu:**
```
 enfants | economie_totale
─────────┼─────────────────
 1       | 5000
```

---

## 🎯 CHECKLIST DE TEST

### ✅ Tests Unitaires
- [ ] BilletService.calculerPrixBillet("Standard", true) = 15000
- [ ] BilletService.calculerPrixBillet("Standard", false) = 20000
- [ ] TypeBilletService.getTypeBilletEnfant() retourne isEnfant=true
- [ ] TypeBilletService.getTypeBilletAdulte() retourne isEnfant=false

### ✅ Tests d'Intégration
- [ ] Créer billet enfant → prix = 15000, typeBillet.isEnfant = true
- [ ] Créer billet adulte → prix = 20000, typeBillet.isEnfant = false
- [ ] Réduction enfant enfant = 5000Ar

### ✅ Tests API
- [ ] GET /api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true → 15000
- [ ] GET /api/revenu/prix?typePlaceLibelle=Standard&isEnfant=false → 20000
- [ ] GET /api/revenu/seance/1 → nombreEnfants > 0

### ✅ Tests Manuels Web
- [ ] Sélectionner place + type enfant → prix 15000 affiché
- [ ] Sélectionner place + type adulte → prix 20000 affiché
- [ ] Mes réservations → badge "Enfant" affiché
- [ ] Rapport financier → stats enfants correctes

### ✅ Tests BD
- [ ] type_billet table existe avec données (Adulte, Enfant)
- [ ] billet.id_type_billet rempli pour tous les billets
- [ ] Query revenu affiche séparation adultes/enfants

### ✅ Tests Performance
- [ ] Calcul prix < 10ms
- [ ] API /api/revenu/seance < 100ms
- [ ] Rapport financier < 500ms

---

## 🚀 COMMANDES DE TEST

### **Exécuter tous les tests unitaires:**
```bash
mvn test
```

### **Exécuter un test spécifique:**
```bash
mvn test -Dtest=BilletServiceTest#testCalculerPrixBilletEnfantStandard
```

### **Exécuter les tests avec rapport:**
```bash
mvn test -DargLine="-Xmx1024m -XX:MaxPermSize=256m"
mvn surefire-report:report
```

### **Couvrage de code (JaCoCo):**
```bash
mvn clean test jacoco:report
# Rapport généré: target/site/jacoco/index.html
```

### **Tester l'application lancée:**
```bash
# Terminal 1: Lancer l'app
mvn spring-boot:run

# Terminal 2: Tester avec curl
curl -X GET "http://localhost:8080/api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true"
```

---

## 📝 RÉSUMÉ DES POINTS DE TEST CRITIQUES

| Point | Valeur attendue | Comment tester |
|-------|-----------------|-----------------|
| **Prix enfant standard** | 15 000Ar | BilletService.calculerPrixBillet("Standard", true) |
| **Prix adulte standard** | 20 000Ar | BilletService.calculerPrixBillet("Standard", false) |
| **Prix premium enfant** | 50 000Ar | BilletService.calculerPrixBillet("Premium", true) |
| **Réduction enfant** | 5 000Ar | 20000 - 15000 = 5000 |
| **Type de billet BD** | isEnfant = true/false | SELECT * FROM type_billet |
| **Lien billet-type** | FK valide | SELECT * FROM billet WHERE id_type_billet IS NOT NULL |
| **API prix** | JSON avec prix | GET /api/revenu/prix?... |
| **Rapport revenu** | Séparation enfants | GET /billets/rapport-financier |
| **Vue réservation** | Sélecteur Enfant visible | http://localhost:8080/billets/reserver/1 |

