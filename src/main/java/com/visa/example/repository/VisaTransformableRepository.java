// VisaTransformableRepository.java
package com.visa.example.repository;

import com.visa.example.entity.VisaTransformable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface VisaTransformableRepository extends JpaRepository<VisaTransformable, Long> {
    
    List<VisaTransformable> findByPasseportId(Long passeportId);
    
    VisaTransformable findByNumeroVisaTransformable(String numeroVisaTransformable);
}