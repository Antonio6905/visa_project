// PasseportRepository.java
package com.visa.example.repository;

import com.visa.example.entity.Passeport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PasseportRepository extends JpaRepository<Passeport, Long> {
    
    Passeport findByNumero(String numero);
    
    List<Passeport> findByDemandeurId(Long demandeurId);
}