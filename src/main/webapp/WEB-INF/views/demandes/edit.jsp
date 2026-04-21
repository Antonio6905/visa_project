<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.visa.example.dto.DemandeEditForm" %>
<%@ page import="com.visa.example.entity.Demande" %>
<%@ page import="com.visa.example.entity.PieceJustificative" %>
<%@ page import="com.visa.example.entity.TypeVisa" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>

<%
    Demande demande = (Demande) request.getAttribute("demande");
    DemandeEditForm editForm = (DemandeEditForm) request.getAttribute("editForm");
    if (editForm == null) {
        editForm = new DemandeEditForm();
    }

    List<TypeVisa> typeVisas = (List<TypeVisa>) request.getAttribute("typeVisas");
    if (typeVisas == null) {
        typeVisas = Collections.emptyList();
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
    if (editForm.getPieceIds() != null) {
        selectedPieceIds.addAll(editForm.getPieceIds());
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
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0">Modifier demande #<%= demande.getId() %></h4>
        <div>
            <a href="${pageContext.request.contextPath}/demandes/<%= demande.getId() %>" class="btn btn-light btn-sm">Retour detail</a>
            <a href="${pageContext.request.contextPath}/demandes" class="btn btn-outline-light btn-sm">Retour liste</a>
        </div>
    </div>
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/demandes/<%= demande.getId() %>/edit" id="demandeEditForm">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Type de visa *</label>
                    <select class="form-select" name="typeVisaId" id="typeVisaId" required>
                        <option value="">Selectionner...</option>
                        <% for (TypeVisa tv : typeVisas) { %>
                        <option value="<%= tv.getId() %>"
                                <%= editForm.getTypeVisaId() != null && editForm.getTypeVisaId().equals(tv.getId()) ? "selected" : "" %>>
                            <%= tv.getLibelle() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="col-12 mt-3">
                    <h5 class="text-primary">Pieces justificatives</h5>
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
                    <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/nouveau-titre.js"></script>
