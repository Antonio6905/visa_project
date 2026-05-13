// DemandeSearchResultDTO.java
package com.visa.example.dto;

import java.util.Date;

public class DemandeSearchResultDTO {

    private Long id;
    private Date dateDemande;
    private String nomDemandeur;
    private String typeDemande;
    private String typeVisa;
    private String statutLibelle;
    private String statutCode;

    public DemandeSearchResultDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Date getDateDemande() { return dateDemande; }
    public void setDateDemande(Date dateDemande) { this.dateDemande = dateDemande; }

    public String getNomDemandeur() { return nomDemandeur; }
    public void setNomDemandeur(String nomDemandeur) { this.nomDemandeur = nomDemandeur; }

    public String getTypeDemande() { return typeDemande; }
    public void setTypeDemande(String typeDemande) { this.typeDemande = typeDemande; }

    public String getTypeVisa() { return typeVisa; }
    public void setTypeVisa(String typeVisa) { this.typeVisa = typeVisa; }

    public String getStatutLibelle() { return statutLibelle; }
    public void setStatutLibelle(String statutLibelle) { this.statutLibelle = statutLibelle; }

    public String getStatutCode() { return statutCode; }
    public void setStatutCode(String statutCode) { this.statutCode = statutCode; }
}