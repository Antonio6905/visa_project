// TypeVisaRepository.java
package com.visa.example.repository;

import com.visa.example.entity.TypeVisa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypeVisaRepository extends JpaRepository<TypeVisa, Long> {
    
    TypeVisa findByCode(String code);
}