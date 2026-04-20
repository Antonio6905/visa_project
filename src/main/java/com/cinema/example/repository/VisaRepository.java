// VisaRepository.java
package com.visa.example.repository;

import com.visa.example.entity.Visa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VisaRepository extends JpaRepository<Visa, Long> {
    
    Visa findByNumeroVisa(String numeroVisa);
    
    Visa findByDemandeId(Long demandeId);
}