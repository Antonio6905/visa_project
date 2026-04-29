// TypeDemandeRepository.java
package com.visa.example.repository;

import com.visa.example.entity.TypeDemande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypeDemandeRepository extends JpaRepository<TypeDemande, Long> {
    
    TypeDemande findByCode(String code);
}