-- =====================================
-- CORRIGER LA TABLE TYPE_BILLET
-- =====================================
-- Base de données: cinema_db

-- Supprimer la table si elle existe avec l'ancienne structure
DROP TABLE IF EXISTS type_billet CASCADE;

-- Recréer la table avec la bonne structure
CREATE TABLE type_billet (
    id_type_billet SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    is_enfant BOOLEAN DEFAULT FALSE
);

-- Insérer les données correctes
INSERT INTO type_billet (libelle, is_enfant) VALUES 
('Adulte', FALSE),
('Enfant', TRUE);

-- Vérifier
SELECT * FROM type_billet;
