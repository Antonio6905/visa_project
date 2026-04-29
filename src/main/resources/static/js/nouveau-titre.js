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
        if (!input || input.name !== "pieceIds") {
            return;
        }

        const id = Number(input.value);
        if (Number.isNaN(id)) {
            return;
        }

        if (input.checked) {
            selectedSet.add(id);
        } else {
            selectedSet.delete(id);
        }
        syncHiddenValue();
    };

    document.querySelectorAll('input[name="pieceIds"]').forEach((checkbox) => {
        checkbox.addEventListener("change", onCheckboxChange);
    });

    const escapeHtml = (value) => {
        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g, "&#39;");
    };

    const renderPiecesSpecifiques = (pieces) => {
        if (!pieces || pieces.length === 0) {
            specificContainer.innerHTML =
                '<div class="text-muted">Aucune piece specifique pour ce type de visa.</div>';
            return;
        }

        const rowsHtml = pieces
            .map((piece) => {
                const checked = selectedSet.has(Number(piece.id)) ? "checked" : "";
                const mandatory = piece.obligatoire ? " *" : "";
                const label = `${escapeHtml(piece.libelle)}${mandatory}`;
                return `
                    <div class="col-md-6">
                        <div class="form-check border rounded p-2">
                            <input class="form-check-input" type="checkbox" name="pieceIds"
                                   value="${piece.id}" id="piece-specific-${piece.id}" ${checked}>
                            <label class="form-check-label" for="piece-specific-${piece.id}">${label}</label>
                        </div>
                    </div>
                `;
            })
            .join("");

        specificContainer.innerHTML = `<div class="row g-2">${rowsHtml}</div>`;

        specificContainer.querySelectorAll('input[name="pieceIds"]').forEach((checkbox) => {
            checkbox.addEventListener("change", onCheckboxChange);
        });
    };

    const loadPiecesSpecifiques = async () => {
        const typeVisaId = typeVisaSelect.value;
        if (!typeVisaId) {
            renderPiecesSpecifiques([]);
            return;
        }

        try {
            const response = await fetch(`${endpoint}?typeVisaId=${encodeURIComponent(typeVisaId)}`);
            if (!response.ok) {
                throw new Error("Impossible de charger les pieces specifiques.");
            }

            const pieces = await response.json();
            renderPiecesSpecifiques(pieces);
        } catch (error) {
            specificContainer.innerHTML =
                '<div class="text-danger">Erreur lors du chargement des pieces specifiques.</div>';
        }
    };

    typeVisaSelect.addEventListener("change", loadPiecesSpecifiques);
    syncHiddenValue();
})();
