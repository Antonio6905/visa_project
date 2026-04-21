<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.visa.example.entity.Demande" %>
<%@ page import="com.visa.example.entity.PieceJustificative" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>

<%
    Demande demande = (Demande) request.getAttribute("demande");
    List<PieceJustificative> pieces = (List<PieceJustificative>) request.getAttribute("pieces");
    if (pieces == null) {
        pieces = Collections.emptyList();
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<div class="card shadow-sm border-0">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0">Detail demande #<%= demande.getId() %></h4>
        <div>
            <a href="${pageContext.request.contextPath}/demandes" class="btn btn-light btn-sm">Retour liste</a>
            <a href="${pageContext.request.contextPath}/demandes/<%= demande.getId() %>/edit" class="btn btn-warning btn-sm">Modifier</a>
        </div>
    </div>
    <div class="card-body">
        <div class="row g-3">
            <div class="col-md-4">
                <strong>Date demande:</strong><br>
                <%= demande.getDateDemande() != null ? sdf.format(demande.getDateDemande()) : "-" %>
            </div>
            <div class="col-md-4">
                <strong>Type demande:</strong><br>
                <%= demande.getTypeDemande() != null ? demande.getTypeDemande().getLibelle() : "-" %>
            </div>
            <div class="col-md-4">
                <strong>Statut:</strong><br>
                <%= demande.getStatut() != null ? demande.getStatut().getLibelle() : "-" %>
            </div>
            <div class="col-md-6">
                <strong>Type visa:</strong><br>
                <%= demande.getTypeVisa() != null ? demande.getTypeVisa().getLibelle() : "-" %>
            </div>
            <div class="col-md-6">
                <strong>Visa transformable:</strong><br>
                <%= demande.getVisaTransformable() != null ? demande.getVisaTransformable().getNumeroVisaTransformable() : "-" %>
            </div>
        </div>

        <hr>

        <h5>Pieces justificatives fournies</h5>
        <% if (pieces.isEmpty()) { %>
            <div class="alert alert-secondary mb-0">Aucune piece associee.</div>
        <% } else { %>
            <ul class="list-group">
                <% for (PieceJustificative piece : pieces) { %>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <span><%= piece.getLibelle() %></span>
                        <span class="badge bg-<%= Boolean.TRUE.equals(piece.getObligatoire()) ? "danger" : "secondary" %>">
                            <%= Boolean.TRUE.equals(piece.getObligatoire()) ? "obligatoire" : "optionnelle" %>
                        </span>
                    </li>
                <% } %>
            </ul>
        <% } %>
    </div>
</div>
