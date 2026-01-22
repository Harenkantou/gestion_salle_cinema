-- Test data pour l'application Cinema
-- Ajoute types de place, genres, salles, films, places, seances, clients et un billet d'exemple

-- Types de place avec prix (en Ariary)
INSERT INTO type_place (libelle, prix) VALUES
('Standard', 20000),
('Premium', 50000),
('PMR', 20000);

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

-- Places (Type 1=Standard, 2=Premium, 3=PMR)
-- Salle A : 40 Standard + 40 Premium = 80 places (revenu max: 800000 + 2000000 = 2800000 Ar)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('A', 1, 1, 1), ('A', 2, 1, 1), ('A', 3, 1, 1), ('A', 4, 1, 1), ('A', 5, 1, 1),
('B', 1, 1, 1), ('B', 2, 1, 1), ('B', 3, 1, 1), ('B', 4, 1, 1), ('B', 5, 1, 1),
('C', 1, 1, 1), ('C', 2, 1, 1), ('C', 3, 1, 1), ('C', 4, 1, 1), ('C', 5, 1, 1),
('D', 1, 1, 1), ('D', 2, 1, 1), ('D', 3, 1, 1), ('D', 4, 1, 1), ('D', 5, 1, 1),
('E', 1, 1, 1), ('E', 2, 1, 1), ('E', 3, 1, 1), ('E', 4, 1, 1), ('E', 5, 1, 1),
('F', 1, 1, 1), ('F', 2, 1, 1), ('F', 3, 1, 1), ('F', 4, 1, 1), ('F', 5, 1, 1),
('G', 1, 1, 1), ('G', 2, 1, 1), ('G', 3, 1, 1), ('G', 4, 1, 1), ('G', 5, 1, 1),
('H', 1, 1, 1), ('H', 2, 1, 1), ('H', 3, 1, 1), ('H', 4, 1, 1), ('H', 5, 1, 1),
('A', 1, 1, 2), ('A', 2, 1, 2), ('A', 3, 1, 2), ('A', 4, 1, 2), ('A', 5, 1, 2),
('B', 1, 1, 2), ('B', 2, 1, 2), ('B', 3, 1, 2), ('B', 4, 1, 2), ('B', 5, 1, 2),
('C', 1, 1, 2), ('C', 2, 1, 2), ('C', 3, 1, 2), ('C', 4, 1, 2), ('C', 5, 1, 2),
('D', 1, 1, 2), ('D', 2, 1, 2), ('D', 3, 1, 2), ('D', 4, 1, 2), ('D', 5, 1, 2),
('E', 1, 1, 2), ('E', 2, 1, 2), ('E', 3, 1, 2), ('E', 4, 1, 2), ('E', 5, 1, 2),
('F', 1, 1, 2), ('F', 2, 1, 2), ('F', 3, 1, 2), ('F', 4, 1, 2), ('F', 5, 1, 2),
('G', 1, 1, 2), ('G', 2, 1, 2), ('G', 3, 1, 2), ('G', 4, 1, 2), ('G', 5, 1, 2),
('H', 1, 1, 2), ('H', 2, 1, 2), ('H', 3, 1, 2), ('H', 4, 1, 2), ('H', 5, 1, 2),
-- Salle B : 30 Standard + 20 Premium + 2 PMR = 52 places (revenu max: 600000 + 1000000 + 40000 = 1640000 Ar)
('A', 1, 2, 1), ('A', 2, 2, 1), ('A', 3, 2, 1), ('A', 4, 2, 1), ('A', 5, 2, 1),
('B', 1, 2, 1), ('B', 2, 2, 1), ('B', 3, 2, 1), ('B', 4, 2, 1), ('B', 5, 2, 1),
('C', 1, 2, 1), ('C', 2, 2, 1), ('C', 3, 2, 1), ('C', 4, 2, 1), ('C', 5, 2, 1),
('D', 1, 2, 1), ('D', 2, 2, 1), ('D', 3, 2, 1), ('D', 4, 2, 1), ('D', 5, 2, 1),
('E', 1, 2, 1), ('E', 2, 2, 1), ('E', 3, 2, 1), ('E', 4, 2, 1), ('E', 5, 2, 1),
('F', 1, 2, 1), ('F', 2, 2, 1), ('F', 3, 2, 1), ('F', 4, 2, 1), ('F', 5, 2, 1),
('A', 1, 2, 2), ('A', 2, 2, 2), ('A', 3, 2, 2), ('A', 4, 2, 2), ('A', 5, 2, 2),
('B', 1, 2, 2), ('B', 2, 2, 2), ('B', 3, 2, 2), ('B', 4, 2, 2), ('B', 5, 2, 2),
('C', 1, 2, 2), ('C', 2, 2, 2), ('C', 3, 2, 2), ('C', 4, 2, 2),
('A', 1, 2, 3), ('A', 2, 2, 3),
-- Salle C : 50 Standard + 35 Premium + 2 PMR = 87 places (revenu max: 1000000 + 1750000 + 40000 = 2790000 Ar)
('A', 1, 3, 1), ('A', 2, 3, 1), ('A', 3, 3, 1), ('A', 4, 3, 1), ('A', 5, 3, 1),
('B', 1, 3, 1), ('B', 2, 3, 1), ('B', 3, 3, 1), ('B', 4, 3, 1), ('B', 5, 3, 1),
('C', 1, 3, 1), ('C', 2, 3, 1), ('C', 3, 3, 1), ('C', 4, 3, 1), ('C', 5, 3, 1),
('D', 1, 3, 1), ('D', 2, 3, 1), ('D', 3, 3, 1), ('D', 4, 3, 1), ('D', 5, 3, 1),
('E', 1, 3, 1), ('E', 2, 3, 1), ('E', 3, 3, 1), ('E', 4, 3, 1), ('E', 5, 3, 1),
('F', 1, 3, 1), ('F', 2, 3, 1), ('F', 3, 3, 1), ('F', 4, 3, 1), ('F', 5, 3, 1),
('G', 1, 3, 1), ('G', 2, 3, 1), ('G', 3, 3, 1), ('G', 4, 3, 1), ('G', 5, 3, 1),
('H', 1, 3, 1), ('H', 2, 3, 1), ('H', 3, 3, 1), ('H', 4, 3, 1), ('H', 5, 3, 1),
('I', 1, 3, 1), ('I', 2, 3, 1), ('I', 3, 3, 1), ('I', 4, 3, 1), ('I', 5, 3, 1),
('J', 1, 3, 1), ('J', 2, 3, 1),
('A', 1, 3, 2), ('A', 2, 3, 2), ('A', 3, 3, 2), ('A', 4, 3, 2), ('A', 5, 3, 2),
('B', 1, 3, 2), ('B', 2, 3, 2), ('B', 3, 3, 2), ('B', 4, 3, 2), ('B', 5, 3, 2),
('C', 1, 3, 2), ('C', 2, 3, 2), ('C', 3, 3, 2), ('C', 4, 3, 2), ('C', 5, 3, 2),
('D', 1, 3, 2), ('D', 2, 3, 2), ('D', 3, 3, 2), ('D', 4, 3, 2), ('D', 5, 3, 2),
('E', 1, 3, 2), ('E', 2, 3, 2), ('E', 3, 3, 2), ('E', 4, 3, 2), ('E', 5, 3, 2),
('F', 1, 3, 2), ('F', 2, 3, 2), ('F', 3, 3, 2), ('F', 4, 3, 2), ('F', 5, 3, 2),
('G', 1, 3, 2), ('G', 2, 3, 2), ('G', 3, 3, 2), ('G', 4, 3, 2), ('G', 5, 3, 2),
('A', 1, 3, 3), ('A', 2, 3, 3);

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

-- Billet d'exemple
INSERT INTO billet (date_achat, id_client, id_seance, id_place, id_statut_billet, prix)
VALUES (CURRENT_TIMESTAMP, 1, (SELECT id_seance FROM seance ORDER BY id_seance LIMIT 1), (SELECT id_place FROM place ORDER BY id_place LIMIT 1), 1, 8000);
