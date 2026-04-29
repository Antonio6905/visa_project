package com.visa.example.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

/**
 * Formulaire pour une demande de duplicata ou transfert
 * SANS données antérieures : le demandeur remplit un formulaire
 * complet (identique au nouveau-titre).
 *
 * La soumission crée 2 demandes :
 *   1. Une demande de type NT   → statut VALIDE  (+ Visa + CarteResident générés)
 *   2. Une demande de type DUP ou TRF → statut CREE
 */
public class DuplicataTransfertSansAnterieurForm {

    /** "DUP" ou "TRF" */
    @NotBlank(message = "Le type de demande est obligatoire.")
    private String typeDemande;

    // ── Demandeur ──────────────────────────────────────────
    @NotBlank(message = "Le nom est obligatoire.")
    private String nom;

    private String prenom;

    @NotNull(message = "La date de naissance est obligatoire.")
    private LocalDate dateNaissance;

    private Long nationaliteId;
    private Long situationFamilialeId;

    @NotBlank(message = "L'adresse à Madagascar est obligatoire.")
    private String adresseMada;

    @NotBlank(message = "Le contact est obligatoire.")
    private String contact;

    private String email;

    // ── Passeport ──────────────────────────────────────────
    @NotBlank(message = "Le numéro de passeport est obligatoire.")
    private String numeroPasseport;

    @NotNull(message = "La date de délivrance du passeport est obligatoire.")
    private LocalDate dateDelivrancePasseport;

    @NotNull(message = "La date d'expiration du passeport est obligatoire.")
    private LocalDate dateExpirationPasseport;

    // ── Visa transformable ─────────────────────────────────
    @NotBlank(message = "Le numéro du visa transformable est obligatoire.")
    private String numeroVisaTransformable;

    @NotNull(message = "La date d'entrée sur le territoire est obligatoire.")
    private LocalDate dateEntreeTerritoire;

    @NotBlank(message = "Le lieu d'entrée sur le territoire est obligatoire.")
    private String lieuEntreeTerritoire;

    private LocalDate dateSortieTerritoire;

    // ── Type de visa & pièces ──────────────────────────────
    @NotNull(message = "Le type de visa est obligatoire.")
    private Long typeVisaId;

    private List<Long> pieceIds;

    // ── Visa et CarteResident générés (pour la demande NT VALIDE) ──
    @NotBlank(message = "Le numéro de visa est obligatoire.")
    private String numeroVisa;

    @NotNull(message = "La date de début de validité du visa est obligatoire.")
    private LocalDate dateDebutVisa;

    @NotNull(message = "La date de fin de validité du visa est obligatoire.")
    private LocalDate dateFinVisa;

    @NotBlank(message = "Le numéro de carte résident est obligatoire.")
    private String numeroCarteResident;

    @NotNull(message = "La date de début de la carte résident est obligatoire.")
    private LocalDate dateDebutCarteResident;

    @NotNull(message = "La date de fin de la carte résident est obligatoire.")
    private LocalDate dateFinCarteResident;

    // -------------------------------------------------------
    // Getters / Setters
    // -------------------------------------------------------

    public String getTypeDemande() { return typeDemande; }
    public void setTypeDemande(String typeDemande) { this.typeDemande = typeDemande; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public LocalDate getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; }

    public Long getNationaliteId() { return nationaliteId; }
    public void setNationaliteId(Long nationaliteId) { this.nationaliteId = nationaliteId; }

    public Long getSituationFamilialeId() { return situationFamilialeId; }
    public void setSituationFamilialeId(Long situationFamilialeId) { this.situationFamilialeId = situationFamilialeId; }

    public String getAdresseMada() { return adresseMada; }
    public void setAdresseMada(String adresseMada) { this.adresseMada = adresseMada; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getNumeroPasseport() { return numeroPasseport; }
    public void setNumeroPasseport(String numeroPasseport) { this.numeroPasseport = numeroPasseport; }

    public LocalDate getDateDelivrancePasseport() { return dateDelivrancePasseport; }
    public void setDateDelivrancePasseport(LocalDate dateDelivrancePasseport) { this.dateDelivrancePasseport = dateDelivrancePasseport; }

    public LocalDate getDateExpirationPasseport() { return dateExpirationPasseport; }
    public void setDateExpirationPasseport(LocalDate dateExpirationPasseport) { this.dateExpirationPasseport = dateExpirationPasseport; }

    public String getNumeroVisaTransformable() { return numeroVisaTransformable; }
    public void setNumeroVisaTransformable(String numeroVisaTransformable) { this.numeroVisaTransformable = numeroVisaTransformable; }

    public LocalDate getDateEntreeTerritoire() { return dateEntreeTerritoire; }
    public void setDateEntreeTerritoire(LocalDate dateEntreeTerritoire) { this.dateEntreeTerritoire = dateEntreeTerritoire; }

    public String getLieuEntreeTerritoire() { return lieuEntreeTerritoire; }
    public void setLieuEntreeTerritoire(String lieuEntreeTerritoire) { this.lieuEntreeTerritoire = lieuEntreeTerritoire; }

    public LocalDate getDateSortieTerritoire() { return dateSortieTerritoire; }
    public void setDateSortieTerritoire(LocalDate dateSortieTerritoire) { this.dateSortieTerritoire = dateSortieTerritoire; }

    public Long getTypeVisaId() { return typeVisaId; }
    public void setTypeVisaId(Long typeVisaId) { this.typeVisaId = typeVisaId; }

    public List<Long> getPieceIds() { return pieceIds; }
    public void setPieceIds(List<Long> pieceIds) { this.pieceIds = pieceIds; }

    public String getNumeroVisa() { return numeroVisa; }
    public void setNumeroVisa(String numeroVisa) { this.numeroVisa = numeroVisa; }

    public LocalDate getDateDebutVisa() { return dateDebutVisa; }
    public void setDateDebutVisa(LocalDate dateDebutVisa) { this.dateDebutVisa = dateDebutVisa; }

    public LocalDate getDateFinVisa() { return dateFinVisa; }
    public void setDateFinVisa(LocalDate dateFinVisa) { this.dateFinVisa = dateFinVisa; }

    public String getNumeroCarteResident() { return numeroCarteResident; }
    public void setNumeroCarteResident(String numeroCarteResident) { this.numeroCarteResident = numeroCarteResident; }

    public LocalDate getDateDebutCarteResident() { return dateDebutCarteResident; }
    public void setDateDebutCarteResident(LocalDate dateDebutCarteResident) { this.dateDebutCarteResident = dateDebutCarteResident; }

    public LocalDate getDateFinCarteResident() { return dateFinCarteResident; }
    public void setDateFinCarteResident(LocalDate dateFinCarteResident) { this.dateFinCarteResident = dateFinCarteResident; }
}