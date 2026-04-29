<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.visa.example.dto.NouveauTitreForm" %>
<%@ page import="com.visa.example.entity.Nationalite" %>
<%@ page import="com.visa.example.entity.PieceJustificative" %>
<%@ page import="com.visa.example.entity.SituationFamiliale" %>
<%@ page import="com.visa.example.entity.TypeVisa" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>

<%
    NouveauTitreForm form = (NouveauTitreForm) request.getAttribute("form");
    if (form == null) form = new NouveauTitreForm();

    List<TypeVisa> typeVisas = (List<TypeVisa>) request.getAttribute("typeVisas");
    if (typeVisas == null) typeVisas = Collections.emptyList();

    List<Nationalite> nationalites = (List<Nationalite>) request.getAttribute("nationalites");
    if (nationalites == null) nationalites = Collections.emptyList();

    List<SituationFamiliale> situationsFamiliales = (List<SituationFamiliale>) request.getAttribute("situationsFamiliales");
    if (situationsFamiliales == null) situationsFamiliales = Collections.emptyList();

    List<PieceJustificative> piecesCommunes = (List<PieceJustificative>) request.getAttribute("piecesCommunes");
    if (piecesCommunes == null) piecesCommunes = Collections.emptyList();

    List<PieceJustificative> piecesSpecifiques = (List<PieceJustificative>) request.getAttribute("piecesSpecifiques");
    if (piecesSpecifiques == null) piecesSpecifiques = Collections.emptyList();

    Set<Long> selectedPieceIds = new HashSet<>();
    if (form.getPieceIds() != null) selectedPieceIds.addAll(form.getPieceIds());

    String ctxPath = request.getContextPath();
%>

