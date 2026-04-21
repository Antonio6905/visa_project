// PieceJustificativeRepository.java
package com.visa.example.repository;

import com.visa.example.entity.PieceJustificative;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PieceJustificativeRepository extends JpaRepository<PieceJustificative, Long> {
    
    PieceJustificative findByCode(String code);
    
    List<PieceJustificative> findByCommun(Boolean commun);
    
    List<PieceJustificative> findByObligatoire(Boolean obligatoire);
}