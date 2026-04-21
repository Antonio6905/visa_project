// DemandeurRepository.java
package com.visa.example.repository;

import com.visa.example.entity.Demandeur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DemandeurRepository extends JpaRepository<Demandeur, Long> {
    
    List<Demandeur> findByNom(String nom);
    
    List<Demandeur> findByEmail(String email);
    
    @Query("SELECT d FROM Demandeur d WHERE d.contact = :contact")
    Demandeur findByContact(@Param("contact") String contact);
}