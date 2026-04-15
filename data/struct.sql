Info_personne:
    nom
    prenom
    date_naissance
    nationalite
    adresse
    contact
    email
    profession
    date_entree_territoire
    lieu_entree_territoire
    created_at

type_visa:
    code
    libelle

piece_justificative:
    code
    libelle
    commun(yes/no)

piece_specifique_type_visa:
    id_type_visa
    id_piece_justificative

personne_piece:
    id_personne
    id_piece

statut_demande:
    libelle
    code

type_demande(renouvellement/duplicata/nouveau_titre):
    libelle
    code

demande:
    id_personne
    id_statut(last)/valeur_statut(int)
    date_demande
    id_type_visa
    id_type_demande

type_admin:
    libelle 
    code
    valeur

administrateur:
    nom
    identifiant(username/password)
    actif(yes/no)
    id_type_admin

historique_statut_demande:
    id_demande
    id_administrateur
    date_update
    id_statut_demande