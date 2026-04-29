<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.visa.example.dto.DemandeEditForm" %>
<%@ page import="com.visa.example.entity.Demande" %>
<%@ page import="com.visa.example.entity.DemandePiece" %>
<%@ page import="com.visa.example.entity.PieceJustificative" %>
<%@ page import="com.visa.example.entity.StatutDemande" %>
<%@ page import="com.visa.example.entity.TypeVisa" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Set" %>

<%
    Demande demande = (Demande) request.getAttribute("demande");
    DemandeEditForm editForm = (DemandeEditForm) request.getAttribute("editForm");
    if (editForm == null) editForm = new DemandeEditForm();

    List<TypeVisa> typeVisas = (List<TypeVisa>) request.getAttribute("typeVisas");
    if (typeVisas == null) typeVisas = Collections.emptyList();

    List<PieceJustificative> piecesCommunes = (List<PieceJustificative>) request.getAttribute("piecesCommunes");
    if (piecesCommunes == null) piecesCommunes = Collections.emptyList();

    List<PieceJustificative> piecesSpecifiques = (List<PieceJustificative>) request.getAttribute("piecesSpecifiques");
    if (piecesSpecifiques == null) piecesSpecifiques = Collections.emptyList();

    // Map pieceId → DemandePiece pour savoir quels fichiers sont déjà uploadés
    List<DemandePiece> demandePieces = (List<DemandePiece>) request.getAttribute("demandePieces");
    Map<Long, DemandePiece> demandePieceMap = new HashMap<>();
    if (demandePieces != null) {
        for (DemandePiece dp : demandePieces) {
            if (dp.getPiece() != null) demandePieceMap.put(dp.getPiece().getId(), dp);
        }
    }

    List<StatutDemande> tousStatuts = (List<StatutDemande>) request.getAttribute("tousStatuts");
    if (tousStatuts == null) tousStatuts = Collections.emptyList();

    Set<Long> selectedPieceIds = new HashSet<>();
    if (editForm.getPieceIds() != null) selectedPieceIds.addAll(editForm.getPieceIds());

    String statutActuelCode = (demande.getStatut() != null) ? demande.getStatut().getCode() : "";
    // Une demande est modifiable si son statut n'est pas SCAN, VALIDE ou REFUSE
    boolean estModifiable = !"SCAN".equals(statutActuelCode)
                         && !"VALIDE".equals(statutActuelCode)
                         && !"REFUSE".equals(statutActuelCode);

    String ctxPath = request.getContextPath();
%>

