// DemandePiece.java
package com.visa.example.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

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

// DemandePieceId.java
package com.visa.example.entity;

import java.io.Serializable;
import java.util.Objects;

public class DemandePieceId implements Serializable {
    private Long demande;
    private Long piece;
    
    public DemandePieceId() {}
    
    public Long getDemande() {
        return demande;
    }
    
    public void setDemande(Long demande) {
        this.demande = demande;
    }
    
    public Long getPiece() {
        return piece;
    }
    
    public void setPiece(Long piece) {
        this.piece = piece;
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DemandePieceId that = (DemandePieceId) o;
        return Objects.equals(demande, that.demande) && 
               Objects.equals(piece, that.piece);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(demande, piece);
    }
}