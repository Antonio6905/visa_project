// HistoriqueStatutDemandeRepository.java
package com.visa.example.repository;

import com.visa.example.entity.HistoriqueStatutDemande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface HistoriqueStatutDemandeRepository extends JpaRepository<HistoriqueStatutDemande, Long> {
    
    List<HistoriqueStatutDemande> findByDemandeIdOrderByDateUpdateDesc(Long demandeId);
    
    List<HistoriqueStatutDemande> findByAdministrateurId(Long administrateurId);
    
    List<HistoriqueStatutDemande> findByStatutDemandeId(Long statutDemandeId);
}