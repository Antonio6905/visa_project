package com.visa.example.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "situation_familiale")
public class SituationFamiliale implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "libelle", length = 100, nullable = false)
    private String libelle;
    
    public SituationFamiliale() {}
    
    public SituationFamiliale(String libelle) {
        this.libelle = libelle;
    }

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
}
