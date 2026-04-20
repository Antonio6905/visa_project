// DemandeRepository.java
package com.visa.example.repository;

import com.visa.example.entity.Demande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DemandeRepository extends JpaRepository<Demande, Long> {
    
    List<Demande> findByStatutId(Long statutId);
    
    List<Demande> findByTypeVisaId(Long typeVisaId);
    
    List<Demande> findByTypeDemandeId(Long typeDemandeId);
    
    @Query("SELECT d FROM Demande d WHERE d.visaTransformable.id = :visaTransformableId")
    List<Demande> findByVisaTransformableId(@Param("visaTransformableId") Long visaTransformableId);
}