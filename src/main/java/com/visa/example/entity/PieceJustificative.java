// PieceJustificative.java
package com.visa.example.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "piece_justificative")
public class PieceJustificative implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "code", length = 20, nullable = false, unique = true)
    private String code;
    
    @Column(name = "libelle", length = 200, nullable = false)
    private String libelle;
    
    @Column(name = "commun")
    private Boolean commun = false;
    
    @Column(name = "obligatoire")
    private Boolean obligatoire = false;
    
    public PieceJustificative() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getLibelle() {
        return libelle;
    }
    
    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
    
    public Boolean getCommun() {
        return commun;
    }
    
    public void setCommun(Boolean commun) {
        this.commun = commun;
    }
    
    public Boolean getObligatoire() {
        return obligatoire;
    }
    
    public void setObligatoire(Boolean obligatoire) {
        this.obligatoire = obligatoire;
    }
}
