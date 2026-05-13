package com.visa.example.repository;

import com.visa.example.entity.SignatureImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SignatureImageRepository extends JpaRepository<SignatureImage, Long> {
}
