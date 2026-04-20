// PieceSpecifiqueTypeVisa.java
package com.visa.example.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

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

// PieceSpecifiqueTypeVisaId.java
package com.visa.example.entity;

import java.io.Serializable;
import java.util.Objects;

public class PieceSpecifiqueTypeVisaId implements Serializable {
    private Long typeVisa;
    private Long pieceJustificative;
    
    public PieceSpecifiqueTypeVisaId() {}
    
    public Long getTypeVisa() {
        return typeVisa;
    }
    
    public void setTypeVisa(Long typeVisa) {
        this.typeVisa = typeVisa;
    }
    
    public Long getPieceJustificative() {
        return pieceJustificative;
    }
    
    public void setPieceJustificative(Long pieceJustificative) {
        this.pieceJustificative = pieceJustificative;
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PieceSpecifiqueTypeVisaId that = (PieceSpecifiqueTypeVisaId) o;
        return Objects.equals(typeVisa, that.typeVisa) && 
               Objects.equals(pieceJustificative, that.pieceJustificative);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(typeVisa, pieceJustificative);
    }
}