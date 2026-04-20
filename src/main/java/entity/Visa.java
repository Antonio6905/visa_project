// Visa.java
package com.visa.example.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;

@Entity
@Table(name = "visa")
public class Visa implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "date_delivrance", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateDelivrance;
    
    @Column(name = "date_debut", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateDebut;
    
    @Column(name = "date_fin", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateFin;
    
    @Column(name = "numero_visa", length = 50, nullable = false, unique = true)
    private String numeroVisa;
    
    @OneToOne
    @JoinColumn(name = "id_demande", nullable = false, unique = true)
    private Demande demande;
    
    public Visa() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Date getDateDelivrance() {
        return dateDelivrance;
    }
    
    public void setDateDelivrance(Date dateDelivrance) {
        this.dateDelivrance = dateDelivrance;
    }
    
    public Date getDateDebut() {
        return dateDebut;
    }
    
    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }
    
    public Date getDateFin() {
        return dateFin;
    }
    
    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }
    
    public String getNumeroVisa() {
        return numeroVisa;
    }
    
    public void setNumeroVisa(String numeroVisa) {
        this.numeroVisa = numeroVisa;
    }
    
    public Demande getDemande() {
        return demande;
    }
    
    public void setDemande(Demande demande) {
        this.demande = demande;
    }
}