# 📚 DOCUMENTATION TECHNIQUE COMPLÈTE J3 - RÉDUCTION ENFANTS

## 🏗️ ARCHITECTURE JAVA - CLASSES À CRÉER

---

## 1️⃣ MODÈLES (Package: `com.example.cinema.model`)

### Classe: `TypeBillet.java` ✅ CRÉÉE
```java
@Entity
@Table(name = "type_billet")
public class TypeBillet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idTypeBillet;
    
    @Column(nullable = false, length = 50, unique = true)
    private String libelle;                    // "Adulte" ou "Enfant"
    
    @Column(nullable = false)
    private Boolean isEnfant;                  // true = Enfant, false = Adulte
    
    // Constructeurs, Getters/Setters
}
```

**Données initiales** :
```
idTypeBillet | libelle | isEnfant
1            | Adulte  | false
2            | Enfant  | true
```

### Classe: `Billet.java` ✅ MODIFIÉE
```java
@Entity
@Table(name = "billet")
public class Billet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idBillet;
    
    @Column(nullable = false)
    private LocalDateTime dateAchat;
    
    @ManyToOne
    @JoinColumn(name = "id_client", nullable = false)
    private Client client;
    
    @ManyToOne
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;
    
    @Column(nullable = false)
    private Integer idStatutBillet;           // 1=réservé, 2=payé
    
    @Column(nullable = false)
    private Double prix;
    
    @ManyToOne
    @JoinColumn(name = "id_type_billet")
    private TypeBillet typeBillet;            // NOUVEAU: Référence au type de billet
    
    @ManyToOne
    @JoinColumn(name = "id_place", nullable = false)
    private Place place;
    
    // Getters/Setters existants + nouveaux
    public TypeBillet getTypeBillet() { return typeBillet; }
    public void setTypeBillet(TypeBillet typeBillet) { this.typeBillet = typeBillet; }
}
```

**Modification BD** :
```sql
ALTER TABLE billet ADD COLUMN id_type_billet INTEGER;
ALTER TABLE billet ADD CONSTRAINT fk_billet_type_billet 
    FOREIGN KEY (id_type_billet) REFERENCES type_billet(id_type_billet);
```

### Classe: `Client.java` (Optionnel)
```java
// Pas de modification pour cette itération
// Le type de client est déterminé lors de la sélection du billet
```

---

## 2️⃣ REPOSITORIES (Package: `com.example.cinema.repository`)

### Interface: `TypeBilletRepository.java` ✅ CRÉÉE
```java
@Repository
public interface TypeBilletRepository extends JpaRepository<TypeBillet, Long> {
    /**
     * Recherche un type de billet par libellé
     * @param libelle "Adulte" ou "Enfant"
     * @return Optional<TypeBillet>
     * @table type_billet
     */
    Optional<TypeBillet> findByLibelle(String libelle);
}
```

### Interface: `BilletRepository.java` ✅ MODIFIÉE
```java
@Repository
public interface BilletRepository extends JpaRepository<Billet, Long> {
    // Méthodes existantes (inchangées)
    List<Billet> findByClient(Client client);
    List<Billet> findBySeance(Seance seance);
    Optional<Billet> findBySeanceAndPlace(Seance seance, Place place);
    
    // Nouvelles méthodes (optionnelles pour J3)
    /**
     * Compte les billets enfants d'une séance
     * @param seance Séance
     * @param isEnfant true pour enfants
     * @return nombre de billets
     * @table billet JOIN type_billet
     */
    long countBySeanceAndTypeBilletIsEnfant(Seance seance, Boolean isEnfant);
}
```

