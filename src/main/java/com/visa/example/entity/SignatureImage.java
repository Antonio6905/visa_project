package com.visa.example.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;

@Entity
@Table(name = "signature_image")
public class SignatureImage implements Serializable {

    @Id
    @Column(name = "id_demande")
    private Long idDemande;

    @Column(name = "url_image", length = 500)
    private String urlImage;

    @Column(name = "url_signature", length = 500)
    private String urlSignature;

    public SignatureImage() {}

    public Long getIdDemande() {
        return idDemande;
    }

    public void setIdDemande(Long idDemande) {
        this.idDemande = idDemande;
    }

    public String getUrlImage() {
        return urlImage;
    }

    public void setUrlImage(String urlImage) {
        this.urlImage = urlImage;
    }

    public String getUrlSignature() {
        return urlSignature;
    }

    public void setUrlSignature(String urlSignature) {
        this.urlSignature = urlSignature;
    }

    public boolean hasPhoto() {
        return urlImage != null && !urlImage.isBlank();
    }

    public boolean hasSignature() {
        return urlSignature != null && !urlSignature.isBlank();
    }

    public boolean isComplete() {
        return hasPhoto() && hasSignature();
    }
}
