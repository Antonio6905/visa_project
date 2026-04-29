// AdministrateurRepository.java
package com.visa.example.repository;

import com.visa.example.entity.Administrateur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdministrateurRepository extends JpaRepository<Administrateur, Long> {
    
    Administrateur findByLogin(String login);
    
    Administrateur findByEmail(String email);
}