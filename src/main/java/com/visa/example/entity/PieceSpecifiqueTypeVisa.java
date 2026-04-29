// PieceSpecifiqueTypeVisa.java
package com.visa.example.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "piece_specifique_type_visa")
@IdClass(PieceSpecifiqueTypeVisaId.class)
public class PieceSpecifiqueTypeVisa implements Serializable {
    
    @Id
    @ManyToOne
    @JoinColumn(name = "id_type_visa", nullable = false)
    private TypeVisa typeVisa;
    
    @Id
    @ManyToOne
    @JoinColumn(name = "id_piece_justificative", nullable = false)
    private PieceJustificative pieceJustificative;
    
    public PieceSpecifiqueTypeVisa() {}
    
    public TypeVisa getTypeVisa() {
        return typeVisa;
    }
    
    public void setTypeVisa(TypeVisa typeVisa) {
        this.typeVisa = typeVisa;
    }
    
    public PieceJustificative getPieceJustificative() {
        return pieceJustificative;
    }
    
    public void setPieceJustificative(PieceJustificative pieceJustificative) {
        this.pieceJustificative = pieceJustificative;
    }
}

