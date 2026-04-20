// Demande.java
package com.visa.example.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;

@Entity
@Table(name = "demande")
public class Demande implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "id_visa_transformable")
    private VisaTransformable visaTransformable;
    
    @ManyToOne
    @JoinColumn(name = "id_statut", nullable = false)
    private StatutDemande statut;
    
    @Column(name = "date_demande")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateDemande;
    
    @ManyToOne
    @JoinColumn(name = "id_type_visa", nullable = false)
    private TypeVisa typeVisa;
    
    @ManyToOne
    @JoinColumn(name = "id_type_demande", nullable = false)
    private TypeDemande typeDemande;
    
    @PrePersist
    protected void onCreate() {
        dateDemande = new Date();
    }
    
    public Demande() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public VisaTransformable getVisaTransformable() {
        return visaTransformable;
    }
    
    public void setVisaTransformable(VisaTransformable visaTransformable) {
        this.visaTransformable = visaTransformable;
    }
    
    public StatutDemande getStatut() {
        return statut;
    }
    
    public void setStatut(StatutDemande statut) {
        this.statut = statut;
    }
    
    public Date getDateDemande() {
        return dateDemande;
    }
    
    public void setDateDemande(Date dateDemande) {
        this.dateDemande = dateDemande;
    }
    
    public TypeVisa getTypeVisa() {
        return typeVisa;
    }
    
    public void setTypeVisa(TypeVisa typeVisa) {
        this.typeVisa = typeVisa;
    }
    
    public TypeDemande getTypeDemande() {
        return typeDemande;
    }
    
    public void setTypeDemande(TypeDemande typeDemande) {
        this.typeDemande = typeDemande;
    }
}