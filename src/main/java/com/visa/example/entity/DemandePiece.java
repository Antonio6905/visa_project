// DemandePiece.java
package com.visa.example.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "demande_piece")
@IdClass(DemandePieceId.class)
public class DemandePiece implements Serializable {
    
    @Id
    @ManyToOne
    @JoinColumn(name = "id_demande", nullable = false)
    private Demande demande;
    
    @Id
    @ManyToOne
    @JoinColumn(name = "id_piece", nullable = false)
    private PieceJustificative piece;
    
    public DemandePiece() {}
    
    public Demande getDemande() {
        return demande;
    }
    
    public void setDemande(Demande demande) {
        this.demande = demande;
    }
    
    public PieceJustificative getPiece() {
        return piece;
    }
    
    public void setPiece(PieceJustificative piece) {
        this.piece = piece;
    }
}

