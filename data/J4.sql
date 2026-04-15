CREATE TABLE Societe (
                         id SERIAL PRIMARY KEY,
                         nom VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE Publicite (
                           id SERIAL PRIMARY KEY,
                           nom VARCHAR(200) NOT NULL UNIQUE,
                           id_societe INTEGER NOT NULL,
                           duree DECIMAL(10,2) NOT NULL check ( duree>0),
                           prix DECIMAL(10,2)  not null check ( prix>0 ),
                           FOREIGN KEY (id_societe) REFERENCES Societe(id)
);

CREATE TABLE PubSeance (
                           id SERIAL PRIMARY KEY,
                           idPublicite INTEGER NOT NULL,
                           idSeance INTEGER NOT NULL,
                           nombre INTEGER NOT NULL check ( nombre >0 ) DEFAULT 1,
                           heureDiffusion TIMESTAMP NOT NULL,
                           prixUnitaire DECIMAL(10,2) NOT NULL check ( prixUnitaire >=0 ) DEFAULT 0,
                           FOREIGN KEY (idPublicite) REFERENCES Publicite(id),
                           FOREIGN KEY (idSeance) REFERENCES Seance(id)
);

-- ============================================
-- DONNEES POUR LES SOCIETES ET PUBLICITES
-- ============================================

-- 1. Insertion des societes publicitaires
INSERT INTO Societe (nom) VALUES
                              ('VANIALA'),
                              ('LEWIS'),
                              ('SOCOBIS');
                              ('McDonald''s'),
                              ('Google'),
                              ('Netflix'),
                              ('Amazon'),
                              ('BMW Group'),
                              ('L''Oreal'),
                              ('PepsiCo'),
                              ('Starbucks'),
                              ('Disney'),
                              ('Samsung'),
                              ('Toyota'),
                              ('Red Bull'),
                              ('Spotify'),
                              ('Airbnb'),
                              ('Uber'),
                              ('Microsoft'),
                              ('Adidas')
    ON CONFLICT DO NOTHING;

-- 2. Insertion des publicites
INSERT INTO Publicite (nom, id_societe, duree, prix) VALUES
-- Coca-Cola
('SOCOBIS', 3, 30.00, 200000),
('Coca-Cola Original - Partager un moment', 1, 45.00, 2200.00),
('Sprite - Rafraichissement citronne', 1, 25.00, 1200.00),

-- Apple
('iPhone 15 Pro - La puissance redefinie', 2, 60.00, 3500.00),
('iPad Pro - Creativite sans limites', 2, 45.00, 2800.00),
('Apple Watch Series 9 - Sante connectee', 2, 30.00, 1800.00),

-- Nike
('Nike Air Max - Just Do It', 3, 40.00, 1900.00),
('Nike Running - Courir vers demain', 3, 35.00, 1600.00),

-- McDonalds
('McDonalds - Nouveau McWrap', 4, 30.00, 1400.00),
('McDonalds - Menu Happy Meal', 4, 25.00, 1100.00),

-- Google
('Google Pixel 8 - Photo parfaite', 5, 50.00, 2400.00),
('Google Nest - Maison intelligente', 5, 40.00, 2000.00),

-- Netflix
('Netflix - Nouvelle serie Stranger Things', 6, 60.00, 3200.00),
('Netflix - Film francais exclusif', 6, 45.00, 2100.00),

-- Amazon
('Amazon Prime Video - The Boys Saison 4', 7, 55.00, 2900.00),
('Amazon Alexa - La vie simplifiee', 7, 35.00, 1700.00),

-- BMW
('BMW i4 - Electrique et elegant', 8, 90.00, 4500.00),
('BMW X5 - Confort et performance', 8, 75.00, 3800.00),

-- LOreal
('LOreal Paris - Parce que je le vaux bien', 9, 30.00, 1300.00),
('Maybelline - Leffet volumes', 9, 25.00, 1100.00),

-- PepsiCo
('Pepsi Max - Sans sucre, gout intense', 10, 30.00, 1250.00),
('Lays - On ne peut en manger quun', 10, 25.00, 1000.00),

-- Starbucks
('Starbucks - Nouveaux cafes dautomne', 11, 40.00, 1800.00),

-- Disney
('Disney+ - Nouveaux films Marvel', 12, 60.00, 3000.00),
('Pixar - Elemental - Bande-annonce', 12, 45.00, 2200.00),

-- Samsung
('Samsung Galaxy S24 - Innovation ultime', 13, 65.00, 3300.00),
('Samsung TV - Image parfaite', 13, 50.00, 2500.00),

-- Toyota
('Toyota Prius - Hybride nouvelle generation', 14, 85.00, 4200.00),

-- Red Bull
('Red Bull - Donne des ailes', 15, 20.00, 900.00),

-- Spotify
('Spotify Premium - Musique sans pub', 16, 35.00, 1600.00),

-- Airbnb
('Airbnb - Vivez comme un local', 17, 45.00, 2100.00),

-- Uber
('Uber Eats - Livraison en 30 min', 18, 30.00, 1400.00),

-- Microsoft
('Microsoft Surface - Travail creatif', 19, 55.00, 2700.00),
('Xbox Series X - Nouveaux jeux', 19, 45.00, 2300.00),

-- Adidas
('Adidas Ultraboost - Confort maximal', 20, 40.00, 1900.00)
    ON CONFLICT DO NOTHING;

INSERT INTO paiementpub (id,id_pub_seance,montant,date) VALUES(1,4,1000000,'2025-12-1 00:00:00');

INSERT INTO paiementpub (id,id_pub_seance,montant,date) VALUES(2,4,500000,'2025-12-1 00:00:00');