// DemandeSearchController.java
package com.visa.example.controller;

import com.visa.example.dto.DemandeSearchResponseDTO;
import com.visa.example.service.DemandeSearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/demandes/search")
@CrossOrigin(origins = "*") // À restreindre en production (ex: origins = "http://localhost:3000")
public class DemandeSearchController {

    @Autowired
    private DemandeSearchService demandeSearchService;

    /**
     * GET /api/demandes/search/by-demande-id/{id}
     *
     * Retourne toutes les demandes du même demandeur,
     * avec highlightedId = id pour focaliser sur la demande recherchée.
     */
    @GetMapping("/by-demande-id/{id}")
    public ResponseEntity<DemandeSearchResponseDTO> searchByDemandeId(@PathVariable Long id) {
        DemandeSearchResponseDTO response = demandeSearchService.searchByDemandeId(id);
        return ResponseEntity.ok(response);
    }

    /**
     * GET /api/demandes/search/by-passport/{numero}
     *
     * Retourne toutes les demandes liées au passeport (et au demandeur associé),
     * par ordre chronologique.
     */
    @GetMapping("/by-passport/{numero}")
    public ResponseEntity<DemandeSearchResponseDTO> searchByPassport(
            @PathVariable String numero) {
        DemandeSearchResponseDTO response = demandeSearchService.searchByPasseportNumero(numero);
        return ResponseEntity.ok(response);
    }
}