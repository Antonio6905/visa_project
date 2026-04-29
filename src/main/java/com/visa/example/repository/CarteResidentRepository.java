// CarteResidentRepository.java
package com.visa.example.repository;

import com.visa.example.entity.CarteResident;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CarteResidentRepository extends JpaRepository<CarteResident, Long> {
    
    CarteResident findByNumeroCarteResident(String numeroCarteResident);
    
    CarteResident findByDemandeId(Long demandeId);
}