### Interface: `SeanceRepository.java` ✅ MODIFIÉE
```java
@Repository
public interface SeanceRepository extends JpaRepository<Seance, Long> {
    // Méthodes existantes
    Optional<Seance> findBySalleAndDateSeanceAndHeureDebut(Salle salle, LocalDate date, LocalTime heure);
    
    // Nouvelles méthodes pour J3
    /**
     * Trouver toutes les séances d'une salle à une date
     * @param salle Salle
     * @param dateSeance Date de la séance
     * @return List<Seance>
     * @table seance WHERE id_salle = ? AND date_seance = ?
     */
    List<Seance> findBySalleAndDateSeance(Salle salle, LocalDate dateSeance);
    
    /**
     * Trouver les séances d'une salle entre deux dates
     * @param salle Salle
     * @param dateDebut Date début
     * @param dateFin Date fin
     * @return List<Seance>
     * @table seance WHERE id_salle = ? AND date_seance BETWEEN ? AND ?
     */
    List<Seance> findBySalleAndDateSeanceBetween(Salle salle, LocalDate dateDebut, LocalDate dateFin);
}
```

---

## 3️⃣ SERVICES (Package: `com.example.cinema.service`)

### Classe: `TypeBilletService.java` ✅ CRÉÉE
```java
@Service
public class TypeBilletService {
    private final TypeBilletRepository typeBilletRepository;
    
    public TypeBilletService(TypeBilletRepository typeBilletRepository) {
        this.typeBilletRepository = typeBilletRepository;
    }
    
    /**
     * Récupère tous les types de billets
     * @return List<TypeBillet>
     * @table type_billet
     */
    public List<TypeBillet> findAll();
    
    /**
     * Récupère un type de billet par ID
     * @param id ID du type de billet
     * @return TypeBillet
     * @table type_billet WHERE id_type_billet = ?
     */
    public TypeBillet findById(Long id);
    
    /**
     * Récupère un type de billet par libellé
     * @param libelle "Adulte" ou "Enfant"
     * @return TypeBillet
     * @table type_billet WHERE libelle = ?
     */
    public TypeBillet findByLibelle(String libelle);
    
    /**
     * Sauvegarde un type de billet
     * @param typeBillet TypeBillet à sauvegarder
     * @return TypeBillet sauvegardé
     * @table type_billet INSERT/UPDATE
     */
    public TypeBillet save(TypeBillet typeBillet);
    
    /**
     * Supprime un type de billet
     * @param id ID du type de billet
     * @table type_billet DELETE WHERE id_type_billet = ?
     */
    public void deleteById(Long id);
    
    /**
     * Récupère le type de billet "Enfant"
     * @return TypeBillet avec isEnfant = true
     * @table type_billet WHERE libelle = 'Enfant'
     */
    public TypeBillet getTypeBilletEnfant();
    
    /**
     * Récupère le type de billet "Adulte"
     * @return TypeBillet avec isEnfant = false
     * @table type_billet WHERE libelle = 'Adulte'
     */
    public TypeBillet getTypeBilletAdulte();
}
```

### Classe: `BilletService.java` ✅ MODIFIÉE
```java
@Service
public class BilletService {
    private final BilletRepository billetRepository;
    private final TypeBilletService typeBilletService;  // NOUVEAU
    
    // Constructeur modifié
    public BilletService(BilletRepository billetRepository, 
                         TypeBilletService typeBilletService) {
        this.billetRepository = billetRepository;
        this.typeBilletService = typeBilletService;
    }
    
    // Méthodes existantes (findAll, findById, save, deleteById, etc.)
    
    /**
     * Crée un billet avec calcul automatique du prix
     * @param client Client qui réserve
     * @param seance Séance du film
     * @param place Place réservée
     * @param typeBillet Type de billet (Adulte ou Enfant)
     * @return Billet créé et sauvegardé
     * @table billet INSERT
     * 
     * LOGIQUE:
     * - Vérifier que la place n'est pas réservée
     * - Récupérer le prix du type de place
     * - Appliquer réduction enfant si standard + enfant
     * - Créer et sauvegarder le billet
     */
    public Billet creerBillet(Client client, Seance seance, 
                             Place place, TypeBillet typeBillet);
    
    /**
     * Crée un billet pour un adulte
     * @param client Client
     * @param seance Séance
     * @param place Place
     * @return Billet adulte
     * @table billet INSERT, type_billet SELECT
     */
    public Billet creerBilletAdulte(Client client, Seance seance, Place place);
    
    /**
     * Crée un billet pour un enfant
     * @param client Client
     * @param seance Séance
     * @param place Place
     * @return Billet enfant
     * @table billet INSERT, type_billet SELECT
     */
    public Billet creerBilletEnfant(Client client, Seance seance, Place place);
    
    /**
     * Calcule le prix d'un billet selon le type de place et le type de billet
     * @param typePlaceLibelle "Standard", "Premium" ou "PMR"
     * @param isEnfant true si enfant, false si adulte
     * @return Double prix en Ariary
     * 
     * TARIFICATION:
     * - Standard + Adulte = 20 000Ar
     * - Standard + Enfant = 15 000Ar  (réduction!)
     * - Premium + Adulte = 50 000Ar
     * - Premium + Enfant = 50 000Ar   (pas de réduction)
     * - PMR + Adulte = 20 000Ar
     * - PMR + Enfant = 20 000Ar       (pas de réduction)
     */
    public Double calculerPrixBillet(String typePlaceLibelle, Boolean isEnfant);
    
    // Autres méthodes existantes (findByClient, findBySeance, isPlaceReserved)
}
```

