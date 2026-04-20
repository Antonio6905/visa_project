// CarteResident.java
package com.visa.example.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;

@Entity
@Table(name = "carte_resident")
public class CarteResident implements Serializable {
    
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
    
    @Column(name = "numero_carte_resident", length = 50, nullable = false, unique = true)
    private String numeroCarteResident;
    
    @OneToOne
    @JoinColumn(name = "id_demande", nullable = false, unique = true)
    private Demande demande;
    
    public CarteResident() {}
    
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
    
    public String getNumeroCarteResident() {
        return numeroCarteResident;
    }
    
    public void setNumeroCarteResident(String numeroCarteResident) {
        this.numeroCarteResident = numeroCarteResident;
    }
    
    public Demande getDemande() {
        return demande;
    }
    
    public void setDemande(Demande demande) {
        this.demande = demande;
    }
}