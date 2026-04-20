// VisaTransformable.java
package com.visa.example.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;

@Entity
@Table(name = "visa_transformable")
public class VisaTransformable implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "id_passeport", nullable = false)
    private Passeport passeport;
    
    @Column(name = "numero", length = 50, nullable = false)
    private String numero;
    
    @Column(name = "date_entree_territoire", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateEntreeTerritoire;
    
    @Column(name = "lieu_entree_territoire", length = 200, nullable = false)
    private String lieuEntreeTerritoire;
    
    @Column(name = "numero_visa_transformable", length = 50, nullable = false)
    private String numeroVisaTransformable;
    
    @Column(name = "date_sortie_territoire")
    @Temporal(TemporalType.DATE)
    private Date dateSortieTerritoire;
    
    public VisaTransformable() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Passeport getPasseport() {
        return passeport;
    }
    
    public void setPasseport(Passeport passeport) {
        this.passeport = passeport;
    }
    
    public String getNumero() {
        return numero;
    }
    
    public void setNumero(String numero) {
        this.numero = numero;
    }
    
    public Date getDateEntreeTerritoire() {
        return dateEntreeTerritoire;
    }
    
    public void setDateEntreeTerritoire(Date dateEntreeTerritoire) {
        this.dateEntreeTerritoire = dateEntreeTerritoire;
    }
    
    public String getLieuEntreeTerritoire() {
        return lieuEntreeTerritoire;
    }
    
    public void setLieuEntreeTerritoire(String lieuEntreeTerritoire) {
        this.lieuEntreeTerritoire = lieuEntreeTerritoire;
    }
    
    public String getNumeroVisaTransformable() {
        return numeroVisaTransformable;
    }
    
    public void setNumeroVisaTransformable(String numeroVisaTransformable) {
        this.numeroVisaTransformable = numeroVisaTransformable;
    }
    
    public Date getDateSortieTerritoire() {
        return dateSortieTerritoire;
    }
    
    public void setDateSortieTerritoire(Date dateSortieTerritoire) {
        this.dateSortieTerritoire = dateSortieTerritoire;
    }
}