### Classe: `RevenuService.java` ✅ CRÉÉE
```java
@Service
public class RevenuService {
    private final BilletRepository billetRepository;
    private final SeanceRepository seanceRepository;
    private final SalleRepository salleRepository;
    
    public static final Double PRIX_STANDARD_ADULTE = 20000.0;
    public static final Double PRIX_STANDARD_ENFANT = 15000.0;
    public static final Double PRIX_PREMIUM_ADULTE = 50000.0;
    
    /**
     * Calcule le chiffre d'affaires réel d'une séance (billets vendus)
     * @param idSeance ID de la séance
     * @return Double revenu total en Ariary
     * @table billet WHERE id_seance = ? SUM(prix)
     */
    public Double calculerRevenuSeance(Long idSeance);
    
    /**
     * Calcule le revenu d'une salle pour une date donnée
     * @param idSalle ID de la salle
     * @param date Date de la séance
     * @return Double revenu total en Ariary
     * @table seance JOIN billet 
     *        WHERE id_salle = ? AND date_seance = ? SUM(billet.prix)
     */
    public Double calculerRevenuSalleParDate(Long idSalle, LocalDate date);
    
    /**
     * Calcule le revenu d'une salle sur une période
     * @param idSalle ID de la salle
     * @param dateDebut Date début
     * @param dateFin Date fin
     * @return Double revenu total en Ariary
     * @table seance JOIN billet 
     *        WHERE id_salle = ? AND date_seance BETWEEN ? AND ? 
     *        SUM(billet.prix)
     */
    public Double calculerRevenuSallePeriode(Long idSalle, LocalDate dateDebut, LocalDate dateFin);
    
    /**
     * Calcule le prix avec réduction enfant si applicable
     * @param typePlaceLibelle Type de place
     * @param isEnfant true si enfant
     * @return Double prix en Ariary
     */
    public Double calculerPrixBillet(String typePlaceLibelle, Boolean isEnfant);
    
    /**
     * Obtient le détail du revenu d'une séance avec breakdown
     * @param idSeance ID de la séance
     * @return Map contenant:
     *   - idSeance: Long
     *   - film: String (titre)
     *   - salle: String (nom)
     *   - dateSeance: LocalDate
     *   - heureDebut: LocalTime
     *   - revenuStandard: Double (places standard)
     *   - revenuPremium: Double (places premium)
     *   - revenuTotal: Double
     *   - nombreBillets: Integer
     *   - nombreAdultes: Long
     *   - nombreEnfants: Long
     * @table seance JOIN billet JOIN place JOIN type_billet
     *        WHERE seance.id_seance = ?
     */
    public Map<String, Object> obtenirDetailRevenuSeance(Long idSeance);
    
    /**
     * Obtient le détail du revenu d'une salle pour une date
     * @param idSalle ID de la salle
     * @param date Date
     * @return Map contenant details par séance et agrégés
     * @table seance JOIN billet WHERE id_salle = ? AND date_seance = ?
     */
    public Map<String, Object> obtenirDetailRevenuSalleParDate(Long idSalle, LocalDate date);
}
```

