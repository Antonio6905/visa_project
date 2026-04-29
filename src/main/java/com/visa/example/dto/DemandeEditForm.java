package com.visa.example.dto;

import jakarta.validation.constraints.NotNull;

import java.util.ArrayList;
import java.util.List;

public class DemandeEditForm {

    @NotNull(message = "Le type de visa est obligatoire")
    private Long typeVisaId;

    private List<Long> pieceIds = new ArrayList<>();

    public Long getTypeVisaId() {
        return typeVisaId;
    }

    public void setTypeVisaId(Long typeVisaId) {
        this.typeVisaId = typeVisaId;
    }

    public List<Long> getPieceIds() {
        return pieceIds;
    }

    public void setPieceIds(List<Long> pieceIds) {
        this.pieceIds = pieceIds;
    }
}
