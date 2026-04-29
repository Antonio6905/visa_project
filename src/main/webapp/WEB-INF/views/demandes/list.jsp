<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.visa.example.entity.Demande" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>

<%
    List<Demande> demandes = (List<Demande>) request.getAttribute("demandes");
    if (demandes == null) {
        demandes = Collections.emptyList();
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<div class="card shadow-sm border-0">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0">Liste des demandes</h4>
        <a href="${pageContext.request.contextPath}/demandes/nouveau-titre" class="btn btn-light btn-sm">
            Nouvelle demande
        </a>
    </div>
    <div class="card-body">
        <% if (demandes.isEmpty()) { %>
            <div class="alert alert-info mb-0">Aucune demande enregistree.</div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-striped align-middle">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date demande</th>
                        <th>Type demande</th>
                        <th>Type visa</th>
                        <th>Statut</th>
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Demande demande : demandes) { %>
                        <tr>
                            <td><strong>#<%= demande.getId() %></strong></td>
                            <td><%= demande.getDateDemande() != null ? sdf.format(demande.getDateDemande()) : "-" %></td>
                            <td><%= demande.getTypeDemande() != null ? demande.getTypeDemande().getLibelle() : "-" %></td>
                            <td><%= demande.getTypeVisa() != null ? demande.getTypeVisa().getLibelle() : "-" %></td>
                            <td><%= demande.getStatut() != null ? demande.getStatut().getLibelle() : "-" %></td>
                            <td class="text-end">
                                <a class="btn btn-outline-primary btn-sm"
                                   href="${pageContext.request.contextPath}/demandes/<%= demande.getId() %>">
                                    Voir details
                                </a>
                                <a class="btn btn-outline-secondary btn-sm"
                                   href="${pageContext.request.contextPath}/demandes/<%= demande.getId() %>/edit">
                                    Modifier
                                </a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>