---

## 4️⃣ CONTRÔLEURS (Package: `com.example.cinema.controller`)

### Classe: `BilletController.java` ✅ MODIFIÉE
```java
@Controller
@RequestMapping("/billets")
public class BilletController {
    private final BilletService billetService;
    private final SeanceService seanceService;
    private final ClientService clientService;
    private final PlaceService placeService;
    private final TypeBilletService typeBilletService;  // NOUVEAU
    
    /**
     * Affiche le formulaire de réservation
     * GET /billets/reserver/{idSeance}
     * 
     * @param idSeance ID de la séance
     * @param model Model Spring
     * @return String vue "billets/reserver"
     * 
     * LOGIQUE:
     * - Récupérer la séance
     * - Récupérer toutes les places disponibles
     * - Récupérer les types de billets (Adulte, Enfant)
     * - Ajouter au model: seance, placesDisponibles, typesBillets
     * 
     * @table seance JOIN salle JOIN place JOIN type_billet
     *        billet (pour places réservées)
     */
    @GetMapping("/reserver/{idSeance}")
    public String formReserver(@PathVariable Long idSeance, Model model);
    
    /**
     * Traite la soumission du formulaire de réservation
     * POST /billets/reserver/{idSeance}
     * 
     * @param idSeance ID de la séance
     * @param idPlaces[] Array des IDs de places sélectionnées
     * @param typesBillets[] Array des types de billets (IDs) sélectionnés
     * @param session HttpSession
     * @param model Model Spring
     * @return String redirection vers /seances/fiche/{idSeance}
     * 
     * LOGIQUE:
     * - Vérifier que le client est connecté
     * - Pour chaque place sélectionnée:
     *   - Récupérer la place
     *   - Récupérer le type de billet correspondant
     *   - Appeler billetService.creerBillet()
     *   - Le prix est calculé automatiquement
     * - Rediriger vers la fiche séance
     * 
     * @table billet INSERT (pour chaque place)
     */
    @PostMapping("/reserver/{idSeance}")
    public String reserver(@PathVariable Long idSeance,
                          @RequestParam(value = "idPlaces", required = false) Long[] idPlaces,
                          @RequestParam(value = "typesBillets", required = false) Long[] typesBillets,
                          HttpSession session,
                          Model model);
    
    /**
     * Affiche les réservations du client connecté
     * GET /billets/mes-reservations
     * 
     * @param session HttpSession
     * @param model Model Spring
     * @return String vue "billets/mes-reservations"
     * 
     * @table client JOIN billet JOIN seance JOIN place JOIN type_billet
     *        WHERE id_client = ? AND client is authenticated
     */
    @GetMapping("/mes-reservations")
    public String mesReservations(HttpSession session, Model model);
    
    /**
     * Affiche toutes les réservations (ADMIN)
     * GET /billets/toutes-reservations
     * 
     * @param model Model Spring
     * @return String vue "billets/toutes-reservations"
     * 
     * @table billet JOIN client JOIN seance JOIN place
     */
    @GetMapping("/toutes-reservations")
    public String toutesReservations(Model model);
    
    /**
     * Affiche le rapport financier avec statistiques enfants
     * GET /billets/rapport-financier
     * 
     * @param model Model Spring
     * @return String vue "billets/rapport-financier"
     * 
     * Ajoute au model:
     * - totalRevenu: Double (SUM de tous les billets)
     * - totalBillets: Integer (COUNT)
     * - totalAdultes: Long (COUNT WHERE type_billet.isEnfant = false)
     * - totalEnfants: Long (COUNT WHERE type_billet.isEnfant = true)
     * - revenuAdultes: Double (SUM prix WHERE type_billet.isEnfant = false)
     * - revenuEnfants: Double (SUM prix WHERE type_billet.isEnfant = true)
     * - revenueParFilm: Map<String, Double>
     * - revenueParSalle: Map<String, Double>
     * - revenueParDate: Map<String, Double>
     * 
     * @table billet JOIN type_billet JOIN seance JOIN film JOIN salle
     */
    @GetMapping("/rapport-financier")
    public String rapportFinancier(Model model);
}
```

