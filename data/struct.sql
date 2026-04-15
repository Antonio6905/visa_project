-- ============================================
-- SCHEMA DE BASE DE DONNEES - GESTION DE CINEMA
-- Version avec statuts en ID et camelCase
-- ============================================


Genre:
    ID
    libelle

Categorie:
    ID
    libelle

Langage:
    ID
    libelle

Realisateur:
    ID
    nom

Acteur:
    ID
    nom

Film:
    ID
    titre
    DateSortie
    duree(minutes)

FilmGenre(Associative):
FilmCategorie(Associative):
FilmRealisateur(Associative):
FilmActeur(Associative):

Salle:
    Id
    nom
    capacite

Siege:
    ID
    libelle

SalleSiege:
    ID
    idSalle
    idSiege
    nombre

StatutSeance:
    id
    libelle

Seance:
    ID
    idFilm
    DateHeureDebut
    idSalle
    idLangage
    prixBase
    idStatutSeance

SeancePrix:
    ID
    idSeance
    idCategorie
    idSiege
    prix

Client:
    ID
    nom
    contact(nullable si divers)

Billet:
    ID
    idClient(possibilite achat sur place valeur:divers)
    idSeance
    dateHeure
    idSiege
    prix
    nombre

ModePaiement:
    Id
    libelle

Paiement:
    ID
    IdBillet
    montant
    date
    idModePaiement

-- ============================================
-- SCHEMA DE BASE DE DONNEES - GESTION DE CINEMA
-- Version avec statuts en ID et camelCase
-- ============================================

\c postgres;

DROP DATABASE cinema;

CREATE DATABASE cinema;

\c cinema;

