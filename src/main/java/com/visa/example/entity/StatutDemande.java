// StatutDemande.java
package com.visa.example.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "statut_demande")
public class StatutDemande implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "libelle", length = 100, nullable = false)
    private String libelle;
    
    @Column(name = "code", length = 20, nullable = false, unique = true)
    private String code;
    
    public StatutDemande() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getLibelle() {
        return libelle;
    }
    
    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
}