<div class="card shadow-sm border-0">
    <div class="card-header bg-primary text-white">
        <h4 class="mb-0">Formulaire de Demande Nouveau Titre</h4>
    </div>
    <div class="card-body">
        <p class="text-muted">
            Les champs marqués par <strong>*</strong> sont obligatoires.
            <br>
            <i class="bi bi-file-earmark-pdf me-1"></i>
            Pour chaque pièce cochée, vous pouvez uploader un fichier PDF (max 10 Mo).
            Les pièces obligatoires devront toutes être uploadées avant de passer en statut SCAN.
        </p>

        <%-- enctype multipart pour supporter les uploads de fichiers --%>
        <form method="post"
              action="<%= ctxPath %>/demandes/nouveau-titre"
              enctype="multipart/form-data"
              id="demandeNouveauTitreForm">
            <div class="row g-3">

                <%-- ── Demandeur ── --%>
                <div class="col-12">
                    <h5 class="text-primary border-bottom pb-1">Informations Demandeur</h5>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Nom *</label>
                    <input type="text" class="form-control" name="nom"
                           value="<%= form.getNom() != null ? form.getNom() : "" %>" required maxlength="100">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Prénom</label>
                    <input type="text" class="form-control" name="prenom"
                           value="<%= form.getPrenom() != null ? form.getPrenom() : "" %>" maxlength="100">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date de naissance *</label>
                    <input type="date" class="form-control" name="dateNaissance"
                           value="<%= form.getDateNaissance() != null ? form.getDateNaissance().toString() : "" %>" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Nationalité</label>
                    <select class="form-select" name="nationaliteId">
                        <option value="">Sélectionner…</option>
                        <% for (Nationalite n : nationalites) { %>
                        <option value="<%= n.getId() %>"
                            <%= form.getNationaliteId() != null && form.getNationaliteId().equals(n.getId()) ? "selected" : "" %>>
                            <%= n.getLibelle() %>
                        </option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Situation familiale</label>
                    <select class="form-select" name="situationFamilialeId">
                        <option value="">Sélectionner…</option>
                        <% for (SituationFamiliale s : situationsFamiliales) { %>
                        <option value="<%= s.getId() %>"
                            <%= form.getSituationFamilialeId() != null && form.getSituationFamilialeId().equals(s.getId()) ? "selected" : "" %>>
                            <%= s.getLibelle() %>
                        </option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-8">
                    <label class="form-label">Adresse à Madagascar *</label>
                    <textarea class="form-control" name="adresseMada" rows="2" required
                    ><%= form.getAdresseMada() != null ? form.getAdresseMada() : "" %></textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Contact *</label>
                    <input type="text" class="form-control" name="contact"
                           value="<%= form.getContact() != null ? form.getContact() : "" %>" required maxlength="50">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email"
                           value="<%= form.getEmail() != null ? form.getEmail() : "" %>" maxlength="100">
                </div>

                <%-- ── Passeport ── --%>
                <div class="col-12 mt-3">
                    <h5 class="text-primary border-bottom pb-1">Informations Passeport</h5>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Numéro passeport *</label>
                    <input type="text" class="form-control" name="numeroPasseport"
                           value="<%= form.getNumeroPasseport() != null ? form.getNumeroPasseport() : "" %>"
                           required maxlength="50">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date de délivrance *</label>
                    <input type="date" class="form-control" name="dateDelivrancePasseport"
                           value="<%= form.getDateDelivrancePasseport() != null ? form.getDateDelivrancePasseport().toString() : "" %>"
                           required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date d'expiration *</label>
                    <input type="date" class="form-control" name="dateExpirationPasseport"
                           value="<%= form.getDateExpirationPasseport() != null ? form.getDateExpirationPasseport().toString() : "" %>"
                           required>
                </div>

                <%-- ── Visa transformable ── --%>
                <div class="col-12 mt-3">
                    <h5 class="text-primary border-bottom pb-1">Informations Visa Transformable</h5>
                    <p class="text-muted small">Informations relatives au visa en cours de transformation.</p>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Numéro du visa transformable *</label>
                    <input type="text" class="form-control" name="numeroVisaTransformable"
                           value="<%= form.getNumeroVisaTransformable() != null ? form.getNumeroVisaTransformable() : "" %>"
                           required maxlength="50">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date d'entrée sur le territoire *</label>
                    <input type="date" class="form-control" name="dateEntreeTerritoire"
                           value="<%= form.getDateEntreeTerritoire() != null ? form.getDateEntreeTerritoire().toString() : "" %>"
                           required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Lieu d'entrée sur le territoire *</label>
                    <input type="text" class="form-control" name="lieuEntreeTerritoire"
                           value="<%= form.getLieuEntreeTerritoire() != null ? form.getLieuEntreeTerritoire() : "" %>"
                           required maxlength="200">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date de sortie du territoire</label>
                    <input type="date" class="form-control" name="dateSortieTerritoire"
                           value="<%= form.getDateSortieTerritoire() != null ? form.getDateSortieTerritoire().toString() : "" %>">
                </div>

                <%-- ── Type de visa & Pièces ── --%>
                <div class="col-12 mt-3">
                    <h5 class="text-primary border-bottom pb-1">Visa et Pièces Justificatives</h5>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Type de visa *</label>
                    <select class="form-select" name="typeVisaId" id="typeVisaId" required>
                        <option value="">Sélectionner…</option>
                        <% for (TypeVisa tv : typeVisas) { %>
                        <option value="<%= tv.getId() %>"
                            <%= form.getTypeVisaId() != null && form.getTypeVisaId().equals(tv.getId()) ? "selected" : "" %>>
                            <%= tv.getLibelle() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <%-- Pièces communes avec input file inline --%>
                <div class="col-12">
                    <label class="form-label fw-semibold">Pièces communes</label>
                    <div class="row g-2">
                        <% for (PieceJustificative piece : piecesCommunes) { %>
                        <div class="col-md-6">
                            <div class="card border p-0">
                                <div class="card-body p-2">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input piece-checkbox"
                                               type="checkbox" name="pieceIds"
                                               value="<%= piece.getId() %>"
                                               id="piece-commun-<%= piece.getId() %>"
                                               data-piece-id="<%= piece.getId() %>"
                                            <%= selectedPieceIds.contains(piece.getId()) ? "checked" : "" %>>
                                        <label class="form-check-label fw-semibold"
                                               for="piece-commun-<%= piece.getId() %>">
                                            <%= piece.getLibelle() %>
                                            <%= Boolean.TRUE.equals(piece.getObligatoire()) ? " <span class='text-danger'>*</span>" : "" %>
                                        </label>
                                    </div>
                                    <div class="piece-upload-zone" id="upload-zone-<%= piece.getId() %>"
                                         style="<%= selectedPieceIds.contains(piece.getId()) ? "" : "display:none" %>">
                                        <label class="form-label small text-muted mb-1">
                                            <i class="bi bi-file-earmark-pdf me-1"></i>Fichier PDF
                                        </label>
                                        <input type="file" class="form-control form-control-sm"
                                               name="fichiers[<%= piece.getId() %>]"
                                               accept="application/pdf">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>

                <%-- Pièces spécifiques avec input file inline --%>
                <div class="col-12">
                    <label class="form-label fw-semibold">Pièces spécifiques au type de visa</label>
                    <div id="specificPiecesContainer"
                         data-endpoint="<%= ctxPath %>/demandes/pieces-specifiques">
                        <div class="row g-2">
                            <% if (piecesSpecifiques.isEmpty()) { %>
                            <div class="col-12 text-muted">
                                Sélectionnez un type de visa pour afficher les pièces spécifiques.
                            </div>
                            <% } else { for (PieceJustificative piece : piecesSpecifiques) { %>
                            <div class="col-md-6">
                                <div class="card border p-0">
                                    <div class="card-body p-2">
                                        <div class="form-check mb-2">
                                            <input class="form-check-input piece-checkbox"
                                                   type="checkbox" name="pieceIds"
                                                   value="<%= piece.getId() %>"
                                                   id="piece-specific-<%= piece.getId() %>"
                                                   data-piece-id="<%= piece.getId() %>"
                                                <%= selectedPieceIds.contains(piece.getId()) ? "checked" : "" %>>
                                            <label class="form-check-label fw-semibold"
                                                   for="piece-specific-<%= piece.getId() %>">
                                                <%= piece.getLibelle() %>
                                                <%= Boolean.TRUE.equals(piece.getObligatoire()) ? " <span class='text-danger'>*</span>" : "" %>
                                            </label>
                                        </div>
                                        <div class="piece-upload-zone" id="upload-zone-<%= piece.getId() %>"
                                             style="<%= selectedPieceIds.contains(piece.getId()) ? "" : "display:none" %>">
                                            <label class="form-label small text-muted mb-1">
                                                <i class="bi bi-file-earmark-pdf me-1"></i>Fichier PDF
                                            </label>
                                            <input type="file" class="form-control form-control-sm"
                                                   name="fichiers[<%= piece.getId() %>]"
                                                   accept="application/pdf">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } } %>
                        </div>
                    </div>
                </div>

                <div class="col-12 mt-3 d-flex justify-content-end gap-2">
                    <span class="text-muted small align-self-center">
                        <i class="bi bi-info-circle me-1"></i>
                        Les fichiers PDF peuvent aussi être uploadés après création, depuis la page de modification.
                    </span>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save me-1"></i>Enregistrer la demande (statut : créé)
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="<%= ctxPath %>/static/js/nouveau-titre.js"></script>
<script>
(function () {
    // Affiche/masque la zone upload PDF selon l'état de la checkbox
    document.querySelectorAll('.piece-checkbox').forEach(function (cb) {
        cb.addEventListener('change', function () {
            const zone = document.getElementById('upload-zone-' + this.dataset.pieceId);
            if (zone) zone.style.display = this.checked ? '' : 'none';
        });
    });
})();
</script>
