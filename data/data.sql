INSERT INTO situation_familiale (id, libelle) VALUES
(1, 'Célibataire'),
(2, 'Marié(e)'),
(3, 'Divorcé(e)'),
(4, 'Veuf(ve)');

INSERT INTO nationalite (id, libelle) VALUES
(1, 'Malagasy'),
(2, 'Française'),
(3, 'Mauricienne'),
(4, 'Chinoise');

INSERT INTO type_visa (id, code, libelle) VALUES
(1, 'TS', 'Travail salarié'),
(2, 'ETU', 'Étudiant'),
(3, 'INV', 'Investisseur');

INSERT INTO type_demande (id, code, libelle) VALUES
(1, 'REN', 'Renouvellement'),
(2, 'DUP', 'Duplicata'),
(3, 'TRF', 'Transformation');

INSERT INTO statut_demande (id, code, libelle) VALUES
(1, 'EN_ATTENTE', 'En attente'),
(2, 'EN_COURS', 'En cours de traitement'),
(3, 'VALIDE', 'Validée'),
(4, 'REFUSE', 'Refusée');

INSERT INTO piece_justificative (id, code, libelle, commun, obligatoire) VALUES
(1, 'PASS', 'Copie du passeport', TRUE, TRUE),
(2, 'PHOTO', 'Photo d''identité', TRUE, TRUE),
(3, 'DOM', 'Justificatif de domicile', TRUE, FALSE),
(4, 'TRAV', 'Contrat de travail', FALSE, TRUE),
(5, 'CERT', 'Certificat de scolarité', FALSE, TRUE);

INSERT INTO piece_specifique_type_visa VALUES
(1, 4), -- Travail → contrat
(2, 5); -- Étudiant → certificat

INSERT INTO demandeur 
(id, nom, prenom, date_naissance, id_nationalite, id_situation_familiale, adresse_mada, contact, email)
VALUES
(1, 'Rakoto', 'Jean', '1990-05-10', 1, 2, 'Antananarivo', '+261340000001', 'jean.rakoto@test.mg'),
(2, 'Dupont', 'Marie', '1985-03-22', 2, 1, 'Mahajanga', '+261340000002', 'marie.dupont@test.fr'),
(3, 'Li', 'Wei', '1992-11-15', 4, 1, 'Toamasina', '+261340000003', 'li.wei@test.cn');

INSERT INTO passeport 
(id, numero, id_demandeur, date_delivrance, date_expiration)
VALUES
(1, 'P123456', 1, '2020-01-01', '2030-01-01'),
(2, 'P654321', 2, '2019-06-15', '2029-06-15'),
(3, 'P999888', 3, '2021-09-10', '2031-09-10');

INSERT INTO visa_transformable 
(id, id_passeport, numero, date_entree_territoire, lieu_entree_territoire, numero_visa_transformable)
VALUES
(1, 1, 'VT001', '2023-01-10', 'Ivato', 'VISA001'),
(2, 2, 'VT002', '2023-03-05', 'Nosy Be', 'VISA002');

INSERT INTO administrateur 
(id, nom, prenom, email, login, mot_de_passe)
VALUES
(1, 'Admin', 'Principal', 'admin@test.mg', 'admin', 'hashed_pwd'),
(2, 'Agent', 'Visa', 'agent@test.mg', 'agent', 'hashed_pwd');

INSERT INTO demande 
(id, id_visa_transformable, id_statut, id_type_visa, id_type_demande)
VALUES
(1, 1, 1, 1, 3), -- transformation travail
(2, NULL, 1, 2, 1), -- renouvellement étudiant
(3, 2, 2, 3, 3); -- transformation investisseur

INSERT INTO demande_piece VALUES
(1, 1),
(1, 4),
(2, 1),
(2, 5),
(3, 1),
(3, 2);

INSERT INTO historique_statut_demande 
(id_demande, id_administrateur, id_statut_demande)
VALUES
(1, 1, 2),
(1, 2, 3),
(2, 1, 2),
(3, 2, 4);

INSERT INTO visa 
(id, date_delivrance, date_debut, date_fin, numero_visa, id_demande)
VALUES
(1, '2024-01-01', '2024-01-01', '2025-01-01', 'VISA-OK-001', 1);

INSERT INTO carte_resident 
(id, date_delivrance, date_debut, date_fin, numero_carte_resident, id_demande)
VALUES
(1, '2024-02-01', '2024-02-01', '2026-02-01', 'CR-001', 3);