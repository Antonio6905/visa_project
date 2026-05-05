// DemandeSearchService.java
package com.visa.example.service;

import com.visa.example.dto.DemandeSearchResponseDTO;
import com.visa.example.dto.DemandeSearchResultDTO;
import com.visa.example.entity.Demande;
import com.visa.example.entity.Demandeur;
import com.visa.example.entity.Passeport;
import com.visa.example.entity.VisaTransformable;
import com.visa.example.repository.DemandeRepository;
import com.visa.example.repository.PasseportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DemandeSearchService {

    @Autowired
    private DemandeRepository demandeRepository;

    @Autowired
    private PasseportRepository passeportRepository;

    /**
     * Recherche toutes les demandes du même demandeur que la demande donnée.
     * Met en avant (highlight) la demande recherchée.
     */
    public DemandeSearchResponseDTO searchByDemandeId(Long demandeId) {
        Demande target = demandeRepository.findById(demandeId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Demande #" + demandeId + " introuvable"));

        // Récupérer le demandeur depuis la chaîne demande → visaTransformable → passeport → demandeur
        VisaTransformable vt = target.getVisaTransformable();
        if (vt == null || vt.getPasseport() == null || vt.getPasseport().getDemandeur() == null) {
            // Aucun demandeur associé : retourner uniquement la demande cible
            List<DemandeSearchResultDTO> single = List.of(toDTO(target));
            return new DemandeSearchResponseDTO(single, demandeId);
        }

        Demandeur demandeur = vt.getPasseport().getDemandeur();

        // Tous les passeports du demandeur
        List<Passeport> passeports = passeportRepository.findByDemandeurId(demandeur.getId());

        // Toutes les demandes liées à ces passeports (via visa_transformable)
        List<Demande> toutesLesDemandes = passeports.stream()
                .flatMap(p -> demandeRepository.findAll().stream()
                        .filter(d -> d.getVisaTransformable() != null
                                && d.getVisaTransformable().getPasseport() != null
                                && d.getVisaTransformable().getPasseport().getId().equals(p.getId())))
                .distinct()
                .sorted(Comparator.comparing(Demande::getDateDemande,
                        Comparator.nullsLast(Comparator.naturalOrder())))
                .collect(Collectors.toList());

        List<DemandeSearchResultDTO> dtos = toutesLesDemandes.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());

        return new DemandeSearchResponseDTO(dtos, demandeId);
    }

    /**
     * Recherche toutes les demandes liées à un numéro de passeport,
     * triées par ordre chronologique.
     */
    public DemandeSearchResponseDTO searchByPasseportNumero(String numero) {
        Passeport passeport = passeportRepository.findByNumero(numero);
        if (passeport == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "Passeport « " + numero + " » introuvable");
        }

        // Tous les passeports du même demandeur
        List<Passeport> passeports = passeportRepository.findByDemandeurId(
                passeport.getDemandeur().getId());

        List<Demande> demandes = passeports.stream()
                .flatMap(p -> demandeRepository.findAll().stream()
                        .filter(d -> d.getVisaTransformable() != null
                                && d.getVisaTransformable().getPasseport() != null
                                && d.getVisaTransformable().getPasseport().getId().equals(p.getId())))
                .distinct()
                .sorted(Comparator.comparing(Demande::getDateDemande,
                        Comparator.nullsLast(Comparator.naturalOrder())))
                .collect(Collectors.toList());

        List<DemandeSearchResultDTO> dtos = demandes.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());

        return new DemandeSearchResponseDTO(dtos, null);
    }

    // -------------------------------------------------------------------------
    // Mapping entité → DTO
    // -------------------------------------------------------------------------

    private DemandeSearchResultDTO toDTO(Demande d) {
        DemandeSearchResultDTO dto = new DemandeSearchResultDTO();
        dto.setId(d.getId());
        dto.setDateDemande(d.getDateDemande());

        if (d.getTypeDemande() != null) {
            dto.setTypeDemande(d.getTypeDemande().getLibelle());
        }
        if (d.getTypeVisa() != null) {
            dto.setTypeVisa(d.getTypeVisa().getLibelle());
        }
        if (d.getStatut() != null) {
            dto.setStatutLibelle(d.getStatut().getLibelle());
            dto.setStatutCode(d.getStatut().getCode());
        }

        // Nom du demandeur
        VisaTransformable vt = d.getVisaTransformable();
        if (vt != null && vt.getPasseport() != null && vt.getPasseport().getDemandeur() != null) {
            Demandeur dem = vt.getPasseport().getDemandeur();
            String nom = (dem.getNom() != null ? dem.getNom() : "")
                    + (dem.getPrenom() != null ? " " + dem.getPrenom() : "");
            dto.setNomDemandeur(nom.trim());
        }

        return dto;
    }
}