### Classe: `RevenuController.java` ✅ CRÉÉE
```java
@RestController
@RequestMapping("/api/revenu")
public class RevenuController {
    private final RevenuService revenuService;
    
    /**
     * Calcule le CA réel d'une séance
     * GET /api/revenu/seance/{idSeance}
     * 
     * @param idSeance ID de la séance
     * @return ResponseEntity<RevenuDTO>
     * 
     * @table seance JOIN billet
     */
    @GetMapping("/seance/{idSeance}")
    public ResponseEntity<RevenuDTO> calculerRevenuSeance(@PathVariable Long idSeance);
    
    /**
     * Calcule le CA d'une salle pour une date
     * GET /api/revenu/salle/{idSalle}/date/{date}
     * 
     * @param idSalle ID de la salle
     * @param date Date (format: 2026-01-10)
     * @return ResponseEntity<RevenuDTO>
     * 
     * @table salle JOIN seance JOIN billet
     */
    @GetMapping("/salle/{idSalle}/date/{date}")
    public ResponseEntity<RevenuDTO> calculerRevenuSalleParDate(
        @PathVariable Long idSalle,
        @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date);
    
    /**
     * Calcule le prix d'un billet
     * GET /api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true
     * 
     * @param typePlaceLibelle "Standard", "Premium" ou "PMR"
     * @param isEnfant true ou false
     * @return ResponseEntity<Map> avec clés: typePlaceLibelle, isEnfant, prix
     */
    @GetMapping("/prix")
    public ResponseEntity<Map<String, Object>> calculerPrix(
        @RequestParam String typePlaceLibelle,
        @RequestParam Boolean isEnfant);
}
```

---

## 5️⃣ DATA TRANSFER OBJECTS (Package: `com.example.cinema.dto`)

### Classe: `RevenuDTO.java` (Peut être utilisé ou créé une version enrichie)
```java
public class RevenuDTO {
    private boolean success;
    private Double revenuMaximum;
    private Map<String, Object> detail;      // Détail avec enfants/adultes
    private String error;
    
    // Constructeurs, Getters/Setters
}
```

---

## 📊 REQUÊTES SQL CLÉS

```sql
-- 1. Créer la table type_billet
CREATE TABLE type_billet (
    id_type_billet SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    isEnfant BOOLEAN DEFAULT FALSE
);

-- 2. Ajouter la colonne à billet
ALTER TABLE billet ADD COLUMN id_type_billet INTEGER;
ALTER TABLE billet ADD CONSTRAINT fk_billet_type_billet 
    FOREIGN KEY (id_type_billet) REFERENCES type_billet(id_type_billet);

-- 3. Insérer les types de billets
INSERT INTO type_billet (libelle, isEnfant) VALUES
('Adulte', FALSE),
('Enfant', TRUE);

-- 4. Récupérer le revenu d'une séance avec enfants
SELECT 
    b.id_billet,
    s.id_seance,
    f.titre as film,
    p.rangee || p.numero as place,
    tp.libelle as type_place,
    tb.libelle as type_billet,
    tb.isEnfant,
    b.prix
FROM billet b
JOIN seance s ON b.id_seance = s.id_seance
JOIN film f ON s.id_film = f.id_film
JOIN place p ON b.id_place = p.id_place
JOIN type_place tp ON p.id_type_place = tp.id_type_place
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
WHERE s.id_seance = ?
ORDER BY b.id_billet;

-- 5. Revenu par type de billet (Adulte vs Enfant)
SELECT 
    tb.libelle,
    COUNT(b.id_billet) as nombre_billets,
    SUM(b.prix) as revenu_total
FROM billet b
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
GROUP BY tb.libelle;

-- 6. Revenu enfants pour une séance
SELECT SUM(b.prix) as revenu_enfants
FROM billet b
JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
WHERE b.id_seance = ? AND tb.isEnfant = TRUE;

-- 7. Revenu par salle et date avec détail enfants
SELECT 
    s.nom_salle,
    se.date_seance,
    COUNT(CASE WHEN tb.isEnfant = FALSE THEN 1 END) as adultes,
    COUNT(CASE WHEN tb.isEnfant = TRUE THEN 1 END) as enfants,
    SUM(b.prix) as revenu_total
FROM salle s
JOIN seance se ON s.id_salle = se.id_salle
LEFT JOIN billet b ON se.id_seance = b.id_seance
LEFT JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
WHERE s.id_salle = ? AND se.date_seance = ?
GROUP BY s.nom_salle, se.date_seance;
```

