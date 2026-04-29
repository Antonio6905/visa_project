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
        return Objects.equals(demande, that.demande)
                && Objects.equals(piece, that.piece);
    }

    @Override
    public int hashCode() {
        return Objects.hash(demande, piece);
    }
}