-- Création des tables de base
CREATE TABLE Genre (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Categorie (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Langage (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Realisateur (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE Acteur (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE Film (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    dateSortie DATE,
    duree INTEGER CHECK (duree > 0) 
);

-- Tables associatives pour Film
CREATE TABLE FilmGenre (
    id SERIAL PRIMARY KEY,
    idFilm INTEGER NOT NULL,
    idGenre INTEGER NOT NULL,
    FOREIGN KEY (idFilm) REFERENCES Film(id) ON DELETE CASCADE,
    FOREIGN KEY (idGenre) REFERENCES Genre(id) ON DELETE CASCADE,
    UNIQUE (idFilm, idGenre)
);

CREATE TABLE FilmCategorie (
    id SERIAL PRIMARY KEY,
    idFilm INTEGER NOT NULL,
    idCategorie INTEGER NOT NULL,
    FOREIGN KEY (idFilm) REFERENCES Film(id) ON DELETE CASCADE,
    FOREIGN KEY (idCategorie) REFERENCES Categorie(id) ON DELETE CASCADE,
    UNIQUE (idFilm, idCategorie)
);

CREATE TABLE FilmRealisateur (
    id SERIAL PRIMARY KEY,
    idFilm INTEGER NOT NULL,
    idRealisateur INTEGER NOT NULL,
    FOREIGN KEY (idFilm) REFERENCES Film(id) ON DELETE CASCADE,
    FOREIGN KEY (idRealisateur) REFERENCES Realisateur(id) ON DELETE CASCADE,
    UNIQUE (idFilm, idRealisateur)
);

CREATE TABLE FilmActeur (
    id SERIAL PRIMARY KEY,
    idFilm INTEGER NOT NULL,
    idActeur INTEGER NOT NULL,
    FOREIGN KEY (idFilm) REFERENCES Film(id) ON DELETE CASCADE,
    FOREIGN KEY (idActeur) REFERENCES Acteur(id) ON DELETE CASCADE,
    UNIQUE (idFilm, idActeur)
);

-- Tables pour les salles et sièges
CREATE TABLE Salle (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    capacite INTEGER CHECK (capacite > 0)
);

CREATE TABLE Siege (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE SalleSiege (
    id SERIAL PRIMARY KEY,
    idSalle INTEGER NOT NULL,
    idSiege INTEGER NOT NULL,
    nombre INTEGER CHECK (nombre >= 0),
    FOREIGN KEY (idSalle) REFERENCES Salle(id) ON DELETE CASCADE,
    FOREIGN KEY (idSiege) REFERENCES Siege(id) ON DELETE CASCADE,
    UNIQUE (idSalle, idSiege)
);

-- Tables pour les séances
CREATE TABLE StatutSeance (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Seance (
    id SERIAL PRIMARY KEY,
    idFilm INTEGER NOT NULL,
    dateHeureDebut TIMESTAMP NOT NULL,
    idSalle INTEGER NOT NULL,
    idLangage INTEGER NOT NULL,
    prixBase DECIMAL(10, 2) CHECK (prixBase >= 0),
    idStatutSeance INTEGER NOT NULL,
    FOREIGN KEY (idFilm) REFERENCES Film(id),
    FOREIGN KEY (idSalle) REFERENCES Salle(id),
    FOREIGN KEY (idLangage) REFERENCES Langage(id),
    FOREIGN KEY (idStatutSeance) REFERENCES StatutSeance(id)
);

CREATE TABLE SeancePrix (
    id SERIAL PRIMARY KEY,
    idSeance INTEGER NOT NULL,
    idCategorie INTEGER NOT NULL,
    idSiege INTEGER NOT NULL,
    prix DECIMAL(10, 2) CHECK (prix >= 0),
    FOREIGN KEY (idSeance) REFERENCES Seance(id) ON DELETE CASCADE,
    FOREIGN KEY (idCategorie) REFERENCES Categorie(id),
    FOREIGN KEY (idSiege) REFERENCES Siege(id),
    UNIQUE (idSeance, idCategorie, idSiege)
);

-- Tables pour les clients et billets
CREATE TABLE Client (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    contact VARCHAR(100)
);

CREATE TABLE Billet (
    id SERIAL PRIMARY KEY,
    idClient INTEGER,
    idSeance INTEGER NOT NULL,
    dateHeure TIMESTAMP NOT NULL,
    idSiege INTEGER NOT NULL,
    idCategorie INTEGER NOT NULL,
    numeroSiege VARCHAR(20) NOT NULL,
    prix DECIMAL(10, 2) CHECK (prix >= 0),
    FOREIGN KEY (idClient) REFERENCES Client(id) ON DELETE SET NULL,
    FOREIGN KEY (idSeance) REFERENCES Seance(id),
    FOREIGN KEY (idSiege) REFERENCES Siege(id),
    FOREIGN KEY (idCategorie) REFERENCES Categorie(id),
    UNIQUE(idSeance,idSiege,numeroSiege)
);

-- Tables pour les paiements
CREATE TABLE ModePaiement (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Paiement (
    id SERIAL PRIMARY KEY,
    idBillet INTEGER NOT NULL,
    montant DECIMAL(10, 2) CHECK (montant > 0),
    date TIMESTAMP NOT NULL,
    idModePaiement INTEGER NOT NULL,
    FOREIGN KEY (idBillet) REFERENCES Billet(id),
    FOREIGN KEY (idModePaiement) REFERENCES ModePaiement(id)
);

-- ============================================
-- INDEX POUR LES PERFORMANCES
-- ============================================

-- Index pour les recherches fréquentes
CREATE INDEX idx_film_titre ON Film(titre);
CREATE INDEX idx_film_datesortie ON Film(dateSortie);
CREATE INDEX idx_seance_dateheure ON Seance(dateHeureDebut);
CREATE INDEX idx_seance_film ON Seance(idFilm);
CREATE INDEX idx_seance_salle ON Seance(idSalle);
CREATE INDEX idx_billet_seance ON Billet(idSeance);
CREATE INDEX idx_billet_client ON Billet(idClient);
CREATE INDEX idx_paiement_billet ON Paiement(idBillet);
CREATE INDEX idx_paiement_date ON Paiement(date);

-- Index pour les clés étrangères souvent utilisées
CREATE INDEX idx_filmgenre_film ON FilmGenre(idFilm);
CREATE INDEX idx_filmgenre_genre ON FilmGenre(idGenre);
CREATE INDEX idx_filmacteur_film ON FilmActeur(idFilm);
CREATE INDEX idx_filmacteur_acteur ON FilmActeur(idActeur);
CREATE INDEX idx_seanceprix_seance ON SeancePrix(idSeance);

-- ============================================
-- VUES UTILES
-- ============================================

-- Vue pour afficher les séances avec informations détaillées
CREATE VIEW VueSeancesDetails AS
SELECT 
    s.id,
    f.titre as film,
    s.dateHeureDebut,
    sa.nom as salle,
    l.libelle as langage,
    st.libelle as statut,
    s.prixBase
FROM Seance s
JOIN Film f ON s.idFilm = f.id
JOIN Salle sa ON s.idSalle = sa.id
JOIN Langage l ON s.idLangage = l.id
JOIN StatutSeance st ON s.idStatutSeance = st.id;



-- ============================================
-- COMMENTAIRES SUR LES TABLES
-- ============================================

COMMENT ON TABLE Film IS 'Table des films disponibles au cinéma';
COMMENT ON TABLE Seance IS 'Table des séances de projection';
COMMENT ON TABLE Billet IS 'Table des billets vendus';
COMMENT ON TABLE SalleSiege IS 'Table de liaison entre salles et types de sièges avec leur nombre';
COMMENT ON TABLE Client IS 'Table des clients (idClient nullable dans Billet pour achat sur place)';

-- ============================================
-- DONNEES DE BASE POUR LES TABLES DE REFERENCE
-- ============================================

-- Insertion des statuts de séance par défaut
INSERT INTO StatutSeance (libelle) VALUES 
('Programmée'),
('Confirmée'),
('Annulée'),
('Terminée');

-- Insertion des modes de paiement par défaut
INSERT INTO ModePaiement (libelle) VALUES 
('Espèces'),
('Carte Bancaire'),
('Carte de Fidélité'),
('Chèque'),
('Virement');

-- Insertion des types de sièges courants
INSERT INTO Siege (libelle) VALUES 
('Standard'),
('VIP'),
('Handicapé'),
('Fauteuil'),
('Box');

-- Insertion des langages courants
INSERT INTO Langage (libelle) VALUES 
('VO'),
('VF'),
('VOST'),
('VOSTFR');

-- Insertion des catégories courantes
INSERT INTO Categorie (libelle) VALUES 
('Adulte'),
('Enfant');
('Senior'),
('Groupe');

-- Insertion des genres courants
INSERT INTO Genre (libelle) VALUES 
('Action'),
('Comedie'),
('Drame'),
('Science-Fiction'),
('Thriller'),
('Horreur'),
('Romance'),
('Animation');


-- ============================================
-- DONNEES POUR LES SEANCES
-- (Assurez-vous que les données des tables référencées existent déjà)
-- ============================================

-- 1. D'abord, ajoutons quelques films s'ils n'existent pas
INSERT INTO Film (titre, dateSortie, duree) VALUES
('Titanic', '2010-07-16', 148);
('The Dark Knight', '2008-07-18', 152),
('Parasite', '2019-05-21', 132),
('La La Land', '2016-08-31', 128),
('Interstellar', '2014-11-05', 169)
ON CONFLICT DO NOTHING;

-- 2. Ajoutons quelques salles si elles n'existent pas
INSERT INTO Salle (nom, capacite) VALUES
('Salle 1 - Grand Ecran', 250),
('Salle 2 - 3D', 180),
('Salle 3 - Premium', 120),
('Salle 4 - Standard', 200),
('Salle 5 - Intimiste', 80)
ON CONFLICT DO NOTHING;

-- 3. Insérons les séances pour la semaine à venir
INSERT INTO Seance (idFilm, dateHeureDebut, idSalle, idLangage, prixBase, idStatutSeance) VALUES
-- Séances pour aujourd'hui
(
    (SELECT id FROM Film WHERE titre = 'Inception'),
    CURRENT_DATE + INTERVAL '18:30',
    (SELECT id FROM Salle WHERE nom = 'Salle 1 - Grand Ecran'),
    (SELECT id FROM Langage WHERE libelle = 'VOST'),
    12.50,
    (SELECT id FROM StatutSeance WHERE libelle = 'Confirmée')
),
(
    (SELECT id FROM Film WHERE titre = 'The Dark Knight'),
    CURRENT_DATE + INTERVAL '21:00',
    (SELECT id FROM Salle WHERE nom = 'Salle 2 - 3D'),
    (SELECT id FROM Langage WHERE libelle = 'VO'),
    14.00,
    (SELECT id FROM StatutSeance WHERE libelle = 'Confirmée')
),
-- Séances pour demain
(
    (SELECT id FROM Film WHERE titre = 'Parasite'),
    CURRENT_DATE + INTERVAL '1 day' + INTERVAL '17:00',
    (SELECT id FROM Salle WHERE nom = 'Salle 3 - Premium'),
    (SELECT id FROM Langage WHERE libelle = 'VOSTFR'),
    11.50,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
(
    (SELECT id FROM Film WHERE titre = 'La La Land'),
    CURRENT_DATE + INTERVAL '1 day' + INTERVAL '20:30',
    (SELECT id FROM Salle WHERE nom = 'Salle 1 - Grand Ecran'),
    (SELECT id FROM Langage WHERE libelle = 'VF'),
    10.50,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
(
    (SELECT id FROM Film WHERE titre = 'Interstellar'),
    CURRENT_DATE + INTERVAL '1 day' + INTERVAL '22:00',
    (SELECT id FROM Salle WHERE nom = 'Salle 2 - 3D'),
    (SELECT id FROM Langage WHERE libelle = 'VO'),
    15.00,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
-- Séances pour après-demain (matinée, après-midi, soir)
(
    (SELECT id FROM Film WHERE titre = 'Inception'),
    CURRENT_DATE + INTERVAL '2 days' + INTERVAL '14:00',
    (SELECT id FROM Salle WHERE nom = 'Salle 4 - Standard'),
    (SELECT id FROM Langage WHERE libelle = 'VF'),
    9.00,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
(
    (SELECT id FROM Film WHERE titre = 'The Dark Knight'),
    CURRENT_DATE + INTERVAL '2 days' + INTERVAL '17:30',
    (SELECT id FROM Salle WHERE nom = 'Salle 2 - 3D'),
    (SELECT id FROM Langage WHERE libelle = 'VO'),
    13.50,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
(
    (SELECT id FROM Film WHERE titre = 'Parasite'),
    CURRENT_DATE + INTERVAL '2 days' + INTERVAL '21:15',
    (SELECT id FROM Salle WHERE nom = 'Salle 3 - Premium'),
    (SELECT id FROM Langage WHERE libelle = 'VOST'),
    12.00,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
-- Séances pour le week-end (vendredi soir)
(
    (SELECT id FROM Film WHERE titre = 'La La Land'),
    CURRENT_DATE + INTERVAL '3 days' + INTERVAL '19:00',
    (SELECT id FROM Salle WHERE nom = 'Salle 1 - Grand Ecran'),
    (SELECT id FROM Langage WHERE libelle = 'VOSTFR'),
    11.00,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
(
    (SELECT id FROM Film WHERE titre = 'Interstellar'),
    CURRENT_DATE + INTERVAL '3 days' + INTERVAL '22:30',
    (SELECT id FROM Salle WHERE nom = 'Salle 2 - 3D'),
    (SELECT id FROM Langage WHERE libelle = 'VO'),
    16.00,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
-- Séance spéciale - Séance annulée
(
    (SELECT id FROM Film WHERE titre = 'The Dark Knight'),
    CURRENT_DATE + INTERVAL '4 days' + INTERVAL '20:00',
    (SELECT id FROM Salle WHERE nom = 'Salle 1 - Grand Ecran'),
    (SELECT id FROM Langage WHERE libelle = 'VF'),
    12.50,
    (SELECT id FROM StatutSeance WHERE libelle = 'Annulée')
),
-- Séance terminée (hier)
(
    (SELECT id FROM Film WHERE titre = 'Inception'),
    CURRENT_DATE - INTERVAL '1 day' + INTERVAL '20:00',
    (SELECT id FROM Salle WHERE nom = 'Salle 1 - Grand Ecran'),
    (SELECT id FROM Langage WHERE libelle = 'VO'),
    12.50,
    (SELECT id FROM StatutSeance WHERE libelle = 'Terminée')
),
-- Séances supplémentaires
(
    (SELECT id FROM Film WHERE titre = 'Parasite'),
    CURRENT_DATE + INTERVAL '5 days' + INTERVAL '18:45',
    (SELECT id FROM Salle WHERE nom = 'Salle 5 - Intimiste'),
    (SELECT id FROM Langage WHERE libelle = 'VOST'),
    13.00,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
(
    (SELECT id FROM Film WHERE titre = 'La La Land'),
    CURRENT_DATE + INTERVAL '6 days' + INTERVAL '16:30',
    (SELECT id FROM Salle WHERE nom = 'Salle 3 - Premium'),
    (SELECT id FROM Langage WHERE libelle = 'VF'),
    10.00,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
),
(
    (SELECT id FROM Film WHERE titre = 'Interstellar'),
    CURRENT_DATE + INTERVAL '6 days' + INTERVAL '21:00',
    (SELECT id FROM Salle WHERE nom = 'Salle 1 - Grand Ecran'),
    (SELECT id FROM Langage WHERE libelle = 'VOSTFR'),
    14.50,
    (SELECT id FROM StatutSeance WHERE libelle = 'Programmée')
);

-- 4. Ajoutons quelques prix spécifiques pour les séances dans SeancePrix
-- (Exemple pour la première séance)
INSERT INTO SeancePrix (idSeance, idCategorie, idSiege, prix)
SELECT 
    s.id,
    c.id,
    sie.id,
    CASE 
        WHEN c.libelle = 'Etudiant' THEN s.prixBase * 0.8
        WHEN c.libelle = 'Enfant' THEN s.prixBase * 0.7
        WHEN c.libelle = 'Senior' THEN s.prixBase * 0.75
        WHEN sie.libelle = 'VIP' THEN s.prixBase * 1.5
        WHEN sie.libelle = 'Box' THEN s.prixBase * 2.0
        ELSE s.prixBase
    END as prix_calcule
FROM Seance s
CROSS JOIN Categorie c
CROSS JOIN Siege sie
WHERE s.dateHeureDebut = CURRENT_DATE + INTERVAL '18:30'
LIMIT 10 -- Limite pour l'exemple
ON CONFLICT DO NOTHING;

INSERT INTO Client (nom, contact) VALUES
('Divers', NULL),
('Jean Dupont', 'jean.dupont@example.com'),
('Marie Curie', 'marie.curie@example.com'),
('Albert Einstein', 'albert.einstein@example.com'),
('Isaac Newton', 'isaac.newton@example.com'),
('Galileo Galilei', 'galileo.galilei@example.com');

-- ============================================
-- AJOUT DES SIÈGES EXISTANTS AUX SALLES EXISTANTES
-- (utilisation uniquement des types de sièges déjà dans la table Siege)
-- ============================================

-- 1. D'abord, voyons quels types de sièges existent déjà
SELECT libelle FROM Siege ORDER BY libelle;

-- 2. Ajout des sièges Standard à toutes les salles qui n'en ont pas
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    s.id,
    (SELECT id FROM Siege WHERE libelle = 'Standard'),
    CASE 
        WHEN s.nom LIKE '%Premium%' THEN 20
        WHEN s.nom LIKE '%Grand%' OR s.nom LIKE '%Auditorium%' THEN 50
        WHEN s.capacite > 200 THEN 40
        WHEN s.capacite > 100 THEN 25
        ELSE 15
    END
FROM Salle s
WHERE NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    WHERE ss.idSalle = s.id
    AND ss.idSiege = (SELECT id FROM Siege WHERE libelle = 'Standard')
)
ON CONFLICT DO NOTHING;

-- 3. Ajout des sièges VIP à certaines salles qui n'en ont pas
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    s.id,
    (SELECT id FROM Siege WHERE libelle = 'VIP'),
    CASE 
        WHEN s.nom LIKE '%Premium%' THEN 15
        WHEN s.nom LIKE '%Grand%' THEN 25
        WHEN s.capacite > 200 THEN 20
        WHEN s.capacite > 100 THEN 10
        ELSE 5
    END
FROM Salle s
WHERE s.nom NOT LIKE '%Junior%'  -- Pas de VIP dans la salle Junior
AND NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    WHERE ss.idSalle = s.id
    AND ss.idSiege = (SELECT id FROM Siege WHERE libelle = 'VIP')
)
ON CONFLICT DO NOTHING;

-- 4. Ajout des sièges Handicapé à toutes les salles qui n'en ont pas
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    s.id,
    (SELECT id FROM Siege WHERE libelle = 'Handicapé'),
    CASE 
        WHEN s.capacite >= 300 THEN 8
        WHEN s.capacite >= 200 THEN 6
        WHEN s.capacite >= 100 THEN 4
        ELSE 2
    END
FROM Salle s
WHERE NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    WHERE ss.idSalle = s.id
    AND ss.idSiege = (SELECT id FROM Siege WHERE libelle = 'Handicapé')
)
ON CONFLICT DO NOTHING;

-- 5. Ajout des sièges Fauteuil aux salles premium/confot
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    s.id,
    (SELECT id FROM Siege WHERE libelle = 'Fauteuil'),
    CASE 
        WHEN s.nom LIKE '%Premium%' OR s.nom LIKE '%Club%' OR s.nom LIKE '%Cosy%' THEN 30
        WHEN s.capacite < 100 THEN 20
        ELSE 15
    END
FROM Salle s
WHERE (s.nom LIKE '%Premium%' OR s.nom LIKE '%Club%' OR s.capacite < 120)
AND NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    WHERE ss.idSalle = s.id
    AND ss.idSiege = (SELECT id FROM Siege WHERE libelle = 'Fauteuil')
)
ON CONFLICT DO NOTHING;

-- 6. Ajout des sièges Box aux grandes salles
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    s.id,
    (SELECT id FROM Siege WHERE libelle = 'Box'),
    CASE 
        WHEN s.capacite >= 300 THEN 6
        WHEN s.capacite >= 200 THEN 4
        ELSE 2
    END
FROM Salle s
WHERE s.capacite >= 150
AND NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    WHERE ss.idSalle = s.id
    AND ss.idSiege = (SELECT id FROM Siege WHERE libelle = 'Box')
)
ON CONFLICT DO NOTHING;

-- 7. Configuration spécifique pour chaque salle existante
-- Salle 1 - Grand Ecran : ajout de Fauteuil et Box
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    (SELECT id FROM Salle WHERE nom = 'Salle 1 - Grand Ecran'),
    (SELECT id FROM Siege WHERE libelle = 'Fauteuil'),
    25
WHERE NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    JOIN Salle s ON ss.idSalle = s.id
    JOIN Siege sie ON ss.idSiege = sie.id
    WHERE s.nom = 'Salle 1 - Grand Ecran'
    AND sie.libelle = 'Fauteuil'
)
ON CONFLICT DO NOTHING;

INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    (SELECT id FROM Salle WHERE nom = 'Salle 1 - Grand Ecran'),
    (SELECT id FROM Siege WHERE libelle = 'Box'),
    5
WHERE NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    JOIN Salle s ON ss.idSalle = s.id
    JOIN Siege sie ON ss.idSiege = sie.id
    WHERE s.nom = 'Salle 1 - Grand Ecran'
    AND sie.libelle = 'Box'
)
ON CONFLICT DO NOTHING;

-- Salle 2 - 3D : ajout de Fauteuil
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    (SELECT id FROM Salle WHERE nom = 'Salle 2 - 3D'),
    (SELECT id FROM Siege WHERE libelle = 'Fauteuil'),
    20
WHERE NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    JOIN Salle s ON ss.idSalle = s.id
    JOIN Siege sie ON ss.idSiege = sie.id
    WHERE s.nom = 'Salle 2 - 3D'
    AND sie.libelle = 'Fauteuil'
)
ON CONFLICT DO NOTHING;

-- Salle 3 - Premium : ajout de Box
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    (SELECT id FROM Salle WHERE nom = 'Salle 3 - Premium'),
    (SELECT id FROM Siege WHERE libelle = 'Box'),
    8
WHERE NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    JOIN Salle s ON ss.idSalle = s.id
    JOIN Siege sie ON ss.idSiege = sie.id
    WHERE s.nom = 'Salle 3 - Premium'
    AND sie.libelle = 'Box'
)
ON CONFLICT DO NOTHING;

-- Salle 4 - Standard : ajout de Fauteuil
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    (SELECT id FROM Salle WHERE nom = 'Salle 4 - Standard'),
    (SELECT id FROM Siege WHERE libelle = 'Fauteuil'),
    15
WHERE NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    JOIN Salle s ON ss.idSalle = s.id
    JOIN Siege sie ON ss.idSiege = sie.id
    WHERE s.nom = 'Salle 4 - Standard'
    AND sie.libelle = 'Fauteuil'
)
ON CONFLICT DO NOTHING;

-- Salle 5 - Intimiste : déjà bien équipée en Fauteuils, ajout de VIP
INSERT INTO SalleSiege (idSalle, idSiege, nombre)
SELECT 
    (SELECT id FROM Salle WHERE nom = 'Salle 5 - Intimiste'),
    (SELECT id FROM Siege WHERE libelle = 'VIP'),
    10
WHERE NOT EXISTS (
    SELECT 1 FROM SalleSiege ss
    JOIN Salle s ON ss.idSalle = s.id
    JOIN Siege sie ON ss.idSiege = sie.id
    WHERE s.nom = 'Salle 5 - Intimiste'
    AND sie.libelle = 'VIP'
)
ON CONFLICT DO NOTHING;

-- update SalleSiege set prix_siege=100000 where idSiege=(select id from siege where libelle='VIP');
--
-- UPDATE Siege set libelle='Premium' WHERE libelle='Handicapé';
--
-- UPDATE billet set prix=200000 WHERE idSeance=(SELECT id FROM Seance s JOIN Salle sl ON s.idSalle=sl.id WHERE sl.nom='alea2') AND Billet.idCategorie=1 LIMIT 10;


