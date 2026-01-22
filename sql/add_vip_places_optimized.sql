-- =====================================
-- INSERTION DES PLACES VIP POUR TOUTES LES SALLES
-- =====================================
-- Stratégie: Ajouter des places VIP de manière équilibrée dans chaque salle
-- Les places VIP seront dans le rang V avec numérotation séquentielle

-- Récupérer l'ID du type VIP (devrait être 3)
-- SELECT id_type_place FROM type_place WHERE libelle = 'VIP'; -- id_type_place = 3

-- =====================================
-- SALLE A (100 places: 20 restantes)
-- Ajouter 10 places VIP (V1 à V10)
-- =====================================
INSERT INTO place (id_salle, rangee, numero, id_type_place) VALUES
(1, 'V', 1, 3),
(1, 'V', 2, 3),
(1, 'V', 3, 3),
(1, 'V', 4, 3),
(1, 'V', 5, 3),
(1, 'V', 6, 3),
(1, 'V', 7, 3),
(1, 'V', 8, 3),
(1, 'V', 9, 3),
(1, 'V', 10, 3);

-- =====================================
-- SALLE B (80 places: 28 restantes, déjà 2 VIP)
-- Ajouter 10 places VIP supplémentaires (V3 à V12)
-- =====================================
INSERT INTO place (id_salle, rangee, numero, id_type_place) VALUES
(2, 'V', 3, 3),
(2, 'V', 4, 3),
(2, 'V', 5, 3),
(2, 'V', 6, 3),
(2, 'V', 7, 3),
(2, 'V', 8, 3),
(2, 'V', 9, 3),
(2, 'V', 10, 3),
(2, 'V', 11, 3),
(2, 'V', 12, 3);

-- =====================================
-- SALLE C (120 places: 33 restantes, déjà 2 VIP)
-- Ajouter 13 places VIP supplémentaires (V3 à V15)
-- =====================================
INSERT INTO place (id_salle, rangee, numero, id_type_place) VALUES
(3, 'V', 3, 3),
(3, 'V', 4, 3),
(3, 'V', 5, 3),
(3, 'V', 6, 3),
(3, 'V', 7, 3),
(3, 'V', 8, 3),
(3, 'V', 9, 3),
(3, 'V', 10, 3),
(3, 'V', 11, 3),
(3, 'V', 12, 3),
(3, 'V', 13, 3),
(3, 'V', 14, 3),
(3, 'V', 15, 3);

-- =====================================
-- SALLE D (60 places: 8 restantes, déjà 2 VIP)
-- Ajouter 4 places VIP supplémentaires (V3 à V6)
-- =====================================
INSERT INTO place (id_salle, rangee, numero, id_type_place) VALUES
(4, 'V', 3, 3),
(4, 'V', 4, 3),
(4, 'V', 5, 3),
(4, 'V', 6, 3);

-- =====================================
-- SALLE E (150 places: 63 restantes, déjà 2 VIP)
-- Ajouter 20 places VIP supplémentaires (V3 à V22)
-- =====================================
INSERT INTO place (id_salle, rangee, numero, id_type_place) VALUES
(5, 'V', 3, 3),
(5, 'V', 4, 3),
(5, 'V', 5, 3),
(5, 'V', 6, 3),
(5, 'V', 7, 3),
(5, 'V', 8, 3),
(5, 'V', 9, 3),
(5, 'V', 10, 3),
(5, 'V', 11, 3),
(5, 'V', 12, 3),
(5, 'V', 13, 3),
(5, 'V', 14, 3),
(5, 'V', 15, 3),
(5, 'V', 16, 3),
(5, 'V', 17, 3),
(5, 'V', 18, 3),
(5, 'V', 19, 3),
(5, 'V', 20, 3),
(5, 'V', 21, 3),
(5, 'V', 22, 3);

-- =====================================
-- VÉRIFICATION APRÈS INSERTION
-- =====================================
-- Vérifier le total des places par salle après insertion
SELECT 
    s.id_salle,
    s.nom_salle,
    s.capacite,
    COUNT(p.id_place) as places_actuelles,
    (s.capacite - COUNT(p.id_place)) as places_restantes
FROM salle s
LEFT JOIN place p ON s.id_salle = p.id_salle
GROUP BY s.id_salle, s.nom_salle, s.capacite
ORDER BY s.id_salle;

-- Vérifier la distribution par type après insertion
SELECT 
    s.id_salle,
    s.nom_salle,
    tp.libelle as type_place,
    COUNT(p.id_place) as nombre
FROM salle s
LEFT JOIN place p ON s.id_salle = p.id_salle
LEFT JOIN type_place tp ON p.id_type_place = tp.id_type_place
GROUP BY s.id_salle, s.nom_salle, tp.libelle
ORDER BY s.id_salle, tp.libelle;
