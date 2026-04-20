// Administrateur.java
package com.visa.example.entity;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "administrateur")
public class Administrateur implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "nom", length = 100, nullable = false)
    private String nom;
    
    @Column(name = "prenom", length = 100)
    private String prenom;
    
    @Column(name = "email", length = 100, nullable = false, unique = true)
    private String email;
    
    @Column(name = "login", length = 50, nullable = false, unique = true)
    private String login;
    
    @Column(name = "mot_de_passe", length = 255, nullable = false)
    private String motDePasse;
    
    public Administrateur() {}
    
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
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getLogin() {
        return login;
    }
    
    public void setLogin(String login) {
        this.login = login;
    }
    
    public String getMotDePasse() {
        return motDePasse;
    }
    
    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }
}