---

## 🎨 DESSINS D'ÉCRAN / MOCK-UPS

### 1️⃣ ÉCRAN: Réserver une place (reserver.jsp)

```
┌─────────────────────────────────────────────────────────────────┐
│  🎬 Cinéma Gestion - Réserver des places                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  📽️  AVATAR                                                      │
│  ├─ Salle: Salle A (Capacité: 100)   │  ⏰ Heure: 10:00        │
│  ├─ Date: 2026-01-10                 │  💰 Prix: 9000Ar        │
│  └─ [ℹ️ Tarif enfant: 15 000Ar] ⭐                              │
│                                                                   │
│  ✅ 5 places disponibles sur 100                                 │
│                                                                   │
│  Sélectionner les places et le type de billet:                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │ Place: Rang A - Numéro 1  [✓]  ◯Adulte   ◯Enfant            ││
│  │                                 (20 000Ar) (15 000Ar) ⭐      ││
│  │                                                                ││
│  │ Place: Rang A - Numéro 2  [ ]  ◯Adulte   ◯Enfant            ││
│  │                                 (20 000Ar) (15 000Ar) ⭐      ││
│  │                                                                ││
│  │ Place: Rang A - Numéro 3  [ ]  ◯Adulte   ◯Enfant            ││
│  │                                 (20 000Ar) (15 000Ar) ⭐      ││
│  │                                                                ││
│  │ Place: Rang B - Numéro 1  [ ]  ◯Adulte   ◯Enfant            ││
│  │ (Premium)                        (50 000Ar) (50 000Ar) ❌    ││
│  │                                                                ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                   │
│  💡 Légende:                                                     │
│  ⭐ = Réduction enfant appliquée                                 │
│  ❌ = Pas de réduction pour ce type de place                    │
│                                                                   │
│  [✅ Confirmer la réservation]  [🔄 Réinitialiser]             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### 2️⃣ ÉCRAN: Mes réservations (mes-reservations.jsp)

```
┌──────────────────────────────────────────────────────────────────────┐
│  🎫 Mes Réservations                                                  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  👤 Client: Jean Dupont (jean@example.com)                            │
│                                                                        │
│  📊 Résumé:                                                            │
│  ├─ Nombre de réservations: [3]                                       │
│  ├─ Dépense totale: [50 000Ar]                                        │
│  ├─ Billets adultes: [2]  👤                                          │
│  └─ Billets enfants: [1]  👶 ⭐                                      │
│                                                                        │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │ Film         │Salle   │Date       │Heure │Place    │Type    │Pr│  │
│  ├────────────────────────────────────────────────────────────────┤  │
│  │ AVATAR       │Salle A │2026-01-10 │10:00 │A-1      │👤 Adult│20│  │
│  │              │        │           │      │Standard │      │000│  │
│  │ AVATAR       │Salle A │2026-01-10 │10:00 │A-2      │👶 Enf │15│  │
│  │              │        │           │      │Standard │ ⭐  │000│  │
│  │ INCEPTION    │Salle B │2026-01-11 │14:00 │B-5      │👤 Adult│50│  │
│  │              │        │           │      │Premium  │      │000│  │
│  └────────────────────────────────────────────────────────────────┘  │
│                                                                        │
│  Légende: 👤 = Adulte, 👶 = Enfant, ⭐ = Prix réduit                │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

