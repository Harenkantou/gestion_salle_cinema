INSERT INTO genre (nom_genre, description) VALUES
('Action', 'Films avec beaucoup d"action et de suspense'),
('Comédie', 'Films destines à faire rire'),
('Drame', 'Films serieux avec une forte charge emotionnelle'),
('Science-Fiction', 'Films bases sur la science ou le futur'),
('Horreur', 'Films destines à faire peur');


INSERT INTO film (titre, description_film, duree_minutes, id_genre, date_sortie, image)
VALUES
('Inception', 'Un voleur qui s"introduit dans les rêves pour voler des secrets.', 148, 4, '2010-07-16', 'images/inception.jpg'),
('Avengers: Endgame', 'Les super-héros se réunissent pour vaincre Thanos.', 181, 1, '2019-04-24', 'images/avengers_endgame.jpg'),
('La La Land', 'Une histoire d"amour entre une actrice et un musicien.', 128, 3, '2016-12-09', 'images/la_la_land.jpg'),
('Get Out', 'Un jeune homme découvre un terrible secret en visitant la famille de sa petite amie.', 104, 5, '2017-02-24', 'images/get_out.jpg'),
('Interstellar', 'Des explorateurs voyagent à travers un trou de ver pour sauver l"humanité.', 169, 4, '2014-11-07', 'images/interstellar.jpg'),
('The Hangover', 'Trois amis se réveillent après un enterrement de vie de garçon à Las Vegas sans se souvenir de la nuit précédente.', 100, 1, '2009-06-05', 'images/the_hangover.jpg'),
('Titanic', 'Une romance tragique se déroule à bord du célèbre paquebot.', 195, 3, '1997-12-19', 'images/titanic.jpg'),
('The Conjuring', 'Des enquêteurs paranormaux aident une famille terrorisée par une présence obscure.', 112, 5, '2013-07-19', 'images/the_conjuring.jpg'),
('Mad Max: Fury Road', 'Dans un futur post-apocalyptique, Max aide Furiosa à fuir un tyran.', 120, 1, '2015-05-15', 'images/mad_max_fury_road.jpg'),
('Guardians of the Galaxy', 'Un groupe de criminels se réunit pour sauver la galaxie.', 121, 1, '2014-08-01', 'images/guardians_of_the_galaxy.jpg');

INSERT INTO salle (nom_salle, capacite, statut) VALUES
('Salle A', 100, TRUE),
('Salle B', 80, TRUE),
('Salle C', 120, TRUE),
('Salle D', 60, FALSE),
('Salle E', 150, TRUE);

INSERT INTO client (nom, prenom, email, motdepasse, telephone) VALUES
('Dupont', 'Jean', 'jean.dupont@gmail.com', 'mdp123', '0612345678'),
('Martin', 'Claire', 'claire.martin@gmail.com', 'password456', '0623456789'),
('Nguyen', 'Paul', 'paul.nguyen@gmail.com', 'azerty789', '0634567890'),
('Diallo', 'Aminata', 'aminata.diallo@gmail.com', 'securepass', '0645678901'),
('Benali', 'Youssef', 'youssef.benali@gmail.com', 'motdepasse', '0656789012');


-- Salle A (id_salle = 1)
INSERT INTO place (numero, rangee, id_salle) VALUES
(4, 'B', 1),
(5, 'C', 1),
(6, 'C', 1),
(7, 'D', 1),
(8, 'D', 1);


-- Salle B (id_salle = 2)
INSERT INTO place (numero, rangee, id_salle) VALUES
(1, 'A', 2),
(2, 'B', 2);

-- Salle C (id_salle = 3)
INSERT INTO place (numero, rangee, id_salle) VALUES
(1, 'A', 3),
(2, 'A', 3),
(3, 'B', 3),
(4, 'B', 3);

-- Salle E (id_salle = 5)
INSERT INTO place (numero, rangee, id_salle) VALUES
(1, 'A', 5),
(2, 'B', 5),
(3, 'C', 5);

-- Billet
INSERT INTO billet (date_achat, id_client, id_seance, id_place, id_statut_billet, prix)
SELECT
    CURRENT_TIMESTAMP,
    c.id_client,
    s.id_seance,
    p.id_place,
    1,
    15000
FROM client c
CROSS JOIN (
    SELECT id_seance
    FROM seance
    WHERE statut = TRUE
    ORDER BY id_seance
    LIMIT 1
) s
JOIN LATERAL (
    SELECT id_place
    FROM place
    ORDER BY id_place
    LIMIT 5
    OFFSET (c.id_client - 1) * 5
) p ON true;

-- seance
INSERT INTO seance (id_film, id_salle, date_seance, heure_debut, prix, statut)
VALUES (1, 1, CURRENT_DATE, '18:00', 15000, TRUE);




INSERT INTO film (
    titre,
    description_film,
    duree_minutes,
    id_genre,
    date_sortie,
    image,
    statut
) VALUES (
    'Avatar',
    'Sur la planète Pandora, un ancien marine est envoyé pour infiltrer les Na’vi, mais se retrouve déchiré entre son devoir et son attachement à ce nouveau monde.',
    162,
    5,
    '2009-12-16',
    'avatar.jpg',
    'ACTIF'
);

INSERT INTO seance (
    date_seance,
    heure_debut,
    prix,
    statut,
    id_film,
    id_salle
) VALUES
('2026-01-22', '10:00:00', 10000, true, 22, 1), -- Salle A
('2026-01-22', '14:00:00', 12000, true, 22, 2), -- Salle B
('2026-01-22', '18:00:00', 15000, true, 22, 3), -- Salle C
('2026-01-22', '18:00:00', 15000, true, 22, 5); -- Salle E
('2026-01-10', '10:00:00', 15000, true, 22, 5); 


-- =========================
-- AJOUT DE PLACES
-- =========================

-- Salle A (id_salle = 1)
INSERT INTO place (numero, rangee, id_salle) VALUES
(4, 'B', 1),
(5, 'C', 1),
(6, 'C', 1),
(7, 'D', 1),
(8, 'D', 1);

-- Salle B (id_salle = 2)
INSERT INTO place (numero, rangee, id_salle) VALUES
(3, 'A', 2),
(4, 'B', 2),
(5, 'C', 2);

-- Salle C (id_salle = 3)
INSERT INTO place (numero, rangee, id_salle) VALUES
(5, 'C', 3),
(6, 'C', 3),
(7, 'D', 3),
(8, 'D', 3);

-- Salle E (id_salle = 5)
INSERT INTO place (numero, rangee, id_salle) VALUES
(4, 'C', 5),
(5, 'D', 5),
(6, 'D', 5),
(7, 'E', 5);





