-- ============================
-- BASE DE DONNÉES : CINEMA
-- PostgreSQL
-- ============================
-- ============================
-- TABLE : genre
-- ============================
CREATE TABLE
    genre (
        id_genre SERIAL PRIMARY KEY,
        libelle VARCHAR(50) NOT NULL UNIQUE
    );

-- ============================
-- TABLE : classification_age
-- ============================
CREATE TABLE
    classification_age (
        id_classification SERIAL PRIMARY KEY,
        code VARCHAR(10) NOT NULL UNIQUE,
        description VARCHAR(100)
    );

-- ============================
-- TABLE : type_projection
-- ============================
CREATE TABLE
    type_projection (
        id_type_projection SERIAL PRIMARY KEY,
        libelle VARCHAR(30) NOT NULL UNIQUE
    );

-- =========================================
-- TABLE DES TYPES DE PLACE
-- =========================================
CREATE TABLE
    type_place (
        id_type_place SERIAL PRIMARY KEY,
        libelle VARCHAR(50) NOT NULL UNIQUE
    );

-- ============================
-- TABLE : statut_paiement
-- ============================
CREATE TABLE
    statut_paiement (
        id_statut_paiement INTEGER PRIMARY KEY,
        libelle VARCHAR(30) NOT NULL UNIQUE
    );

-- ============================
-- TABLE : statut_billet
-- ============================
CREATE TABLE
    statut_billet (
        id_statut_billet INTEGER PRIMARY KEY,
        libelle VARCHAR(30) NOT NULL UNIQUE
    );

-- ============================
-- TABLE : mode_paiement
-- ============================
CREATE TABLE
    mode_paiement (
        id_mode_paiement SERIAL PRIMARY KEY,
        libelle VARCHAR(30) NOT NULL UNIQUE
    );

-- ============================
-- TABLE : client
-- ============================
CREATE TABLE
    client (
        id_client SERIAL PRIMARY KEY,
        nom VARCHAR(100) NOT NULL,
        prenom VARCHAR(100) NOT NULL,
        email VARCHAR(150) UNIQUE,
        Motdepasse VARCHAR(100),
        telephone VARCHAR(20)
    );

-- =========================================
-- TABLE DES TARIFS
-- =========================================
CREATE TABLE
    tarif (
        id_tarif SERIAL PRIMARY KEY,
        libelle VARCHAR(100) NOT NULL,
        prix NUMERIC(8, 2) NOT NULL CHECK (prix >= 0),
        priorite INTEGER NOT NULL DEFAULT 1,
        actif BOOLEAN NOT NULL DEFAULT TRUE
    );

-- =========================================
-- TABLE DES TYPES DE CONDITION
-- =========================================
CREATE TABLE
    type_condition (
        id_type_condition SERIAL PRIMARY KEY,
        code VARCHAR(50) NOT NULL UNIQUE,
        description VARCHAR(255)
    );

-- ============================
-- TABLE : film
-- ============================
CREATE TABLE
    film (
        id_film SERIAL PRIMARY KEY,
        titre VARCHAR(150) NOT NULL,
        description TEXT,
        duree_minutes INTEGER NOT NULL CHECK (duree_minutes > 0),
        date_sortie DATE,
        id_genre INTEGER NOT NULL,
        id_classification INTEGER NOT NULL,
        CONSTRAINT fk_film_genre FOREIGN KEY (id_genre) REFERENCES genre (id_genre),
        CONSTRAINT fk_film_classification FOREIGN KEY (id_classification) REFERENCES classification_age (id_classification)
    );

-- ============================
-- TABLE : salle
-- ============================
CREATE TABLE
    salle (
        id_salle SERIAL PRIMARY KEY,
        nom VARCHAR(50) NOT NULL,
        capacite INTEGER NOT NULL CHECK (capacite > 0),
        id_type_projection INTEGER NOT NULL,
        CONSTRAINT fk_salle_type_projection FOREIGN KEY (id_type_projection) REFERENCES type_projection (id_type_projection)
    );

-- =========================================
-- TABLE DES PLACES
-- =========================================
CREATE TABLE
    place (
        id_place SERIAL PRIMARY KEY,
        rangee VARCHAR(5) NOT NULL,
        numero INTEGER NOT NULL,
        id_salle INTEGER NOT NULL,
        id_type_place INTEGER NOT NULL,
        CONSTRAINT fk_place_salle FOREIGN KEY (id_salle) REFERENCES salle (id_salle),
        CONSTRAINT fk_place_type FOREIGN KEY (id_type_place) REFERENCES type_place (id_type_place),
        CONSTRAINT uq_place_salle UNIQUE (id_salle, rangee, numero)
    );

