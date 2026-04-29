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

    /**
     * Chemin relatif du fichier PDF uploadé pour cette pièce justificative.
     * Exemple : "uploads/demandes/3/PASS_1234567890.pdf"
     * NULL tant que le fichier n'a pas été uploadé.
     */
    @Column(name = "chemin_fichier", length = 500)
    private String cheminFichier;

    public DemandePiece() {}

    public Demande getDemande() { return demande; }
    public void setDemande(Demande demande) { this.demande = demande; }

    public PieceJustificative getPiece() { return piece; }
    public void setPiece(PieceJustificative piece) { this.piece = piece; }

    public String getCheminFichier() { return cheminFichier; }
    public void setCheminFichier(String cheminFichier) { this.cheminFichier = cheminFichier; }

    /** Indique si le fichier PDF a été uploadé pour cette pièce. */
    public boolean isFichierUploaded() {
        return cheminFichier != null && !cheminFichier.isBlank();
    }
}