<div class="card shadow-sm border-0 mb-4">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0">Modifier demande #<%= demande.getId() %></h4>
        <div>
            <span class="badge bg-light text-dark me-2">
                <%= demande.getStatut() != null ? demande.getStatut().getLibelle() : "—" %>
            </span>
            <a href="<%= ctxPath %>/demandes/<%= demande.getId() %>" class="btn btn-light btn-sm">Retour détail</a>
            <a href="<%= ctxPath %>/demandes" class="btn btn-outline-light btn-sm">Retour liste</a>
        </div>
    </div>

    <div class="card-body">

        <% if (!estModifiable) { %>
        <div class="alert alert-warning d-flex align-items-center">
            <i class="bi bi-lock-fill me-2 fs-5"></i>
            <span>
                Cette demande est en statut <strong><%= statutActuelCode %></strong>
                et ne peut plus être modifiée (type de visa, pièces).
                Vous pouvez toujours uploader les fichiers PDF manquants.
            </span>
        </div>
        <% } %>

        <%-- ══════════════════════════════════════════════ --%>
        <%-- SECTION 1 : Type de visa + pièces (si modifiable) --%>
        <%-- ══════════════════════════════════════════════ --%>
        <% if (estModifiable) { %>
        <form method="post"
              action="<%= ctxPath %>/demandes/<%= demande.getId() %>/edit"
              id="demandeEditForm">
            <div class="row g-3">
                <div class="col-12">
                    <h5 class="text-primary border-bottom pb-1">Type de visa & Pièces justificatives</h5>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Type de visa *</label>
                    <select class="form-select" name="typeVisaId" id="typeVisaId" required>
                        <option value="">Sélectionner…</option>
                        <% for (TypeVisa tv : typeVisas) { %>
                        <option value="<%= tv.getId() %>"
                            <%= editForm.getTypeVisaId() != null && editForm.getTypeVisaId().equals(tv.getId()) ? "selected" : "" %>>
                            <%= tv.getLibelle() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="col-12">
                    <label class="form-label">Pièces communes</label>
                    <div class="row g-2">
                        <% for (PieceJustificative piece : piecesCommunes) { %>
                        <div class="col-md-6">
                            <div class="form-check border rounded p-2">
                                <input class="form-check-input" type="checkbox" name="pieceIds"
                                       value="<%= piece.getId() %>"
                                       id="piece-commun-<%= piece.getId() %>"
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
                    <label class="form-label">Pièces spécifiques au type de visa</label>
                    <div id="specificPiecesContainer"
                         data-endpoint="<%= ctxPath %>/demandes/pieces-specifiques">
                        <div class="row g-2">
                            <% if (piecesSpecifiques.isEmpty()) { %>
                            <div class="col-12 text-muted">
                                Sélectionnez un type de visa pour afficher les pièces spécifiques.
                            </div>
                            <% } else { for (PieceJustificative piece : piecesSpecifiques) { %>
                            <div class="col-md-6">
                                <div class="form-check border rounded p-2">
                                    <input class="form-check-input" type="checkbox"
                                           name="pieceIds" value="<%= piece.getId() %>"
                                           id="piece-specific-<%= piece.getId() %>"
                                        <%= selectedPieceIds.contains(piece.getId()) ? "checked" : "" %>>
                                    <label class="form-check-label" for="piece-specific-<%= piece.getId() %>">
                                        <%= piece.getLibelle() %>
                                        <%= Boolean.TRUE.equals(piece.getObligatoire()) ? " *" : "" %>
                                    </label>
                                </div>
                            </div>
                            <% } } %>
                        </div>
                    </div>
                </div>

                <div class="col-12 mt-2 d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save me-1"></i>Enregistrer les modifications
                    </button>
                </div>
            </div>
        </form>
        <% } %>

        <%-- ══════════════════════════════════════════════ --%>
        <%-- SECTION 2 : Upload PDF par pièce              --%>
        <%-- ══════════════════════════════════════════════ --%>
        <div class="mt-4">
            <h5 class="text-primary border-bottom pb-1">
                <i class="bi bi-file-earmark-pdf me-1"></i>Fichiers PDF par pièce justificative
            </h5>
            <p class="text-muted small">
                Un seul fichier PDF par pièce (max 10 Mo).
                Les pièces obligatoires doivent toutes être uploadées avant de passer en statut SCAN.
            </p>

            <%
                // Fusion pièces communes + spécifiques pour l'affichage upload
                java.util.LinkedHashMap<Long, PieceJustificative> toutesLesPieces = new java.util.LinkedHashMap<>();
                for (PieceJustificative p : piecesCommunes) toutesLesPieces.put(p.getId(), p);
                for (PieceJustificative p : piecesSpecifiques) toutesLesPieces.put(p.getId(), p);
                // Garder uniquement les pièces sélectionnées pour cette demande
                java.util.List<PieceJustificative> piecesAffichees = new java.util.ArrayList<>();
                for (Long pid : selectedPieceIds) {
                    if (toutesLesPieces.containsKey(pid)) piecesAffichees.add(toutesLesPieces.get(pid));
                }
            %>

            <% if (piecesAffichees.isEmpty()) { %>
            <div class="alert alert-info">
                <i class="bi bi-info-circle me-1"></i>
                Aucune pièce justificative associée à cette demande pour l'instant.
            </div>
            <% } else { %>
            <div class="row g-3">
                <% for (PieceJustificative piece : piecesAffichees) {
                    DemandePiece dp = demandePieceMap.get(piece.getId());
                    boolean uploaded = dp != null && dp.isFichierUploaded();
                %>
                <div class="col-md-6">
                    <div class="card border <%= uploaded ? "border-success" : (Boolean.TRUE.equals(piece.getObligatoire()) ? "border-warning" : "border-secondary") %>">
                        <div class="card-body p-3">
                            <div class="d-flex align-items-start justify-content-between mb-2">
                                <div>
                                    <span class="fw-semibold"><%= piece.getLibelle() %></span>
                                    <% if (Boolean.TRUE.equals(piece.getObligatoire())) { %>
                                    <span class="badge bg-warning text-dark ms-1">Obligatoire</span>
                                    <% } %>
                                </div>
                                <% if (uploaded) { %>
                                <span class="badge bg-success">
                                    <i class="bi bi-check-circle me-1"></i>Uploadé
                                </span>
                                <% } else { %>
                                <span class="badge bg-secondary">
                                    <i class="bi bi-clock me-1"></i>En attente
                                </span>
                                <% } %>
                            </div>

                            <% if (uploaded) { %>
                            <div class="mb-2">
                                <a href="<%= ctxPath %>/demandes/<%= demande.getId() %>/pieces/<%= piece.getId() %>/fichier"
                                   target="_blank" class="btn btn-sm btn-outline-success">
                                    <i class="bi bi-eye me-1"></i>Voir le PDF
                                </a>
                            </div>
                            <% } %>

                            <%-- Formulaire upload (toujours disponible même si statut bloquant, --%>
                            <%-- pour permettre de ré-uploader en cas d'erreur) --%>
                            <form method="post"
                                  action="<%= ctxPath %>/demandes/<%= demande.getId() %>/pieces/<%= piece.getId() %>/upload"
                                  enctype="multipart/form-data"
                                  class="d-flex align-items-center gap-2">
                                <input type="file" class="form-control form-control-sm"
                                       name="fichier" accept="application/pdf" required>
                                <button type="submit" class="btn btn-sm <%= uploaded ? "btn-outline-primary" : "btn-primary" %>" style="white-space:nowrap">
                                    <i class="bi bi-upload me-1"></i><%= uploaded ? "Remplacer" : "Uploader" %>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>

        <%-- ══════════════════════════════════════════════ --%>
        <%-- SECTION 3 : Changement de statut               --%>
        <%-- ══════════════════════════════════════════════ --%>
        <div class="mt-4">
            <h5 class="text-primary border-bottom pb-1">
                <i class="bi bi-arrow-repeat me-1"></i>Changer le statut
            </h5>

            <% if (!estModifiable) { %>
            <div class="alert alert-secondary">
                <i class="bi bi-lock me-1"></i>
                Le statut <strong><%= statutActuelCode %></strong> est final et ne peut plus être modifié.
            </div>
            <% } else { %>
            <form method="post"
                  action="<%= ctxPath %>/demandes/<%= demande.getId() %>/statut"
                  class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label">Nouveau statut *</label>
                    <select class="form-select" name="nouveauStatut" required>
                        <option value="">Sélectionner…</option>
                        <% for (StatutDemande sd : tousStatuts) {
                            if (sd.getCode().equals(statutActuelCode)) continue; // Exclure le statut actuel
                        %>
                        <option value="<%= sd.getCode() %>"><%= sd.getLibelle() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-auto">
                    <button type="submit" class="btn btn-warning">
                        <i class="bi bi-check2-circle me-1"></i>Appliquer le statut
                    </button>
                </div>
                <div class="col-12">
                    <small class="text-muted">
                        <i class="bi bi-info-circle me-1"></i>
                        Le passage au statut <strong>SCAN</strong> n'est possible que si toutes les pièces
                        obligatoires ont été uploadées.
                    </small>
                </div>
            </form>
            <% } %>
        </div>

    </div><%-- /card-body --%>
</div><%-- /card --%>

<script src="<%= ctxPath %>/static/js/nouveau-titre.js"></script>
