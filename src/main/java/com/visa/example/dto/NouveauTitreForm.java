package com.visa.example.dto;

import org.springframework.format.annotation.DateTimeFormat;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class NouveauTitreForm {

    @NotBlank(message = "Le nom est obligatoire")
    private String nom;

    private String prenom;

    @NotNull(message = "La date de naissance est obligatoire")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dateNaissance;

    private Long nationaliteId;

    private Long situationFamilialeId;

    @NotBlank(message = "L'adresse a Madagascar est obligatoire")
    private String adresseMada;

    @NotBlank(message = "Le contact est obligatoire")
    private String contact;

    private String email;

    @NotBlank(message = "Le numero de passeport est obligatoire")
    private String numeroPasseport;

    @NotNull(message = "La date de delivrance du passeport est obligatoire")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dateDelivrancePasseport;

    @NotNull(message = "La date d'expiration du passeport est obligatoire")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dateExpirationPasseport;

    @NotNull(message = "Le type de visa est obligatoire")
    private Long typeVisaId;

    private List<Long> pieceIds = new ArrayList<>();

    // --- Visa Transformable ---

    @NotBlank(message = "Le numero du visa transformable est obligatoire")
    private String numeroVisaTransformable;

    @NotNull(message = "La date d'entree sur le territoire est obligatoire")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dateEntreeTerritoire;

    @NotBlank(message = "Le lieu d'entree sur le territoire est obligatoire")
    private String lieuEntreeTerritoire;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dateSortieTerritoire;

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public LocalDate getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(LocalDate dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public Long getNationaliteId() {
        return nationaliteId;
    }

    public void setNationaliteId(Long nationaliteId) {
        this.nationaliteId = nationaliteId;
    }

    public Long getSituationFamilialeId() {
        return situationFamilialeId;
    }

    public void setSituationFamilialeId(Long situationFamilialeId) {
        this.situationFamilialeId = situationFamilialeId;
    }

    public String getAdresseMada() {
        return adresseMada;
    }

    public void setAdresseMada(String adresseMada) {
        this.adresseMada = adresseMada;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNumeroPasseport() {
        return numeroPasseport;
    }

    public void setNumeroPasseport(String numeroPasseport) {
        this.numeroPasseport = numeroPasseport;
    }

    public LocalDate getDateDelivrancePasseport() {
        return dateDelivrancePasseport;
    }

    public void setDateDelivrancePasseport(LocalDate dateDelivrancePasseport) {
        this.dateDelivrancePasseport = dateDelivrancePasseport;
    }

    public LocalDate getDateExpirationPasseport() {
        return dateExpirationPasseport;
    }

    public void setDateExpirationPasseport(LocalDate dateExpirationPasseport) {
        this.dateExpirationPasseport = dateExpirationPasseport;
    }

    public Long getTypeVisaId() {
        return typeVisaId;
    }

    public void setTypeVisaId(Long typeVisaId) {
        this.typeVisaId = typeVisaId;
    }

    public List<Long> getPieceIds() {
        return pieceIds;
    }

    public void setPieceIds(List<Long> pieceIds) {
        this.pieceIds = pieceIds;
    }

    public String getNumeroVisaTransformable() {
        return numeroVisaTransformable;
    }

    public void setNumeroVisaTransformable(String numeroVisaTransformable) {
        this.numeroVisaTransformable = numeroVisaTransformable;
    }

    public LocalDate getDateEntreeTerritoire() {
        return dateEntreeTerritoire;
    }

    public void setDateEntreeTerritoire(LocalDate dateEntreeTerritoire) {
        this.dateEntreeTerritoire = dateEntreeTerritoire;
    }

    public String getLieuEntreeTerritoire() {
        return lieuEntreeTerritoire;
    }

    public void setLieuEntreeTerritoire(String lieuEntreeTerritoire) {
        this.lieuEntreeTerritoire = lieuEntreeTerritoire;
    }



    public LocalDate getDateSortieTerritoire() {
        return dateSortieTerritoire;
    }

    public void setDateSortieTerritoire(LocalDate dateSortieTerritoire) {
        this.dateSortieTerritoire = dateSortieTerritoire;
    }
}