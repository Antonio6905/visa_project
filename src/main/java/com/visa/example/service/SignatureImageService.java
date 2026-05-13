package com.visa.example.service;

import com.visa.example.entity.SignatureImage;
import com.visa.example.repository.DemandeRepository;
import com.visa.example.repository.SignatureImageRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;

@Service
public class SignatureImageService {

    private final SignatureImageRepository signatureImageRepository;
    private final DemandeRepository demandeRepository;
    private final ImageStorageService imageStorageService;

    public SignatureImageService(
            SignatureImageRepository signatureImageRepository,
            DemandeRepository demandeRepository,
            ImageStorageService imageStorageService) {
        this.signatureImageRepository = signatureImageRepository;
        this.demandeRepository = demandeRepository;
        this.imageStorageService = imageStorageService;
    }

    @Transactional
    public SignatureImage saveOrUpdate(Long demandeId, String imageData, String signatureData) throws IOException {
        if (demandeId == null || !demandeRepository.existsById(demandeId)) {
            throw new IllegalArgumentException("Demande introuvable.");
        }
        if (imageData == null || imageData.isBlank()) {
            throw new IllegalArgumentException("La photo est obligatoire.");
        }
        if (signatureData == null || signatureData.isBlank()) {
            throw new IllegalArgumentException("La signature est obligatoire.");
        }

        String imageUrl = imageStorageService.storeImageData(demandeId, "photo", imageData);
        String signatureUrl = imageStorageService.storeImageData(demandeId, "signature", signatureData);

        SignatureImage entity = signatureImageRepository.findById(demandeId)
                .orElseGet(() -> {
                    SignatureImage created = new SignatureImage();
                    created.setIdDemande(demandeId);
                    return created;
                });

        entity.setUrlImage(imageUrl);
        entity.setUrlSignature(signatureUrl);

        return signatureImageRepository.save(entity);
    }

    public SignatureImage getByDemandeId(Long demandeId) {
        return signatureImageRepository.findById(demandeId).orElse(null);
    }

    public boolean hasPhotoAndSignature(Long demandeId) {
        SignatureImage signatureImage = getByDemandeId(demandeId);
        return signatureImage != null && signatureImage.isComplete();
    }
}