-- ============================
-- TABLE : seance
-- ============================
CREATE TABLE
    seance (
        id_seance SERIAL PRIMARY KEY,
        date_seance DATE NOT NULL,
        heure_debut TIME NOT NULL,
        prix_base NUMERIC(8, 2) NOT NULL CHECK (prix_base >= 0),
        id_film INTEGER NOT NULL,
        id_salle INTEGER NOT NULL,
        CONSTRAINT fk_seance_film FOREIGN KEY (id_film) REFERENCES film (id_film),
        CONSTRAINT fk_seance_salle FOREIGN KEY (id_salle) REFERENCES salle (id_salle)
    );

-- =========================================
-- TABLE DES CONDITIONS TARIFAIRES
-- =========================================
CREATE TABLE
    condition_tarifaire (
        id_condition SERIAL PRIMARY KEY,
        id_tarif INTEGER NOT NULL,
        id_type_condition INTEGER NOT NULL,
        valeur VARCHAR(50) NOT NULL,
        CONSTRAINT fk_condition_tarifaire_tarif FOREIGN KEY (id_tarif) REFERENCES tarif (id_tarif),
        CONSTRAINT fk_condition_tarifaire_type FOREIGN KEY (id_type_condition) REFERENCES type_condition (id_type_condition)
    );

-- =========================================
-- TABLE DES BILLETS (avec tarif final appliqué)
-- =========================================
CREATE TABLE
    billet (
        id_billet SERIAL PRIMARY KEY,
        date_achat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        id_client INTEGER NOT NULL DEFAULT 1,
        id_seance INTEGER NOT NULL,
        id_place INTEGER NOT NULL,
        id_statut_billet INTEGER NOT NULL,
        prix NUMERIC(8, 2) NOT NULL,
        CONSTRAINT fk_billet_client FOREIGN KEY (id_client) REFERENCES client (id_client),
        CONSTRAINT fk_billet_seance FOREIGN KEY (id_seance) REFERENCES seance (id_seance),
        CONSTRAINT fk_billet_place FOREIGN KEY (id_place) REFERENCES place (id_place),
        CONSTRAINT uq_billet_place_seance UNIQUE (id_seance, id_place)
    );

-- =========================================
-- TABLE HISTORIQUE DES STATUTS DE BILLETS
-- =========================================
CREATE TABLE
    historique_statut_billet (
        id_historique SERIAL PRIMARY KEY,
        id_billet INTEGER NOT NULL,
        ancien_statut INTEGER NOT NULL,
        nouveau_statut INTEGER NOT NULL,
        date_changement TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_historique_billet FOREIGN KEY (id_billet) REFERENCES billet (id_billet)
    );

-- Optionnel : créer un index pour accélérer les recherches par billet
CREATE INDEX idx_historique_billet_id ON historique_statut_billet (id_billet);

-- ============================
-- TABLE : paiement
-- ============================
CREATE TABLE
    paiement (
        id_paiement SERIAL PRIMARY KEY,
        montant NUMERIC(8, 2) NOT NULL CHECK (montant > 0),
        date_paiement TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        id_mode_paiement INTEGER NOT NULL,
        id_statut_paiement INTEGER NOT NULL,
        id_billet INTEGER NOT NULL,
        CONSTRAINT fk_paiement_mode FOREIGN KEY (id_mode_paiement) REFERENCES mode_paiement (id_mode_paiement),
        CONSTRAINT fk_paiement_statut FOREIGN KEY (id_statut_paiement) REFERENCES statut_paiement (id_statut_paiement),
        CONSTRAINT fk_paiement_billet FOREIGN KEY (id_billet) REFERENCES billet (id_billet)
    );

-- =========================================
-- INSERTS EXEMPLES
-- Rassembler toutes les insertions après les CREATE TABLE
-- =========================================
-- Client générique (client lambda)
INSERT INTO
    client (id_client, nom, prenom, email, telephone)
VALUES
    (1, 'CLIENT', 'ANONYME', NULL, NULL);

-- Exemple d'insertion des types de condition
INSERT INTO
    type_condition (code, description)
VALUES
    ('FILM', 'Condition liée à un film'),
    ('SALLE', 'Condition liée à une salle'),
    ('TYPE_SALLE', 'Condition liée au type de salle'),
    ('JOUR', 'Condition liée au jour de la semaine'),
    ('HEURE', 'Condition liée à l heure'),
    ('PLACE', 'Condition liée à une place spécifique'),
    ('TYPE_PLACE', 'Condition liée au type de place');

-- Exemple d'insertion des types de place
INSERT INTO
    type_place (libelle)
VALUES
    ('Standard'),
    ('VIP'),
    ('Couple'),
    ('PMR');