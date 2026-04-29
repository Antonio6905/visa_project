package com.visa.example.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * Formulaire pour une demande de duplicata ou transfert
 * lorsque le demandeur possède déjà des données antérieures
 * (identifié par son numéro de carte résident).
 */
public class DuplicataTransfertAvecAnterieurForm {

    /** "DUP" ou "TRF" */
    @NotBlank(message = "Le type de demande est obligatoire.")
    private String typeDemande;

    @NotBlank(message = "Le numéro de carte résident est obligatoire.")
    private String numeroCarteResident;

    // -------------------------------------------------------
    // Getters / Setters
    // -------------------------------------------------------

    public String getTypeDemande() {
        return typeDemande;
    }

    public void setTypeDemande(String typeDemande) {
        this.typeDemande = typeDemande;
    }

    public String getNumeroCarteResident() {
        return numeroCarteResident;
    }

    public void setNumeroCarteResident(String numeroCarteResident) {
        this.numeroCarteResident = numeroCarteResident;
    }
}