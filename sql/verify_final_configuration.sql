-- =====================================
-- VÉRIFICATION FINALE DES PRIX ET PLACES VIP
-- =====================================

-- 1️⃣ VÉRIFIER LES PRIX DES TYPES DE PLACES
SELECT 
    id_type_place,
    libelle,
    prix
FROM type_place
ORDER BY id_type_place;

-- 2️⃣ VÉRIFIER LA DISTRIBUTION DES PLACES PAR TYPE ET SALLE
SELECT 
    s.id_salle,
    s.nom_salle,
    s.capacite,
    COUNT(CASE WHEN tp.libelle = 'Standard' THEN 1 END) as standard,
    COUNT(CASE WHEN tp.libelle = 'Premium' THEN 1 END) as premium,
    COUNT(CASE WHEN tp.libelle = 'VIP' THEN 1 END) as vip,
    COUNT(p.id_place) as total,
    (s.capacite - COUNT(p.id_place)) as disponibles
FROM salle s
LEFT JOIN place p ON s.id_salle = p.id_salle
LEFT JOIN type_place tp ON p.id_type_place = tp.id_type_place
GROUP BY s.id_salle, s.nom_salle, s.capacite
ORDER BY s.id_salle;

-- 3️⃣ VÉRIFIER LA RÉPARTITION DÉTAILLÉE
SELECT 
    s.id_salle,
    s.nom_salle,
    tp.libelle as type_place,
    COUNT(p.id_place) as nombre
FROM salle s
LEFT JOIN place p ON s.id_salle = p.id_salle
LEFT JOIN type_place tp ON p.id_type_place = tp.id_type_place
WHERE p.id_place IS NOT NULL
GROUP BY s.id_salle, s.nom_salle, tp.libelle
ORDER BY s.id_salle, tp.id_type_place;

-- 4️⃣ EXEMPLE DE CALCUL DE PRIX (pour tester les constants en Java)
-- Standard: 80k (adulte) / 40k (enfant - 50%)
-- Premium: 140k (adulte) / 70k (enfant - 50%)
-- VIP: 180k (adulte) / 90k (enfant - 50%)
SELECT 
    'Standard' as type_place,
    80000 as prix_adulte,
    40000 as prix_enfant,
    50.0 as reduction_percent
UNION ALL
SELECT 
    'Premium',
    140000,
    70000,
    50.0
UNION ALL
SELECT 
    'VIP',
    180000,
    90000,
    50.0;

-- 5️⃣ VÉRIFIER LES TYPES DE BILLETS
SELECT * FROM type_billet ORDER BY id_type_billet;
