package com.visa.example.controller;

import com.visa.example.entity.SignatureImage;
import com.visa.example.service.SignatureImageService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/api/demandes")
@CrossOrigin(origins = "*")
public class SignatureImageController {

    private final SignatureImageService signatureImageService;

    public SignatureImageController(SignatureImageService signatureImageService) {
        this.signatureImageService = signatureImageService;
    }

    @PostMapping("/{id}/signature-image")
    public ResponseEntity<SignatureImageResponse> saveSignatureImage(
            @PathVariable("id") Long demandeId,
            @RequestBody SignatureImageRequest request) {
        try {
            SignatureImage saved = signatureImageService.saveOrUpdate(
                    demandeId,
                    request != null ? request.getImageData() : null,
                    request != null ? request.getSignatureData() : null
            );
            return ResponseEntity.ok(new SignatureImageResponse(saved, "Enregistrement réussi."));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest()
                    .body(new SignatureImageResponse(null, ex.getMessage()));
        } catch (IOException ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new SignatureImageResponse(null, "Erreur lors de l'enregistrement des images."));
        }
    }

    public static class SignatureImageRequest {
        private String imageData;
        private String signatureData;

        public String getImageData() {
            return imageData;
        }

        public void setImageData(String imageData) {
            this.imageData = imageData;
        }

        public String getSignatureData() {
            return signatureData;
        }

        public void setSignatureData(String signatureData) {
            this.signatureData = signatureData;
        }
    }

    public static class SignatureImageResponse {
        private Long demandeId;
        private String imageUrl;
        private String signatureUrl;
        private String message;

        public SignatureImageResponse(SignatureImage signatureImage, String message) {
            if (signatureImage != null) {
                this.demandeId = signatureImage.getIdDemande();
                this.imageUrl = signatureImage.getUrlImage();
                this.signatureUrl = signatureImage.getUrlSignature();
            }
            this.message = message;
        }

        public Long getDemandeId() {
            return demandeId;
        }

        public String getImageUrl() {
            return imageUrl;
        }

        public String getSignatureUrl() {
            return signatureUrl;
        }

        public String getMessage() {
            return message;
        }
    }
}
