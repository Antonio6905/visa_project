// PieceSpecifiqueTypeVisaRepository.java
package com.visa.example.repository;

import com.visa.example.entity.PieceSpecifiqueTypeVisa;
import com.visa.example.entity.PieceSpecifiqueTypeVisaId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PieceSpecifiqueTypeVisaRepository extends JpaRepository<PieceSpecifiqueTypeVisa, PieceSpecifiqueTypeVisaId> {
    
    List<PieceSpecifiqueTypeVisa> findByTypeVisaId(Long typeVisaId);
}