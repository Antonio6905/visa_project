// DemandePieceRepository.java
package com.visa.example.repository;

import com.visa.example.entity.DemandePiece;
import com.visa.example.entity.DemandePieceId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface DemandePieceRepository extends JpaRepository<DemandePiece, DemandePieceId> {
    
    List<DemandePiece> findByDemandeId(Long demandeId);

    @Query("SELECT dp FROM DemandePiece dp WHERE dp.demande.id = :demandeId AND dp.piece.id = :pieceId")
    Optional<DemandePiece> findByDemandeIdAndPieceId(
            @Param("demandeId") Long demandeId,
            @Param("pieceId")   Long pieceId);
    
    List<DemandePiece> findByPieceId(Long pieceId);

    @Query("""
        SELECT dp FROM DemandePiece dp
        WHERE dp.demande.id = :demandeId
          AND dp.piece.obligatoire = true
          AND (dp.cheminFichier IS NULL OR dp.cheminFichier = '')
        """)
    List<DemandePiece> findPiecesObligatoiresSansUpload(@Param("demandeId") Long demandeId);
}