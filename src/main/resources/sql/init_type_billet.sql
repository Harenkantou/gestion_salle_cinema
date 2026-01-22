-- =====================================
-- INSÉRER LES TYPES DE BILLETS
-- =====================================

-- Vérifier si la table type_billet existe, sinon la créer
CREATE TABLE IF NOT EXISTS type_billet (
    id_type_billet SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    is_enfant BOOLEAN DEFAULT FALSE
);

-- Insérer les types de billets s'ils n'existent pas
INSERT INTO type_billet (libelle, is_enfant) 
VALUES ('Adulte', FALSE)
ON CONFLICT (libelle) DO NOTHING;

INSERT INTO type_billet (libelle, is_enfant) 
VALUES ('Enfant', TRUE)
ON CONFLICT (libelle) DO NOTHING;

-- Vérifier que les données sont bien insérées
SELECT * FROM type_billet;
