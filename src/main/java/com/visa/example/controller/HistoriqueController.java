// HistoriqueController.java
package com.visa.example.controller;

import com.visa.example.entity.HistoriqueStatutDemande;
import com.visa.example.repository.HistoriqueStatutDemandeRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/demandes")
@CrossOrigin(origins = "*")
public class HistoriqueController {

    private final HistoriqueStatutDemandeRepository historiqueRepo;

    public HistoriqueController(HistoriqueStatutDemandeRepository historiqueRepo) {
        this.historiqueRepo = historiqueRepo;
    }

    /**
     * GET /api/demandes/{id}/historique
     * Retourne l'historique des statuts d'une demande, du plus récent au plus ancien.
     */
    @GetMapping("/{id}/historique")
    public ResponseEntity<List<HistoriqueDTO>> getHistorique(@PathVariable Long id) {
        List<HistoriqueStatutDemande> historiques =
                historiqueRepo.findByDemandeId(id);

        List<HistoriqueDTO> dtos = historiques.stream()
                .sorted(Comparator.comparing(
                        HistoriqueStatutDemande::getDateUpdate,
                        Comparator.nullsLast(Comparator.reverseOrder())))
                .map(HistoriqueDTO::new)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }

    // ── DTO interne ───────────────────────────────────────
    public static class HistoriqueDTO {
        private Long id;
        private String statutLibelle;
        private String statutCode;
        private java.util.Date dateUpdate;
        private String adminLogin;

        public HistoriqueDTO(HistoriqueStatutDemande h) {
            this.id            = h.getId();
            this.dateUpdate    = h.getDateUpdate();
            this.statutLibelle = h.getStatutDemande() != null
                    ? h.getStatutDemande().getLibelle() : null;
            this.statutCode    = h.getStatutDemande() != null
                    ? h.getStatutDemande().getCode() : null;
            this.adminLogin    = h.getAdministrateur() != null
                    ? h.getAdministrateur().getLogin() : null;
        }

        public Long getId()              { return id; }
        public String getStatutLibelle() { return statutLibelle; }
        public String getStatutCode()    { return statutCode; }
        public java.util.Date getDateUpdate() { return dateUpdate; }
        public String getAdminLogin()    { return adminLogin; }
    }
}