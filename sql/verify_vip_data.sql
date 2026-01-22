-- =====================================
-- VÉRIFICATION ET INSERTION DES PLACES VIP
-- =====================================

-- 1️⃣ VÉRIFIER LES SALLES
SELECT id_salle, nom_salle, capacite FROM salle;

-- 2️⃣ VÉRIFIER LES TYPES DE PLACES
SELECT * FROM type_place ORDER BY id_type_place;

-- 3️⃣ VÉRIFIER LES PLACES EXISTANTES PAR SALLE
SELECT 
    s.id_salle,
    s.nom_salle,
    COUNT(p.id_place) as nombre_places,
    STRING_AGG(DISTINCT tp.libelle, ', ') as types_places
FROM salle s
LEFT JOIN place p ON s.id_salle = p.id_salle
LEFT JOIN type_place tp ON p.id_type_place = tp.id_type_place
GROUP BY s.id_salle, s.nom_salle
ORDER BY s.id_salle;

-- 4️⃣ VÉRIFIER LES PLACES PAR TYPE POUR CHAQUE SALLE
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

-- 5️⃣ COMPTER TOTAL DE PLACES PAR SALLE
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

-- 6️⃣ OBTENIR L'ID DE VIP
SELECT id_type_place FROM type_place WHERE libelle = 'VIP';
