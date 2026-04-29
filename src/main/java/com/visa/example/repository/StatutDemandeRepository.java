// StatutDemandeRepository.java
package com.visa.example.repository;

import com.visa.example.entity.StatutDemande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StatutDemandeRepository extends JpaRepository<StatutDemande, Long> {
    
    StatutDemande findByCode(String code);
}