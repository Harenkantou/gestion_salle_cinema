-- =====================================
-- SCRIPT DE CRÉATION COMPLET
-- Gestion de Cinéma - Nouvelle Fonctionnalité
-- =====================================
-- Ce script crée toutes les tables et insère les données test
-- pour la fonctionnalité de calcul du revenu maximum par salle

-- =====================================
-- 1. SUPPRESSION DES ANCIENNES TABLES (optionnel)
-- =====================================
DROP TABLE IF EXISTS billet CASCADE;
DROP TABLE IF EXISTS seance CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS type_place CASCADE;
DROP TABLE IF EXISTS film CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS salle CASCADE;

-- =====================================
-- 2. CRÉATION DES TABLES
-- =====================================

-- Table: SALLE
CREATE TABLE salle (
    id_salle   SERIAL PRIMARY KEY,
    nom_salle  VARCHAR(50) NOT NULL,
    capacite   INTEGER NOT NULL,
    statut     BOOLEAN DEFAULT TRUE,  -- TRUE = dispo, FALSE = indisponible
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
    prix        NUMERIC(8,2) NOT NULL,
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

INSERT INTO client (nom, prenom, email, motdepasse, telephone) VALUES
('test', 'test', 'test@gmail.com','test','0000000000');


-- Table: TYPE_PLACE (NOUVELLE AVEC PRIX)
CREATE TABLE type_place (
    id_type_place SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    prix NUMERIC(8,2) NOT NULL  -- Prix en Ariary
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


-- Table: TYPE_BILLET (pour distinguer adulte, enfant, etc.)
CREATE TABLE type_billet (
    id_type_billet SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    isEnfant BOOLEAN DEFAULT FALSE NOT NULL
);

-- Table: BILLET
CREATE TABLE billet (
    id_billet SERIAL PRIMARY KEY,
    date_achat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_client INTEGER NOT NULL DEFAULT 1,
    id_seance INTEGER NOT NULL,
    id_place INTEGER NOT NULL,
    id_statut_billet INTEGER NOT NULL,
    id_type_billet INTEGER,
    prix NUMERIC(8, 2) NOT NULL,
    CONSTRAINT fk_billet_client FOREIGN KEY (id_client) REFERENCES client (id_client),
    CONSTRAINT fk_billet_seance FOREIGN KEY (id_seance) REFERENCES seance (id_seance),
    CONSTRAINT fk_billet_place FOREIGN KEY (id_place) REFERENCES place (id_place),
    CONSTRAINT fk_billet_type_billet FOREIGN KEY (id_type_billet) REFERENCES type_billet (id_type_billet),
    CONSTRAINT uq_billet_place_seance UNIQUE (id_seance, id_place)
);

CREATE TABLE prop_diffusion(
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50)
    

);

CREATE TABLE diffusion_seance(
    id SERIAL PRIMARY kEY,
    id_prop_diffusion INTEGER NOT NULL REFERENCES prop_diffusion(id),
    id_seance INTEGER NOT NULL REFERENCES seance(id_seance),
    date_diffusion DATE NOT NULL,
    prix NUMERIC(8,2) NOT NULL

);

-- Table: PAIEMENT_SOCIETE pour tracker les paiements par société
CREATE TABLE paiement_societe (
    id_paiement SERIAL PRIMARY KEY,
    id_prop_diffusion INTEGER NOT NULL REFERENCES prop_diffusion(id),
    montant NUMERIC(12,2) NOT NULL,
    date_paiement DATE NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Propositions : une par société
    INSERT INTO prop_diffusion (nom) VALUES
    ('Lewis'),
    ('Vaniala');

-- INSERTION DES PAIEMENTS SOCIETE
-- Paiement Vaniala: 1000000 AR le 15 Décembre 2025
INSERT INTO paiement_societe (id_prop_diffusion, montant, date_paiement, description) 
VALUES (
    (SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'),
    1000000,
    '2025-12-15',
    'Paiement partiel - Acompte sur diffusion'
);

-- Paiement Lewis: exemple
INSERT INTO paiement_societe (id_prop_diffusion, montant, date_paiement, description) 
VALUES (
    (SELECT id FROM prop_diffusion WHERE nom = 'Lewis'),
    1500000,
    '2025-12-10',
    'Paiement partiel - Acompte'
);

-- Diffusions de Lewis (10)
INSERT INTO diffusion_seance (id_prop_diffusion, id_seance, date_diffusion, prix) VALUES
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 1, '2025-12-01', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 2, '2025-12-02', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 3, '2025-12-03', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 4, '2025-12-04', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 5, '2025-12-05', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 1, '2025-12-06', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 2, '2025-12-07', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 3, '2025-12-08', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 4, '2025-12-09', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Lewis'), 5, '2025-12-10', 200000);

-- Diffusions de Vaniala (20) 
INSERT INTO diffusion_seance (id_prop_diffusion, id_seance, date_diffusion, prix) VALUES
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 1, '2025-12-11', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 2, '2025-12-12', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 3, '2025-12-13', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 4, '2025-12-14', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 5, '2025-12-15', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 1, '2025-12-16', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 2, '2025-12-17', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 3, '2025-12-18', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 4, '2025-12-19', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 5, '2025-12-20', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 1, '2025-12-21', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 2, '2025-12-22', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 3, '2025-12-23', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 4, '2025-12-24', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 5, '2025-12-25', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 1, '2025-12-26', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 2, '2025-12-27', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 3, '2025-12-28', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 4, '2025-12-29', 200000),
((SELECT id FROM prop_diffusion WHERE nom = 'Vaniala'), 5, '2025-12-30', 200000);






-- =====================================
-- 3. INSERTION DES DONNÉES
-- =====================================

-- Types de Place avec Tarifs (en Ariary)
INSERT INTO type_place (libelle, prix) VALUES
('Standard', 20000),
('Premium', 50000),
('PMR', 20000);

-- Types de Billet (Adulte et Enfant)
INSERT INTO type_billet (libelle, isEnfant) VALUES
('Adulte', FALSE),
('Enfant', TRUE);

-- Genres
INSERT INTO genre (nom_genre, description) VALUES
('Action', 'Films avec beaucoup d''action et de suspense'),
('Comedie', 'Films destines à faire rire'),
('Drame', 'Films serieux avec une forte charge emotionnelle'),
('Science-Fiction', 'Films bases sur la science ou le futur'),
('Horreur', 'Films destines à faire peur');

-- Salles
INSERT INTO salle (nom_salle, capacite, statut) VALUES
('Salle A', 100, TRUE),
('Salle B', 80, TRUE),
('Salle C', 120, TRUE),
('Salle D', 60, FALSE),
('Salle E', 150, TRUE);

-- Films
INSERT INTO film (titre, description_film, duree_minutes, id_genre, date_sortie, image, statut) VALUES
('Inception', 'Un voleur qui s''introduit dans les rêves pour voler des secrets.', 148, 4, '2010-07-16', 'inception.jpg', 'ACTIF'),
('Avengers: Endgame', 'Les super-heros se reunissent pour vaincre Thanos.', 181, 1, '2019-04-24', 'avengers_endgame.jpg', 'ACTIF'),
('La La Land', 'Une histoire d''amour entre une actrice et un musicien.', 128, 3, '2016-12-09', 'la_la_land.jpg', 'ACTIF'),
('Get Out', 'Un jeune homme decouvre un terrible secret en visitant la famille de sa petite amie.', 104, 5, '2017-02-24', 'get_out.jpg', 'ACTIF'),
('Interstellar', 'Des explorateurs voyagent à travers un trou de ver pour sauver l''humanite.', 169, 4, '2014-11-07', 'interstellar.jpg', 'ACTIF'),
('Avatar', 'Un ex-Marine se retrouve sur Pandora, une lune extraterrestre, et decouvre un monde merveilleux mais hostile.', 162, 4, '2009-12-18', 'avatar.jpg', 'ACTIF');

-- Clients
INSERT INTO client (nom, prenom, email, motdepasse, telephone) VALUES
('Dupont', 'Jean', 'jean.dupont@example.com', 'mdp123', '0612345678'),
('Martin', 'Claire', 'claire.martin@example.com', 'mdp123', '0623456789'),
('Nguyen', 'Paul', 'paul.nguyen@example.com', 'mdp123', '0634567890');

-- =====================================
-- 4. INSERTION DES PLACES
-- =====================================

-- SALLE A : 40 Standard + 40 Premium = 80 places
-- Revenu max = (40 × 20000) + (40 × 50000) = 800000 + 2000000 = 2800000 Ar

-- Places Standard (id_type_place = 1)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('A', 1, 1, 1), ('A', 2, 1, 1), ('A', 3, 1, 1), ('A', 4, 1, 1), ('A', 5, 1, 1),
('B', 1, 1, 1), ('B', 2, 1, 1), ('B', 3, 1, 1), ('B', 4, 1, 1), ('B', 5, 1, 1),
('C', 1, 1, 1), ('C', 2, 1, 1), ('C', 3, 1, 1), ('C', 4, 1, 1), ('C', 5, 1, 1),
('D', 1, 1, 1), ('D', 2, 1, 1), ('D', 3, 1, 1), ('D', 4, 1, 1), ('D', 5, 1, 1),
('E', 1, 1, 1), ('E', 2, 1, 1), ('E', 3, 1, 1), ('E', 4, 1, 1), ('E', 5, 1, 1),
('F', 1, 1, 1), ('F', 2, 1, 1), ('F', 3, 1, 1), ('F', 4, 1, 1), ('F', 5, 1, 1),
('G', 1, 1, 1), ('G', 2, 1, 1), ('G', 3, 1, 1), ('G', 4, 1, 1), ('G', 5, 1, 1),
('H', 1, 1, 1), ('H', 2, 1, 1), ('H', 3, 1, 1), ('H', 4, 1, 1), ('H', 5, 1, 1);

-- Places Premium (id_type_place = 2) - Using rangees I-P to avoid conflicts with Standard
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('I', 1, 1, 2), ('I', 2, 1, 2), ('I', 3, 1, 2), ('I', 4, 1, 2), ('I', 5, 1, 2),
('J', 1, 1, 2), ('J', 2, 1, 2), ('J', 3, 1, 2), ('J', 4, 1, 2), ('J', 5, 1, 2),
('K', 1, 1, 2), ('K', 2, 1, 2), ('K', 3, 1, 2), ('K', 4, 1, 2), ('K', 5, 1, 2),
('L', 1, 1, 2), ('L', 2, 1, 2), ('L', 3, 1, 2), ('L', 4, 1, 2), ('L', 5, 1, 2),
('M', 1, 1, 2), ('M', 2, 1, 2), ('M', 3, 1, 2), ('M', 4, 1, 2), ('M', 5, 1, 2),
('N', 1, 1, 2), ('N', 2, 1, 2), ('N', 3, 1, 2), ('N', 4, 1, 2), ('N', 5, 1, 2),
('O', 1, 1, 2), ('O', 2, 1, 2), ('O', 3, 1, 2), ('O', 4, 1, 2), ('O', 5, 1, 2),
('P', 1, 1, 2), ('P', 2, 1, 2), ('P', 3, 1, 2), ('P', 4, 1, 2), ('P', 5, 1, 2);

-- SALLE B : 30 Standard + 20 Premium + 2 PMR = 52 places
-- Revenu max = (30 × 20000) + (20 × 50000) + (2 × 20000) = 600000 + 1000000 + 40000 = 1640000 Ar

-- Places Standard (id_type_place = 1)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('A', 1, 2, 1), ('A', 2, 2, 1), ('A', 3, 2, 1), ('A', 4, 2, 1), ('A', 5, 2, 1),
('B', 1, 2, 1), ('B', 2, 2, 1), ('B', 3, 2, 1), ('B', 4, 2, 1), ('B', 5, 2, 1),
('C', 1, 2, 1), ('C', 2, 2, 1), ('C', 3, 2, 1), ('C', 4, 2, 1), ('C', 5, 2, 1),
('D', 1, 2, 1), ('D', 2, 2, 1), ('D', 3, 2, 1), ('D', 4, 2, 1), ('D', 5, 2, 1),
('E', 1, 2, 1), ('E', 2, 2, 1), ('E', 3, 2, 1), ('E', 4, 2, 1), ('E', 5, 2, 1),
('F', 1, 2, 1), ('F', 2, 2, 1), ('F', 3, 2, 1), ('F', 4, 2, 1), ('F', 5, 2, 1);

-- Places Premium (id_type_place = 2) - Using rangees G-J (20 places)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('G', 1, 2, 2), ('G', 2, 2, 2), ('G', 3, 2, 2), ('G', 4, 2, 2), ('G', 5, 2, 2),
('H', 1, 2, 2), ('H', 2, 2, 2), ('H', 3, 2, 2), ('H', 4, 2, 2), ('H', 5, 2, 2),
('I', 1, 2, 2), ('I', 2, 2, 2), ('I', 3, 2, 2), ('I', 4, 2, 2), ('I', 5, 2, 2),
('J', 1, 2, 2), ('J', 2, 2, 2), ('J', 3, 2, 2), ('J', 4, 2, 2), ('J', 5, 2, 2);

-- Places PMR (id_type_place = 3) - Using rangee K to avoid all conflicts
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('K', 1, 2, 3), ('K', 2, 2, 3);

-- SALLE C : 50 Standard + 35 Premium + 2 PMR = 87 places
-- Revenu max = (50 × 20000) + (35 × 50000) + (2 × 20000) = 1000000 + 1750000 + 40000 = 2790000 Ar

-- Places Standard (id_type_place = 1)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('A', 1, 3, 1), ('A', 2, 3, 1), ('A', 3, 3, 1), ('A', 4, 3, 1), ('A', 5, 3, 1),
('B', 1, 3, 1), ('B', 2, 3, 1), ('B', 3, 3, 1), ('B', 4, 3, 1), ('B', 5, 3, 1),
('C', 1, 3, 1), ('C', 2, 3, 1), ('C', 3, 3, 1), ('C', 4, 3, 1), ('C', 5, 3, 1),
('D', 1, 3, 1), ('D', 2, 3, 1), ('D', 3, 3, 1), ('D', 4, 3, 1), ('D', 5, 3, 1),
('E', 1, 3, 1), ('E', 2, 3, 1), ('E', 3, 3, 1), ('E', 4, 3, 1), ('E', 5, 3, 1),
('F', 1, 3, 1), ('F', 2, 3, 1), ('F', 3, 3, 1), ('F', 4, 3, 1), ('F', 5, 3, 1),
('G', 1, 3, 1), ('G', 2, 3, 1), ('G', 3, 3, 1), ('G', 4, 3, 1), ('G', 5, 3, 1),
('H', 1, 3, 1), ('H', 2, 3, 1), ('H', 3, 3, 1), ('H', 4, 3, 1), ('H', 5, 3, 1),
('I', 1, 3, 1), ('I', 2, 3, 1), ('I', 3, 3, 1), ('I', 4, 3, 1), ('I', 5, 3, 1),
('J', 1, 3, 1), ('J', 2, 3, 1), ('J', 3, 3, 1);

-- Places Premium (id_type_place = 2) - Using rangees K-Q to avoid conflicts with Standard
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('K', 1, 3, 2), ('K', 2, 3, 2), ('K', 3, 3, 2), ('K', 4, 3, 2), ('K', 5, 3, 2),
('L', 1, 3, 2), ('L', 2, 3, 2), ('L', 3, 3, 2), ('L', 4, 3, 2), ('L', 5, 3, 2),
('M', 1, 3, 2), ('M', 2, 3, 2), ('M', 3, 3, 2), ('M', 4, 3, 2), ('M', 5, 3, 2),
('N', 1, 3, 2), ('N', 2, 3, 2), ('N', 3, 3, 2), ('N', 4, 3, 2), ('N', 5, 3, 2),
('O', 1, 3, 2), ('O', 2, 3, 2), ('O', 3, 3, 2), ('O', 4, 3, 2), ('O', 5, 3, 2),
('P', 1, 3, 2), ('P', 2, 3, 2), ('P', 3, 3, 2), ('P', 4, 3, 2), ('P', 5, 3, 2),
('Q', 1, 3, 2), ('Q', 2, 3, 2), ('Q', 3, 3, 2), ('Q', 4, 3, 2), ('Q', 5, 3, 2);

-- Places PMR (id_type_place = 3) - Using rangee R to avoid all conflicts
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('R', 1, 3, 3), ('R', 2, 3, 3);

-- SALLE E : 50 Standard + 35 Premium + 2 PMR = 87 places
-- Revenu max = (50 × 20000) + (35 × 50000) + (2 × 20000) = 1000000 + 1750000 + 40000 = 2790000 Ar

-- Places Standard (id_type_place = 1)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('A', 1, 5, 1), ('A', 2, 5, 1), ('A', 3, 5, 1), ('A', 4, 5, 1), ('A', 5, 5, 1),
('B', 1, 5, 1), ('B', 2, 5, 1), ('B', 3, 5, 1), ('B', 4, 5, 1), ('B', 5, 5, 1),
('C', 1, 5, 1), ('C', 2, 5, 1), ('C', 3, 5, 1), ('C', 4, 5, 1), ('C', 5, 5, 1),
('D', 1, 5, 1), ('D', 2, 5, 1), ('D', 3, 5, 1), ('D', 4, 5, 1), ('D', 5, 5, 1),
('E', 1, 5, 1), ('E', 2, 5, 1), ('E', 3, 5, 1), ('E', 4, 5, 1), ('E', 5, 5, 1),
('F', 1, 5, 1), ('F', 2, 5, 1), ('F', 3, 5, 1), ('F', 4, 5, 1), ('F', 5, 5, 1),
('G', 1, 5, 1), ('G', 2, 5, 1), ('G', 3, 5, 1), ('G', 4, 5, 1), ('G', 5, 5, 1),
('H', 1, 5, 1), ('H', 2, 5, 1), ('H', 3, 5, 1), ('H', 4, 5, 1), ('H', 5, 5, 1),
('I', 1, 5, 1), ('I', 2, 5, 1), ('I', 3, 5, 1), ('I', 4, 5, 1), ('I', 5, 5, 1),
('J', 1, 5, 1), ('J', 2, 5, 1);

-- Places Premium (id_type_place = 2) - Using rangees K-Q to avoid conflicts with Standard
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('K', 1, 5, 2), ('K', 2, 5, 2), ('K', 3, 5, 2), ('K', 4, 5, 2), ('K', 5, 5, 2),
('L', 1, 5, 2), ('L', 2, 5, 2), ('L', 3, 5, 2), ('L', 4, 5, 2), ('L', 5, 5, 2),
('M', 1, 5, 2), ('M', 2, 5, 2), ('M', 3, 5, 2), ('M', 4, 5, 2), ('M', 5, 5, 2),
('N', 1, 5, 2), ('N', 2, 5, 2), ('N', 3, 5, 2), ('N', 4, 5, 2), ('N', 5, 5, 2),
('O', 1, 5, 2), ('O', 2, 5, 2), ('O', 3, 5, 2), ('O', 4, 5, 2), ('O', 5, 5, 2),
('P', 1, 5, 2), ('P', 2, 5, 2), ('P', 3, 5, 2), ('P', 4, 5, 2), ('P', 5, 5, 2),
('Q', 1, 5, 2), ('Q', 2, 5, 2), ('Q', 3, 5, 2), ('Q', 4, 5, 2), ('Q', 5, 5, 2);

-- Places PMR (id_type_place = 3) - Using rangee R to avoid all conflicts
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('R', 1, 5, 3), ('R', 2, 5, 3);

-- Seances
INSERT INTO seance (id_film, id_salle, date_seance, heure_debut, prix, statut) VALUES
(6, 1, '2026-01-10', '10:00', 9000, TRUE),
(6, 2, '2026-01-10', '14:00', 9000, TRUE),
(6, 3, '2026-01-10', '19:00', 9500, TRUE),
(1, 1, CURRENT_DATE + 1, '18:00', 8000, TRUE),
(2, 2, CURRENT_DATE + 1, '20:30', 10000, TRUE),
(3, 3, CURRENT_DATE + 2, '16:00', 7000, TRUE),
(5, 5, CURRENT_DATE + 3, '21:00', 12000, TRUE),
(6, 1, '2026-01-11', '10:00', 9000, TRUE),
(6, 2, '2026-01-11', '15:30', 9000, TRUE);

-- Billet d'exemple (adulte avec place standard)
INSERT INTO billet (date_achat, id_client, id_seance, id_place, id_statut_billet, id_type_billet, prix)
VALUES (CURRENT_TIMESTAMP, 1, (SELECT id_seance FROM seance ORDER BY id_seance LIMIT 1), 
        (SELECT id_place FROM place WHERE id_salle = 1 AND id_type_place = 1 LIMIT 1), 1, 1, 20000);

-- Billet d'exemple (enfant avec place standard - réduction appliquée)
INSERT INTO billet (date_achat, id_client, id_seance, id_place, id_statut_billet, id_type_billet, prix)
VALUES (CURRENT_TIMESTAMP, 1, (SELECT id_seance FROM seance ORDER BY id_seance LIMIT 1), 
        (SELECT id_place FROM place WHERE id_salle = 1 AND id_type_place = 1 OFFSET 1 LIMIT 1), 1, 2, 15000);

-- =====================================
-- 5. AFFICHAGE DES RÉSUMÉS
-- =====================================

SELECT '===== RÉSUMÉ DES SALLES =====' as info;
SELECT 
    s.nom_salle,
    s.capacite,
    COUNT(p.id_place) as places_configurees,
    SUM(tp.prix) as revenu_max
FROM salle s
LEFT JOIN place p ON s.id_salle = p.id_salle
LEFT JOIN type_place tp ON p.id_type_place = tp.id_type_place
GROUP BY s.id_salle, s.nom_salle, s.capacite
ORDER BY s.id_salle;

SELECT '===== DÉTAIL DES TYPES DE PLACE =====' as info;
SELECT * FROM type_place ORDER BY id_type_place;

SELECT '===== DÉTAIL DES CLIENTS =====' as info;
SELECT nom, prenom, email FROM client ORDER BY id_client;

-- =====================================
-- 6. TYPES DE BILLETS (ADULTE ET ENFANT)
-- =====================================
SELECT '===== TYPES DE BILLETS =====' as info;
SELECT * FROM type_billet ORDER BY id_type_billet;

-- =====================================
-- 7. RÉSUMÉ DES BILLETS AVEC TARIFICATION
-- =====================================
SELECT '===== BILLETS AVEC TARIFICATION =====' as info;
SELECT 
    b.id_billet,
    c.nom || ' ' || c.prenom as client,
    f.titre as film,
    s.nom_salle as salle,
    p.rangee || p.numero as place,
    tp.libelle as type_place,
    tb.libelle as type_billet,
    CASE 
        WHEN tb.isEnfant = TRUE AND tp.libelle = 'Standard' THEN 'Réduction enfant (15 000Ar)'
        WHEN tb.isEnfant = FALSE THEN 'Tarif adulte'
        ELSE 'Pas de réduction'
    END as tarification,
    b.prix as prix_applique
FROM billet b
JOIN client c ON b.id_client = c.id_client
JOIN seance se ON b.id_seance = se.id_seance
JOIN film f ON se.id_film = f.id_film
JOIN salle s ON se.id_salle = s.id_salle
JOIN place p ON b.id_place = p.id_place
JOIN type_place tp ON p.id_type_place = tp.id_type_place
LEFT JOIN type_billet tb ON b.id_type_billet = tb.id_type_billet
ORDER BY b.id_billet;


-- SALLE D : 30 Standard + 20 Premium + 2 PMR = 52 places
-- Revenu max = (30 × 20000) + (20 × 50000) + (2 × 20000) = 1640000 Ar
-- Places Standard (id_type_place = 1)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('A', 1, 4, 1), ('A', 2, 4, 1), ('A', 3, 4, 1), ('A', 4, 4, 1), ('A', 5, 4, 1),
('B', 1, 4, 1), ('B', 2, 4, 1), ('B', 3, 4, 1), ('B', 4, 4, 1), ('B', 5, 4, 1),
('C', 1, 4, 1), ('C', 2, 4, 1), ('C', 3, 4, 1), ('C', 4, 4, 1), ('C', 5, 4, 1),
('D', 1, 4, 1), ('D', 2, 4, 1), ('D', 3, 4, 1), ('D', 4, 4, 1), ('D', 5, 4, 1),
('E', 1, 4, 1), ('E', 2, 4, 1), ('E', 3, 4, 1), ('E', 4, 4, 1), ('E', 5, 4, 1),
('F', 1, 4, 1), ('F', 2, 4, 1), ('F', 3, 4, 1), ('F', 4, 4, 1), ('F', 5, 4, 1);

-- Places Premium
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('G', 1, 4, 2), ('G', 2, 4, 2), ('G', 3, 4, 2), ('G', 4, 4, 2), ('G', 5, 4, 2),
('H', 1, 4, 2), ('H', 2, 4, 2), ('H', 3, 4, 2), ('H', 4, 4, 2), ('H', 5, 4, 2),
('I', 1, 4, 2), ('I', 2, 4, 2), ('I', 3, 4, 2), ('I', 4, 4, 2), ('I', 5, 4, 2),
('J', 1, 4, 2), ('J', 2, 4, 2), ('J', 3, 4, 2), ('J', 4, 4, 2), ('J', 5, 4, 2);

-- Places PMR
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('K', 1, 4, 3), ('K', 2, 4, 3);

-- Ajouter les 2 places Standard manquantes pour Salle C (rangee J)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('J', 4, 3, 1), ('J', 5, 3, 1);

-- Ajouter les 3 places Standard manquantes pour Salle E (rangee J)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('J', 3, 5, 1), ('J', 4, 5, 1), ('J', 5, 5, 1);


UPDATE type_place 
SET libelle = 'VIP', prix = 180000 
WHERE id_type_place = 3;

UPDATE type_place SET libelle = 'Premium', prix = 140000 
WHERE id_type_place = 2;

UPDATE type_place SET libelle = 'Standard', prix = 80000 
WHERE id_type_place = 1;

-- Mettre à jour les éventuelles valeurs NULL (au cas où)
-- UPDATE type_billet SET isEnfant = FALSE WHERE isEnfant IS NULL;

-- -- Ajouter la contrainte NOT NULL
-- ALTER TABLE type_billet 
-- ALTER COLUMN isEnfant SET NOT NULL,
-- ALTER COLUMN isEnfant SET DEFAULT FALSE;


-- =====================================
-- 5. REQUÊTES DE RAPPORT PAIEMENT SOCIETE
-- =====================================

-- REQUÊTE 1: Historique complet des paiements par société
SELECT 
    pd.nom AS societe,
    ps.date_paiement,
    ps.montant,
    ps.description,
    COUNT(ds.id) OVER (PARTITION BY ps.id_prop_diffusion) AS nombre_diffusions,
    SUM(ds.prix) OVER (PARTITION BY ps.id_prop_diffusion) AS total_diffusions
FROM paiement_societe ps
JOIN prop_diffusion pd ON ps.id_prop_diffusion = pd.id
LEFT JOIN diffusion_seance ds ON ps.id_prop_diffusion = ds.id_prop_diffusion
ORDER BY pd.nom, ps.date_paiement DESC;

-- REQUÊTE 2: Récapitulatif paiements et solde par société (VANIALA SPÉCIFIQUEMENT)
SELECT 
    pd.nom AS societe,
    COALESCE(SUM(ds.prix), 0) AS total_diffusions_ar,
    COALESCE(SUM(ps.montant), 0) AS total_paye_ar,
    COALESCE(SUM(ds.prix), 0) - COALESCE(SUM(ps.montant), 0) AS reste_a_payer_ar,
    ROUND((COALESCE(SUM(ps.montant), 0) / NULLIF(SUM(ds.prix), 0)) * 100, 2) AS pourcentage_paye
FROM prop_diffusion pd
LEFT JOIN diffusion_seance ds ON pd.id = ds.id_prop_diffusion
LEFT JOIN paiement_societe ps ON pd.id = ps.id_prop_diffusion
WHERE pd.nom = 'Vaniala'
GROUP BY pd.nom;

-- REQUÊTE 3: Détail complet Vaniala - Historique avec calcul du solde
SELECT 
    ps.id_paiement,
    pd.nom AS societe,
    ps.date_paiement,
    ps.montant AS montant_paye,
    ps.description,
    (SELECT COUNT(id) FROM diffusion_seance WHERE id_prop_diffusion = pd.id) AS nb_diffusions,
    (SELECT SUM(prix) FROM diffusion_seance WHERE id_prop_diffusion = pd.id) AS total_diffusions,
    (SELECT SUM(montant) FROM paiement_societe WHERE id_prop_diffusion = pd.id) AS cumul_paiements,
    (SELECT SUM(prix) FROM diffusion_seance WHERE id_prop_diffusion = pd.id) - 
    (SELECT SUM(montant) FROM paiement_societe WHERE id_prop_diffusion = pd.id) AS reste_a_payer
FROM paiement_societe ps
JOIN prop_diffusion pd ON ps.id_prop_diffusion = pd.id
WHERE pd.nom = 'Vaniala'
ORDER BY ps.date_paiement DESC;

-- REQUÊTE 4: Liste des paiements enregistrés (SIMPLE - pour affichage)
SELECT 
    paiement_societe.id_paiement,
    prop_diffusion.nom AS societe,
    paiement_societe.montant,
    paiement_societe.date_paiement,
    paiement_societe.description
FROM paiement_societe
JOIN prop_diffusion ON paiement_societe.id_prop_diffusion = prop_diffusion.id
ORDER BY paiement_societe.date_paiement DESC;