// Passeport.java
package com.visa.example.entity;

import jakarta.persistence.*;
import java.util.Date;
import java.io.Serializable;

@Entity
@Table(name = "passeport")
public class Passeport implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "numero", length = 50, nullable = false, unique = true)
    private String numero;
    
    @ManyToOne
    @JoinColumn(name = "id_demandeur", nullable = false)
    private Demandeur demandeur;
    
    @Column(name = "date_delivrance", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateDelivrance;
    
    @Column(name = "date_expiration", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateExpiration;
    
    public Passeport() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getNumero() {
        return numero;
    }
    
    public void setNumero(String numero) {
        this.numero = numero;
    }
    
    public Demandeur getDemandeur() {
        return demandeur;
    }
    
    public void setDemandeur(Demandeur demandeur) {
        this.demandeur = demandeur;
    }
    
    public Date getDateDelivrance() {
        return dateDelivrance;
    }
    
    public void setDateDelivrance(Date dateDelivrance) {
        this.dateDelivrance = dateDelivrance;
    }
    
    public Date getDateExpiration() {
        return dateExpiration;
    }
    
    public void setDateExpiration(Date dateExpiration) {
        this.dateExpiration = dateExpiration;
    }
}
