// Demandeur.java
package com.visa.example.entity;

import javax.persistence.*;
import java.util.Date;
import java.io.Serializable;

@Entity
@Table(name = "demandeur")
public class Demandeur implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "nom", length = 100, nullable = false)
    private String nom;
    
    @Column(name = "prenom", length = 100)
    private String prenom;
    
    @Column(name = "date_naissance", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateNaissance;
    
    @ManyToOne
    @JoinColumn(name = "id_nationalite")
    private Nationalite nationalite;
    
    @ManyToOne
    @JoinColumn(name = "id_situation_familiale")
    private SituationFamiliale situationFamiliale;
    
    @Column(name = "adresse_mada", nullable = false, columnDefinition = "TEXT")
    private String adresseMada;
    
    @Column(name = "contact", length = 50, nullable = false)
    private String contact;
    
    @Column(name = "email", length = 100)
    private String email;
    
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
    }
    
    public Demandeur() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public String getPrenom() {
        return prenom;
    }
    
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    
    public Date getDateNaissance() {
        return dateNaissance;
    }
    
    public void setDateNaissance(Date dateNaissance) {
        this.dateNaissance = dateNaissance;
    }
    
    public Nationalite getNationalite() {
        return nationalite;
    }
    
    public void setNationalite(Nationalite nationalite) {
        this.nationalite = nationalite;
    }
    
    public SituationFamiliale getSituationFamiliale() {
        return situationFamiliale;
    }
    
    public void setSituationFamiliale(SituationFamiliale situationFamiliale) {
        this.situationFamiliale = situationFamiliale;
    }
    
    public String getAdresseMada() {
        return adresseMada;
    }
    
    public void setAdresseMada(String adresseMada) {
        this.adresseMada = adresseMada;
    }
    
    public String getContact() {
        return contact;
    }
    
    public void setContact(String contact) {
        this.contact = contact;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}