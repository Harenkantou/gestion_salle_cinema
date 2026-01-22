-- =====================================
-- SCRIPT AMÉLIORÉ POUR GESTION DE CINÉMA
-- Structure uniquement (sans insertions de données)
-- Avec flexibilité pour nouvelles règles et fonctionnalités
-- =====================================

-- =====================================
-- 1. SUPPRESSION DES ANCIENNES TABLES (optionnel)
-- =====================================
DROP TABLE IF EXISTS billet CASCADE;
DROP TABLE IF EXISTS seance CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS type_place CASCADE;
DROP TABLE IF EXISTS remises CASCADE;
DROP TABLE IF EXISTS prix_base CASCADE;
DROP TABLE IF EXISTS categories_age CASCADE;
DROP TABLE IF EXISTS film CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS salle CASCADE;

-- =====================================
-- 2. CRÉATION DES TABLES AMÉLIORÉES
-- =====================================

-- Table: SALLE
CREATE TABLE salle (
    id_salle   SERIAL PRIMARY KEY,
    nom_salle  VARCHAR(50) NOT NULL,
    capacite   INTEGER NOT NULL,
    statut     BOOLEAN DEFAULT TRUE,  -- TRUE = disponible, FALSE = indisponible
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: GENRE
CREATE TABLE genre (
    id_genre SERIAL PRIMARY KEY,
    nom_genre VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Table: FILM
CREATE TABLE film (
    id_film        SERIAL PRIMARY KEY,
    titre          VARCHAR(150) NOT NULL,
    description_film TEXT,
    duree_minutes  INTEGER NOT NULL,
    id_genre       INTEGER REFERENCES genre(id_genre),
    date_sortie    DATE,
    image          VARCHAR(255),
    statut         VARCHAR(20) DEFAULT 'ACTIF' CHECK (statut IN ('ACTIF','INACTIF')),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: SEANCE
CREATE TABLE seance (
    id_seance   SERIAL PRIMARY KEY,
    id_film     INTEGER NOT NULL REFERENCES film(id_film),
    id_salle    INTEGER NOT NULL REFERENCES salle(id_salle),
    date_seance DATE NOT NULL,
    heure_debut TIME NOT NULL,
    statut      BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_salle, date_seance, heure_debut)
);

-- Table: CLIENT
CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    motdepasse VARCHAR(100),
    telephone VARCHAR(20)
);

-- Table: TYPE_PLACE
CREATE TABLE type_place (
    id_type_place SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: CATEGORIES_AGE
CREATE TABLE categories_age (
    id_categorie_age SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,  -- e.g., 'Enfant', 'Ado', 'Adulte'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: PRIX_BASE
CREATE TABLE prix_base (
    id_prix_base SERIAL PRIMARY KEY,
    id_type_place INTEGER NOT NULL REFERENCES type_place(id_type_place),
    id_categorie_age INTEGER NOT NULL REFERENCES categories_age(id_categorie_age),
    prix NUMERIC(10,2) NOT NULL CHECK (prix >= 0),
    UNIQUE (id_type_place, id_categorie_age),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: REMISES
CREATE TABLE remises (
    id_remise SERIAL PRIMARY KEY,
    id_categorie_age INTEGER REFERENCES categories_age(id_categorie_age),
    id_type_place INTEGER REFERENCES type_place(id_type_place),  -- NULL pour remise générale
    type_remise VARCHAR(20) CHECK (type_remise IN ('pourcentage', 'montant')),
    valeur NUMERIC(10,2) NOT NULL CHECK (valeur >= 0),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: PLACE
CREATE TABLE place (
    id_place SERIAL PRIMARY KEY,
    rangee VARCHAR(5) NOT NULL,
    numero INTEGER NOT NULL,
    id_salle INTEGER NOT NULL,
    id_type_place INTEGER NOT NULL,
    CONSTRAINT fk_place_salle FOREIGN KEY (id_salle) REFERENCES salle (id_salle),
    CONSTRAINT fk_place_type FOREIGN KEY (id_type_place) REFERENCES type_place (id_type_place),
    CONSTRAINT uq_place_salle UNIQUE (id_salle, rangee, numero)
);

-- Table: BILLET
CREATE TABLE billet (
    id_billet SERIAL PRIMARY KEY,
    date_achat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_client INTEGER NOT NULL DEFAULT 1,
    id_seance INTEGER NOT NULL,
    id_place INTEGER NOT NULL,
    id_categorie_age INTEGER NOT NULL,
    prix NUMERIC(8, 2) NOT NULL,
    CONSTRAINT fk_billet_client FOREIGN KEY (id_client) REFERENCES client (id_client),
    CONSTRAINT fk_billet_seance FOREIGN KEY (id_seance) REFERENCES seance (id_seance),
    CONSTRAINT fk_billet_place FOREIGN KEY (id_place) REFERENCES place (id_place),
    CONSTRAINT fk_billet_categorie FOREIGN KEY (id_categorie_age) REFERENCES categories_age (id_categorie_age),
    CONSTRAINT uq_billet_place_seance UNIQUE (id_seance, id_place)
);

-- Index pour performance
CREATE INDEX idx_seance_date ON seance(date_seance);
CREATE INDEX idx_billet_seance ON billet(id_seance);
CREATE INDEX idx_place_salle ON place(id_salle);

-- =====================================
-- 3. FONCTIONS POUR CALCULS DYNAMIQUES
-- =====================================

-- Fonction pour calculer le prix d'un billet (avec remises)
CREATE OR REPLACE FUNCTION calcul_prix_billet(
    p_id_type_place INTEGER,
    p_id_categorie_age INTEGER
) RETURNS NUMERIC AS $$
DECLARE
    prix_base_val NUMERIC;
    remise_val NUMERIC := 0;
BEGIN
    -- Récupérer le prix de base
    SELECT prix INTO prix_base_val
    FROM prix_base
    WHERE id_type_place = p_id_type_place AND id_categorie_age = p_id_categorie_age;
    
    IF prix_base_val IS NULL THEN
        RAISE EXCEPTION 'Prix de base non trouvé pour type_place % et categorie_age %', p_id_type_place, p_id_categorie_age;
    END IF;
    
    -- Appliquer remise si active
    SELECT CASE 
        WHEN type_remise = 'pourcentage' THEN prix_base_val * (valeur / 100)
        ELSE valeur 
    END INTO remise_val
    FROM remises
    WHERE (id_categorie_age = p_id_categorie_age OR id_categorie_age IS NULL)
      AND (id_type_place = p_id_type_place OR id_type_place IS NULL)
      AND active = TRUE
    LIMIT 1;
    
    RETURN GREATEST(prix_base_val - remise_val, 0);
END;
$$ LANGUAGE plpgsql;

-- Fonction pour revenu maximum d'une salle (somme des prix adultes pour toutes les places)
CREATE OR REPLACE FUNCTION revenu_max_salle(p_id_salle INTEGER) RETURNS NUMERIC AS $$
DECLARE
    id_adulte INTEGER;
BEGIN
    SELECT id_categorie_age INTO id_adulte FROM categories_age WHERE libelle = 'Adulte';
    RETURN COALESCE((
        SELECT SUM(calcul_prix_billet(p.id_type_place, id_adulte))
        FROM place p
        WHERE p.id_salle = p_id_salle
    ), 0);
END;
$$ LANGUAGE plpgsql;

-- =====================================
-- 4. VUES ET REQUÊTES
-- =====================================

-- Vue pour résumé des salles avec revenu max
CREATE VIEW v_resume_salles AS
SELECT 
    s.nom_salle,
    s.capacite,
    COUNT(p.id_place) AS places_configurees,
    revenu_max_salle(s.id_salle) AS revenu_max
FROM salle s
LEFT JOIN place p ON s.id_salle = p.id_salle
GROUP BY s.id_salle, s.nom_salle, s.capacite;

-- Exemple de requête pour calculer le CA d'une séance (remplacez 1 par l'ID réel)
-- SELECT SUM(prix) AS ca FROM billet WHERE id_seance = 1;

-- Affichage du résumé des salles
SELECT * FROM v_resume_salles;