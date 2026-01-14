-- Test data pour l'application Cinema
-- Ajoute types de place, genres, salles, films, places, seances, clients et un billet d'exemple

-- Types de place
INSERT INTO type_place (libelle) VALUES
('Standard'),
('VIP'),
('PMR');

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
('Interstellar', 'Des explorateurs voyagent à travers un trou de ver pour sauver l''humanite.', 169, 4, '2014-11-07', 'interstellar.jpg', 'ACTIF');

-- Clients
INSERT INTO client (nom, prenom, email, motdepasse, telephone) VALUES
('Dupont', 'Jean', 'jean.dupont@example.com', 'mdp123', '0612345678'),
('Martin', 'Claire', 'claire.martin@example.com', 'password456', '0623456789'),
('Nguyen', 'Paul', 'paul.nguyen@example.com', 'azerty789', '0634567890');

-- Places (avec id_type_place = 1 Standard)
INSERT INTO place (rangee, numero, id_salle, id_type_place) VALUES
('A', 1, 1, 1),
('A', 2, 1, 1),
('A', 3, 1, 1),
('B', 1, 2, 1),
('B', 2, 2, 1),
('C', 1, 3, 1),
('C', 2, 3, 1),
('D', 1, 5, 1),
('D', 2, 5, 1);

-- Seances
INSERT INTO seance (id_film, id_salle, date_seance, heure_debut, prix, statut) VALUES
(1, 1, CURRENT_DATE + 1, '18:00', 8000, TRUE),
(2, 2, CURRENT_DATE + 1, '20:30', 10000, TRUE),
(3, 3, CURRENT_DATE + 2, '16:00', 7000, TRUE),
(5, 5, CURRENT_DATE + 3, '21:00', 12000, TRUE);

-- Billet d'exemple
INSERT INTO billet (date_achat, id_client, id_seance, id_place, id_statut_billet, prix)
VALUES (CURRENT_TIMESTAMP, 1, (SELECT id_seance FROM seance ORDER BY id_seance LIMIT 1), (SELECT id_place FROM place ORDER BY id_place LIMIT 1), 1, 8000);