### 3️⃣ ÉCRAN: Rapport financier (rapport-financier.jsp)

```
┌────────────────────────────────────────────────────────────────────────┐
│  💰 Rapport Financier                                                   │
├────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────┬──────────────┬──────────────┬──────────────────────┐ │
│  │ CA Total     │ Nb Billets   │ CA Moyen     │ Répartition Clients  │ │
│  │ 85 000Ar     │ 5            │ 17 000Ar     │ Adultes: 3           │ │
│  │              │              │              │ Enfants: 2           │ │
│  └──────────────┴──────────────┴──────────────┴──────────────────────┘ │
│                                                                          │
│  ┌──────────────────────────────┐  ┌──────────────────────────────────┐ │
│  │ 👤 Revenu Adultes            │  │ 👶 Revenu Enfants (Réduction)    │ │
│  │                              │  │                                  │ │
│  │ CA: 60 000Ar                 │  │ CA: 25 000Ar                     │ │
│  │ Billets: 3                   │  │ Billets: 2                       │ │
│  │ Moyen/billet: 20 000Ar       │  │ Moyen/billet: 12 500Ar           │ │
│  │                              │  │ Économie enfants: 10 000Ar ⭐   │ │
│  └──────────────────────────────┘  └──────────────────────────────────┘ │
│                                                                          │
│  📈 Détail par Film:                                                    │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ Film         │ Revenu        │ % du Total                         │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │ AVATAR       │ 50 000Ar      │ ███████████████░░░░░░░ 58%        │  │
│  │ INCEPTION    │ 35 000Ar      │ ████████░░░░░░░░░░░░░░ 42%        │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  📊 Détail par Salle:                                                   │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ Salle     │ Revenu        │ % du Total                            │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │ Salle A   │ 65 000Ar      │ ████████████████░░░░░░░ 76%          │  │
│  │ Salle B   │ 20 000Ar      │ █████░░░░░░░░░░░░░░░░░░░ 24%         │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
└────────────────────────────────────────────────────────────────────────┘
```

### 4️⃣ ÉCRAN: Panel Admin - Toutes les réservations

```
┌────────────────────────────────────────────────────────────────────────┐
│  📋 Toutes les Réservations (ADMIN)                                     │
├────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Total de billets: [15]   |  Revenu total: [250 000Ar]                │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐│
│  │ Billet │ Client    │ Film     │ Salle   │ Date      │Type    │ Pr  ││
│  ├────────────────────────────────────────────────────────────────────┤│
│  │ 1      │ J. Dupont │ AVATAR   │ Salle A │2026-01-10│👤 Adulte│20k ││
│  │ 2      │ J. Dupont │ AVATAR   │ Salle A │2026-01-10│👶 Enf ⭐│15k ││
│  │ 3      │ M. Martin │ INCEPTION│ Salle B │2026-01-11│👤 Adulte│50k ││
│  │ 4      │ P. Nguyen │ AVATAR   │ Salle A │2026-01-10│👤 Adulte│20k ││
│  │ 5      │ S. Claire │ INCEPTION│ Salle C │2026-01-12│👶 Enf ⭐│15k ││
│  └────────────────────────────────────────────────────────────────────┘│
│                                                                          │
└────────────────────────────────────────────────────────────────────────┘
```

### 5️⃣ SCHÉMA DE FLUX: Réservation avec calcul prix

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FLUX DE RÉSERVATION J3                            │
└─────────────────────────────────────────────────────────────────────┘

