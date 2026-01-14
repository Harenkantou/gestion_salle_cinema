-- ----------------------------
-- TABLE : SALLE
-- ----------------------------
CREATE TABLE salle (
    id_salle   SERIAL PRIMARY KEY,
    nom_salle  VARCHAR(50) NOT NULL,
    capacite   INTEGER NOT NULL,
    statut     BOOLEAN DEFAULT TRUE,  -- TRUE = dispo, FALSE = indisponible
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- TABLE : FILM
-- ----------------------------
-- ----------------------------
-- TABLE : GENRE
-- ----------------------------
CREATE TABLE genre (
    id_genre SERIAL PRIMARY KEY,
    nom_genre VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- ----------------------------
-- TABLE : FILM
-- ----------------------------
CREATE TABLE film (
    id_film        SERIAL PRIMARY KEY,
    titre          VARCHAR(150) NOT NULL,
    description_film TEXT,
    duree_minutes  INTEGER NOT NULL,
    id_genre       INTEGER REFERENCES genre(id_genre), -- lien vers genre
    date_sortie    DATE,
    image          VARCHAR(255), -- chemin ou URL de l'affiche
    statut         VARCHAR(20) DEFAULT 'ACTIF' CHECK (statut IN ('ACTIF','INACTIF')),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- TABLE : SEANCE
-- ----------------------------
CREATE TABLE seance (
    id_seance   SERIAL PRIMARY KEY,
    id_film     INTEGER NOT NULL REFERENCES film(id_film),
    id_salle    INTEGER NOT NULL REFERENCES salle(id_salle),
    date_seance DATE NOT NULL,
    heure_debut TIME NOT NULL,
    prix        NUMERIC(8,2) NOT NULL,
    statut      BOOLEAN DEFAULT TRUE,  -- TRUE = programmé, FALSE = annulé
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Optionnel : éviter deux séances en même temps dans une salle
    UNIQUE (id_salle, date_seance, heure_debut)
);


CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    motdepasse VARCHAR(100),
    telephone VARCHAR(20)
);

-- ----------------------------
-- TABLE : TYPE_PLACE
-- (ajoutée pour satisfaire les contraintes de `place`)
-- ----------------------------
CREATE TABLE type_place (
    id_type_place SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

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

    CREATE TABLE billet (
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

