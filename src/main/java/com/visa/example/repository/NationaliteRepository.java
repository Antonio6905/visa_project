// NationaliteRepository.java
package com.visa.example.repository;

import com.visa.example.entity.Nationalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NationaliteRepository extends JpaRepository<Nationalite, Long> {
}