CLIENT
  │
  ├─→ Sélectionne place + type (Adulte/Enfant)
  │
  └─→ POST /billets/reserver/{idSeance}
         │
         ├─ Paramètres: idPlaces[], typesBillets[]
         │
         └─→ BilletController.reserver()
                │
                ├─ Pour chaque place:
                │  │
                │  ├─ Récupérer: Client, Seance, Place, TypeBillet
                │  │
                │  └─ BilletService.crierBillet(client, seance, place, typeBillet)
                │     │
                │     ├─ Vérifier place non réservée
                │     │
                │     ├─ Récupérer type de place (Standard/Premium)
                │     │
                │     └─ BilletService.calculerPrixBillet(typePlaceLibelle, isEnfant)
                │        │
                │        ├─ SI Standard + Enfant → 15 000Ar ✅
                │        ├─ SI Standard + Adulte → 20 000Ar
                │        ├─ SI Premium + * → 50 000Ar (pas de réduction)
                │        └─ Retourner prix
                │
                ├─ Créer objet Billet:
                │  {
                │    client: Client
                │    seance: Seance
                │    place: Place
                │    typeBillet: TypeBillet (Adulte ou Enfant)
                │    prix: Double (calculé automatiquement)
                │    idStatutBillet: 1 (réservé)
                │  }
                │
                └─ BilletRepository.save(billet)
                   │
                   └─ INSERT INTO billet
                      (id_client, id_seance, id_place, id_type_billet, prix, ...)
                      VALUES (?, ?, ?, ?, ?, ...)
                          ↓
                    BASE DE DONNÉES ✅

CLIENT
  │
  ├─ Reçoit confirmation
  │
  └─ Voit billet crée avec prix correct!
```

---

## 📌 RÉSUMÉ DES CLASSES À IMPLÉMENTER

| Classe | Type | Package | Statut | Fonction clé |
|--------|------|---------|--------|------------|
| **TypeBillet** | Model | model | ✅ Créée | Distinguer Adulte/Enfant |
| **Billet** | Model | model | ✅ Modifiée | Ajouter typeBillet |
| **TypeBilletRepository** | Interface | repository | ✅ Créée | Requêtes sur type_billet |
| **BilletRepository** | Interface | repository | ✅ Modifiée | Requêtes sur billet |
| **SeanceRepository** | Interface | repository | ✅ Modifiée | Requêtes par date |
| **TypeBilletService** | Service | service | ✅ Créée | Gérer types de billets |
| **BilletService** | Service | service | ✅ Modifiée | crierBillet(), calculerPrixBillet() |
| **RevenuService** | Service | service | ✅ Créée | Calcul CA avec enfants |
| **BilletController** | Controller | controller | ✅ Modifié | Ajuster POST pour enfants |
| **RevenuController** | Controller | controller | ✅ Créé | API REST revenu |

---

## 🔗 DÉPENDANCES ENTRE CLASSES

```
TypeBillet
    ↑
    │ uses
    │
BilletService ←── TypeBilletService
    │              
    ├─→ BilletRepository
    ├─→ SeanceRepository
    └─→ SalleRepository
         │
         └─→ RevenuService

BilletController
    ├─→ BilletService
    ├─→ SeanceService
    ├─→ ClientService
    ├─→ PlaceService
    └─→ TypeBilletService

RevenuController
    └─→ RevenuService
```

---

## 📋 CHECKLIST D'IMPLÉMENTATION

- [x] Créer classe TypeBillet.java
- [x] Modifier classe Billet.java
- [x] Créer interface TypeBilletRepository.java
- [x] Modifier interface BilletRepository.java
- [x] Modifier interface SeanceRepository.java
- [x] Créer classe TypeBilletService.java
- [x] Modifier classe BilletService.java (ajouter typeBilletService + méthodes)
- [x] Créer classe RevenuService.java
- [x] Modifier classe BilletController.java
- [x] Créer classe RevenuController.java
- [x] Modifier reserver.jsp (ajouter sélecteur adulte/enfant)
- [x] Modifier mes-reservations.jsp (afficher type billet)
- [x] Modifier rapport-financier.jsp (afficher stats enfants)
- [x] Créer script SQL MIGRATION
- [x] Tester flux complet de réservation

