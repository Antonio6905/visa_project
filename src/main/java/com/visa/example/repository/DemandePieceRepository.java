// DemandePieceRepository.java
package com.visa.example.repository;

import com.visa.example.entity.DemandePiece;
import com.visa.example.entity.DemandePieceId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DemandePieceRepository extends JpaRepository<DemandePiece, DemandePieceId> {
    
    List<DemandePiece> findByDemandeId(Long demandeId);
    
    List<DemandePiece> findByPieceId(Long pieceId);
}