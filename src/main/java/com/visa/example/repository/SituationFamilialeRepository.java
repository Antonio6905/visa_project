// SituationFamilialeRepository.java
package com.visa.example.repository;

import com.visa.example.entity.SituationFamiliale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SituationFamilialeRepository extends JpaRepository<SituationFamiliale, Long> {
}