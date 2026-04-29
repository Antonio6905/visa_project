# Implementation 1 - Formulaire Demande Nouveau Titre

Date: 2026-04-21

## Objectif couvert

Mise en place de la premiere fonctionnalite demandee dans prompt.txt:
- formulaire de demande nouveau titre
- validation des champs obligatoires
- statut initial de la demande: cree
- pieces justificatives communes + pieces specifiques dynamiques selon type de visa
- enregistrement des pieces cochees

## Fonctionnalites implementees

### 1) Backend MVC + metier

- Ajout du DTO de formulaire:
  - src/main/java/com/visa/example/dto/NouveauTitreForm.java
  - Champs demandeur, passeport, typeVisa, liste pieceIds
  - Validation via annotations (`@NotBlank`, `@NotNull`)

- Ajout du service metier transactionnel:
  - src/main/java/com/visa/example/service/DemandeNouveauTitreService.java
  - Orchestration de creation:
    1. validation metier (dates passeport, numero passeport unique)
    2. creation `Demandeur`
    3. creation `Passeport`
    4. creation `Demande` avec:
       - `typeDemande` resolu pour nouveau titre (fallback possible sur renouvellement)
       - `statut` resolu pour cree
    5. enregistrement des `DemandePiece`
  - Validation pieces:
    - seules les pieces autorisees (communes + specifiques du type visa) sont acceptees
    - si une piece obligatoire (obligatoire=true) est manquante, la soumission est refusee

- Ajout du controleur:
  - src/main/java/com/visa/example/controller/DemandeNouveauTitreController.java
  - Endpoints:
    - `GET /demandes/nouveau-titre`: affiche le formulaire
    - `POST /demandes/nouveau-titre`: enregistre la demande
    - `GET /demandes/pieces-specifiques?typeVisaId=...`: retourne les pieces specifiques en JSON
  - Les listes de references chargees pour la vue:
    - types de visa
    - nationalites
    - situations familiales
    - pieces communes
    - pieces specifiques selon type visa

### 2) Vue JSP

- Ajout de la vue formulaire:
  - src/main/webapp/WEB-INF/views/demandes/nouveau-titre-form.jsp

- Sections implementees:
  - informations demandeur
  - informations passeport
  - choix type visa
  - pieces communes (checkbox)
  - pieces specifiques (checkbox, zone dynamique)

- Integration au layout existant:
  - le controleur renseigne `content = demandes/nouveau-titre-form.jsp`

### 3) Dynamique front (JS)

- Ajout du script:
  - src/main/resources/static/js/nouveau-titre.js

- Comportement:
  - ecoute du changement de `typeVisaId`
  - appel AJAX vers `/demandes/pieces-specifiques`
  - rerendu de la liste des pieces specifiques
  - conservation des selections deja cochees tant que possible

### 4) Navigation

- Ajout d'un lien vers le formulaire dans le header:
  - src/main/webapp/WEB-INF/views/includes/header.jsp
  - lien: `/demandes/nouveau-titre`

## Corrections techniques necessaires effectuees

Ces corrections etaient indispensables pour compiler et executer correctement le projet:

1. Entites corrigees:
- Suppression d'erreurs de structure dans:
  - src/main/java/com/visa/example/entity/DemandePiece.java
  - src/main/java/com/visa/example/entity/PieceSpecifiqueTypeVisa.java
  - src/main/java/com/visa/example/entity/SituationFamiliale.java

2. Classes d'ID composite disponibles:
- src/main/java/com/visa/example/entity/DemandePieceId.java
- src/main/java/com/visa/example/entity/PieceSpecifiqueTypeVisaId.java

3. Migration JPA vers Spring Boot 3:
- remplacement des imports `javax.persistence.*` par `jakarta.persistence.*` dans les entites

4. Encodage des fichiers entites:
- re-ecriture en UTF-8 sans BOM pour eviter `illegal character: '\ufeff'`

## Verification

Compilation validee avec:
- `./mvnw.cmd -DskipTests clean compile`

Resultat:
- BUILD SUCCESS

## Notes de reprise

- Le code suppose que les tables de reference (`type_demande`, `statut_demande`, `type_visa`, `piece_justificative`) sont deja alimentees.
- Pour type_demande nouveau titre, le service essaie les codes:
  - `NOUVEAU_TITRE`, `NOUVEAU`, puis fallback `RENOUVELLEMENT`.
- Pour statut cree, le service essaie les codes:
  - `CREE`, `CREATED`, `CREATION`, `NOUVEAU`.
- Si aucun code/libelle correspondant n'existe en base, le service renvoie une erreur explicite.

## Ajout 2 - Liste, detail et modification des demandes

Date: 2026-04-21

### Objectif couvert

- afficher la liste de toutes les demandes
- fournir un lien pour voir les details d'une demande
- fournir un lien pour modifier une demande

### Backend ajoute

- Nouveau DTO edition:
  - src/main/java/com/visa/example/dto/DemandeEditForm.java

- Nouvelles capacites service:
  - src/main/java/com/visa/example/service/DemandeNouveauTitreService.java
  - recuperation de toutes les demandes
  - recuperation d'une demande par id
  - recuperation des pieces d'une demande
  - modification de la demande (type visa + pieces)

- Nouvelles routes controleur:
  - src/main/java/com/visa/example/controller/DemandeNouveauTitreController.java
  - `GET /demandes` -> liste
  - `GET /demandes/{id}` -> detail
  - `GET /demandes/{id}/edit` -> formulaire de modification
  - `POST /demandes/{id}/edit` -> sauvegarde des modifications

### Vues ajoutees

- src/main/webapp/WEB-INF/views/demandes/list.jsp
  - tableau des demandes
  - bouton voir details
  - bouton modifier

- src/main/webapp/WEB-INF/views/demandes/detail.jsp
  - informations principales de la demande
  - liste des pieces associees
  - bouton de modification

- src/main/webapp/WEB-INF/views/demandes/edit.jsp
  - modification du type de visa
  - modification des pieces communes/specifiques
  - pieces specifiques dynamiques via le JS existant

### Navigation

- header mis a jour:
  - src/main/webapp/WEB-INF/views/includes/header.jsp
  - lien ajoute vers `/demandes`

### Ajustement build

- pom.xml mis a jour pour exclure de la compilation le dossier legacy suivant, qui contenait des doublons casses:
  - src/main/java/entity/**

### Verification

- Compilation validee avec:
  - `./mvnw.cmd -DskipTests compile`
