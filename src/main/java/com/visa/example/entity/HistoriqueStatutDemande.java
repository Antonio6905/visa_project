// HistoriqueStatutDemande.java
package com.visa.example.entity;

import jakarta.persistence.*;
import java.util.Date;
import java.io.Serializable;

@Entity
@Table(name = "historique_statut_demande")
public class HistoriqueStatutDemande implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "id_demande", nullable = false)
    private Demande demande;
    
    @ManyToOne
    @JoinColumn(name = "id_administrateur", nullable = false)
    private Administrateur administrateur;
    
    @Column(name = "date_update")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateUpdate;
    
    @ManyToOne
    @JoinColumn(name = "id_statut_demande", nullable = false)
    private StatutDemande statutDemande;
    
    @PrePersist
    protected void onCreate() {
        dateUpdate = new Date();
    }
    
    public HistoriqueStatutDemande() {}
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Demande getDemande() {
        return demande;
    }
    
    public void setDemande(Demande demande) {
        this.demande = demande;
    }
    
    public Administrateur getAdministrateur() {
        return administrateur;
    }
    
    public void setAdministrateur(Administrateur administrateur) {
        this.administrateur = administrateur;
    }
    
    public Date getDateUpdate() {
        return dateUpdate;
    }
    
    public void setDateUpdate(Date dateUpdate) {
        this.dateUpdate = dateUpdate;
    }
    
    public StatutDemande getStatutDemande() {
        return statutDemande;
    }
    
    public void setStatutDemande(StatutDemande statutDemande) {
        this.statutDemande = statutDemande;
    }
}
