package com.visa.example.repository;

import com.visa.example.entity.Visa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VisaRepository extends JpaRepository<Visa, Long> {

    /**
     * Vérifie l'unicité du numéro de visa.
     */
    Visa findByNumeroVisa(String numeroVisa);
}