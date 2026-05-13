(function () {
    const typeVisaSelect = document.getElementById("typeVisaId");
    const specificContainer = document.getElementById("specificPiecesContainer");
    const selectedIdsInput = document.getElementById("selectedPieceIds");

    if (!typeVisaSelect || !specificContainer || !selectedIdsInput) {
        return;
    }

    const selectedSet = new Set(
        selectedIdsInput.value
            .split(",")
            .map((value) => Number(value.trim()))
            .filter((value) => !Number.isNaN(value) && value > 0)
    );

    const endpoint = specificContainer.getAttribute("data-endpoint");

    const syncHiddenValue = () => {
        selectedIdsInput.value = Array.from(selectedSet).join(",");
    };

    const onCheckboxChange = (event) => {
        const input = event.target;
        if (!input || input.name !== "pieceIds") return;

        const id = Number(input.value);
        if (Number.isNaN(id)) return;

        if (input.checked) {
            selectedSet.add(id);
        } else {
            selectedSet.delete(id);
        }
        syncHiddenValue();

        // Affiche/masque la zone upload PDF associée
        const zone = document.getElementById("upload-zone-" + id);
        if (zone) zone.style.display = input.checked ? "" : "none";
    };

    // Attache les listeners sur les checkboxes existantes (pièces communes)
    document.querySelectorAll('input[name="pieceIds"]').forEach((checkbox) => {
        checkbox.addEventListener("change", onCheckboxChange);
    });

    const escapeHtml = (value) => {
        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    };

    const renderPiecesSpecifiques = (pieces) => {
        if (!pieces || pieces.length === 0) {
            specificContainer.innerHTML =
                '<div class="row g-2"><div class="col-12 text-muted">Aucune piece specifique pour ce type de visa.</div></div>';
            return;
        }

        // Génère le même HTML que le JSP : card + zone upload PDF
        const rowsHtml = pieces
            .map((piece) => {
                const checked = selectedSet.has(Number(piece.id)) ? "checked" : "";
                const mandatory = piece.obligatoire
                    ? " <span class='text-danger'>*</span>"
                    : "";
                const uploadVisible = selectedSet.has(Number(piece.id)) ? "" : "display:none";

                return `
                <div class="col-md-6">
                    <div class="card border p-0">
                        <div class="card-body p-2">
                            <div class="form-check mb-2">
                                <input class="form-check-input piece-checkbox"
                                       type="checkbox" name="pieceIds"
                                       value="${piece.id}"
                                       id="piece-specific-${piece.id}"
                                       data-piece-id="${piece.id}"
                                       ${checked}>
                                <label class="form-check-label fw-semibold"
                                       for="piece-specific-${piece.id}">
                                    ${escapeHtml(piece.libelle)}${mandatory}
                                </label>
                            </div>
                            <div class="piece-upload-zone" id="upload-zone-${piece.id}"
                                 style="${uploadVisible}">
                                <label class="form-label small text-muted mb-1">
                                    <i class="bi bi-file-earmark-pdf me-1"></i>Fichier PDF
                                </label>
                                <input type="file" class="form-control form-control-sm"
                                       name="fichiers[${piece.id}]"
                                       accept="application/pdf">
                            </div>
                        </div>
                    </div>
                </div>`;
            })
            .join("");

        specificContainer.innerHTML = `<div class="row g-2">${rowsHtml}</div>`;

        // Rattache les listeners sur les nouvelles checkboxes
        specificContainer.querySelectorAll('input[name="pieceIds"]').forEach((checkbox) => {
            checkbox.addEventListener("change", onCheckboxChange);
        });
    };

    const loadPiecesSpecifiques = async () => {
        const typeVisaId = typeVisaSelect.value;
        if (!typeVisaId) {
            specificContainer.innerHTML =
                '<div class="row g-2"><div class="col-12 text-muted">Sélectionnez un type de visa pour afficher les pièces spécifiques.</div></div>';
            return;
        }

        specificContainer.innerHTML =
            '<div class="text-muted"><span class="spinner-border spinner-border-sm me-1"></span>Chargement…</div>';

        try {
            const response = await fetch(`${endpoint}?typeVisaId=${encodeURIComponent(typeVisaId)}`);
            if (!response.ok) throw new Error("Impossible de charger les pieces specifiques.");
            const pieces = await response.json();
            renderPiecesSpecifiques(pieces);
        } catch (error) {
            specificContainer.innerHTML =
                '<div class="text-danger">Erreur lors du chargement des pieces specifiques.</div>';
        }
    };

    typeVisaSelect.addEventListener("change", loadPiecesSpecifiques);
    syncHiddenValue();

    // ── CORRECTION CLEF : déclencher le chargement si un type visa est déjà sélectionné
    // (cas du rechargement après erreur de validation, ou pré-sélection)
    if (typeVisaSelect.value) {
        loadPiecesSpecifiques();
    }
})();