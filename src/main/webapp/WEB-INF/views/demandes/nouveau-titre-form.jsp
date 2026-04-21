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
    if (form == null) {
        form = new NouveauTitreForm();
    }

    List<TypeVisa> typeVisas = (List<TypeVisa>) request.getAttribute("typeVisas");
    if (typeVisas == null) {
        typeVisas = Collections.emptyList();
    }

    List<Nationalite> nationalites = (List<Nationalite>) request.getAttribute("nationalites");
    if (nationalites == null) {
        nationalites = Collections.emptyList();
    }

    List<SituationFamiliale> situationsFamiliales = (List<SituationFamiliale>) request.getAttribute("situationsFamiliales");
    if (situationsFamiliales == null) {
        situationsFamiliales = Collections.emptyList();
    }

    List<PieceJustificative> piecesCommunes = (List<PieceJustificative>) request.getAttribute("piecesCommunes");
    if (piecesCommunes == null) {
        piecesCommunes = Collections.emptyList();
    }

    List<PieceJustificative> piecesSpecifiques = (List<PieceJustificative>) request.getAttribute("piecesSpecifiques");
    if (piecesSpecifiques == null) {
        piecesSpecifiques = Collections.emptyList();
    }

    Set<Long> selectedPieceIds = new HashSet<>();
    if (form.getPieceIds() != null) {
        selectedPieceIds.addAll(form.getPieceIds());
    }

    String selectedPieceIdsCsv = "";
    if (!selectedPieceIds.isEmpty()) {
        StringBuilder sb = new StringBuilder();
        for (Long id : selectedPieceIds) {
            if (sb.length() > 0) {
                sb.append(",");
            }
            sb.append(id);
        }
        selectedPieceIdsCsv = sb.toString();
    }
%>

<div class="card shadow-sm border-0">
    <div class="card-header bg-primary text-white">
        <h4 class="mb-0">Formulaire de Demande Nouveau Titre</h4>
    </div>
    <div class="card-body">
        <p class="text-muted">
            Les champs marques par <strong>*</strong> sont obligatoires.
        </p>

        <form method="post" action="${pageContext.request.contextPath}/demandes/nouveau-titre" id="demandeNouveauTitreForm">
            <div class="row g-3">
                <div class="col-12">
                    <h5 class="text-primary">Informations Demandeur</h5>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Nom *</label>
                    <input type="text" class="form-control" name="nom"
                           value="<%= form.getNom() != null ? form.getNom() : "" %>" required maxlength="100">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Prenom</label>
                    <input type="text" class="form-control" name="prenom"
                           value="<%= form.getPrenom() != null ? form.getPrenom() : "" %>" maxlength="100">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Date de naissance *</label>
                    <input type="date" class="form-control" name="dateNaissance"
                           value="<%= form.getDateNaissance() != null ? form.getDateNaissance().toString() : "" %>" required>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Nationalite</label>
                    <select class="form-select" name="nationaliteId">
                        <option value="">Selectionner...</option>
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
                        <option value="">Selectionner...</option>
                        <% for (SituationFamiliale s : situationsFamiliales) { %>
                        <option value="<%= s.getId() %>"
                                <%= form.getSituationFamilialeId() != null && form.getSituationFamilialeId().equals(s.getId()) ? "selected" : "" %>>
                            <%= s.getLibelle() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="col-md-8">
                    <label class="form-label">Adresse a Madagascar *</label>
                    <textarea class="form-control" name="adresseMada" rows="2" required><%= form.getAdresseMada() != null ? form.getAdresseMada() : "" %></textarea>
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

                <div class="col-12 mt-4">
                    <h5 class="text-primary">Informations Passeport</h5>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Numero passeport *</label>
                    <input type="text" class="form-control" name="numeroPasseport"
                           value="<%= form.getNumeroPasseport() != null ? form.getNumeroPasseport() : "" %>" required maxlength="50">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Date de delivrance *</label>
                    <input type="date" class="form-control" name="dateDelivrancePasseport"
                           value="<%= form.getDateDelivrancePasseport() != null ? form.getDateDelivrancePasseport().toString() : "" %>" required>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Date d'expiration *</label>
                    <input type="date" class="form-control" name="dateExpirationPasseport"
                           value="<%= form.getDateExpirationPasseport() != null ? form.getDateExpirationPasseport().toString() : "" %>" required>
                </div>

                <div class="col-12 mt-4">
                    <h5 class="text-primary">Visa et Pieces Justificatives</h5>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Type de visa *</label>
                    <select class="form-select" name="typeVisaId" id="typeVisaId" required>
                        <option value="">Selectionner...</option>
                        <% for (TypeVisa tv : typeVisas) { %>
                        <option value="<%= tv.getId() %>"
                                <%= form.getTypeVisaId() != null && form.getTypeVisaId().equals(tv.getId()) ? "selected" : "" %>>
                            <%= tv.getLibelle() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="col-12">
                    <label class="form-label">Pieces communes</label>
                    <div class="row g-2">
                        <% for (PieceJustificative piece : piecesCommunes) { %>
                        <div class="col-md-6">
                            <div class="form-check border rounded p-2">
                                <input class="form-check-input" type="checkbox" name="pieceIds"
                                       value="<%= piece.getId() %>" id="piece-commun-<%= piece.getId() %>"
                                    <%= selectedPieceIds.contains(piece.getId()) ? "checked" : "" %>>
                                <label class="form-check-label" for="piece-commun-<%= piece.getId() %>">
                                    <%= piece.getLibelle() %>
                                    <%= Boolean.TRUE.equals(piece.getObligatoire()) ? " *" : "" %>
                                </label>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>

                <div class="col-12">
                    <label class="form-label">Pieces specifiques au type de visa</label>
                    <div id="specificPiecesContainer" data-endpoint="${pageContext.request.contextPath}/demandes/pieces-specifiques">
                        <div class="row g-2">
                            <% if (piecesSpecifiques.isEmpty()) { %>
                            <div class="col-12 text-muted">Selectionnez un type de visa pour afficher les pieces specifiques.</div>
                            <% } else { %>
                                <% for (PieceJustificative piece : piecesSpecifiques) { %>
                                <div class="col-md-6">
                                    <div class="form-check border rounded p-2">
                                        <input class="form-check-input" type="checkbox" name="pieceIds"
                                               value="<%= piece.getId() %>" id="piece-specific-<%= piece.getId() %>"
                                            <%= selectedPieceIds.contains(piece.getId()) ? "checked" : "" %>>
                                        <label class="form-check-label" for="piece-specific-<%= piece.getId() %>">
                                            <%= piece.getLibelle() %>
                                            <%= Boolean.TRUE.equals(piece.getObligatoire()) ? " *" : "" %>
                                        </label>
                                    </div>
                                </div>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                    <input type="hidden" id="selectedPieceIds" value="<%= selectedPieceIdsCsv %>">
                </div>

                <div class="col-12 mt-3 d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">
                        Enregistrer la demande (statut: cree)
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/nouveau-titre.js"></script>
