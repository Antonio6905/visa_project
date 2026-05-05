// DemandeSearchResponseDTO.java
package com.visa.example.dto;

import java.util.List;

public class DemandeSearchResponseDTO {

    private List<DemandeSearchResultDTO> demandes;
    private Long highlightedId; // null si recherche par passeport

    public DemandeSearchResponseDTO() {}

    public DemandeSearchResponseDTO(List<DemandeSearchResultDTO> demandes, Long highlightedId) {
        this.demandes = demandes;
        this.highlightedId = highlightedId;
    }

    public List<DemandeSearchResultDTO> getDemandes() { return demandes; }
    public void setDemandes(List<DemandeSearchResultDTO> demandes) { this.demandes = demandes; }

    public Long getHighlightedId() { return highlightedId; }
    public void setHighlightedId(Long highlightedId) { this.highlightedId = highlightedId; }
}