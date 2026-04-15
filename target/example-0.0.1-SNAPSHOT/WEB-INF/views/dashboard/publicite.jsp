<%-- webapp/views/dashboard/publicite.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%
    // Récupérer les attributs du modèle
    Integer annee = (Integer) request.getAttribute("annee");
    Integer mois = (Integer) request.getAttribute("mois");
    String periodeAffichage = (String) request.getAttribute("periodeAffichage");
    Double chiffreAffaires = (Double) request.getAttribute("chiffreAffaires");
    Integer nombrePublicites = (Integer) request.getAttribute("nombrePublicites");
    Double moyenneParPublicite = (Double) request.getAttribute("moyenneParPublicite");
    Map<LocalDate, Double> chiffreAffairesParJour = (Map<LocalDate, Double>) request.getAttribute("chiffreAffairesParJour");
    Map<String, Double> chiffreAffairesParSociete = (Map<String, Double>) request.getAttribute("chiffreAffairesParSociete");
    List<Integer> anneesDisponibles = (List<Integer>) request.getAttribute("anneesDisponibles");

    // Formateurs
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.FRANCE);
    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd");
%>

<div class="container-fluid">
    <!-- En-tête avec filtres -->
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-filter me-2"></i>Filtres de période
                    </h5>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/dashboard/publicite/filtre" method="post" class="row g-3">
                        <div class="col-md-4">
                            <label for="annee" class="form-label">Année</label>
                            <select class="form-select" id="annee" name="annee" required>
                                <% if (anneesDisponibles != null) {
                                    for (Integer anneeOption : anneesDisponibles) { %>
                                <option value="<%= anneeOption %>"
                                        <% if (annee != null && annee.equals(anneeOption)) { %>selected<% } %>>
                                    <%= anneeOption %>
                                </option>
                                <% }
                                } %>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="mois" class="form-label">Mois</label>
                            <select class="form-select" id="mois" name="mois" required>
                                <option value="1" <% if (mois != null && mois == 1) { %>selected<% } %>>Janvier</option>
                                <option value="2" <% if (mois != null && mois == 2) { %>selected<% } %>>Février</option>
                                <option value="3" <% if (mois != null && mois == 3) { %>selected<% } %>>Mars</option>
                                <option value="4" <% if (mois != null && mois == 4) { %>selected<% } %>>Avril</option>
                                <option value="5" <% if (mois != null && mois == 5) { %>selected<% } %>>Mai</option>
                                <option value="6" <% if (mois != null && mois == 6) { %>selected<% } %>>Juin</option>
                                <option value="7" <% if (mois != null && mois == 7) { %>selected<% } %>>Juillet</option>
                                <option value="8" <% if (mois != null && mois == 8) { %>selected<% } %>>Août</option>
                                <option value="9" <% if (mois != null && mois == 9) { %>selected<% } %>>Septembre</option>
                                <option value="10" <% if (mois != null && mois == 10) { %>selected<% } %>>Octobre</option>
                                <option value="11" <% if (mois != null && mois == 11) { %>selected<% } %>>Novembre</option>
                                <option value="12" <% if (mois != null && mois == 12) { %>selected<% } %>>Décembre</option>
                            </select>
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-chart-bar me-2"></i>Appliquer le filtre
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Cartes de synthèse -->
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="card bg-light">
                <div class="card-body">
                    <h4 class="text-center mb-4">
                        <i class="fas fa-calendar-alt me-2"></i>Dashboard Publicité - <%= periodeAffichage %>
                    </h4>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card text-white bg-success">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title">Chiffre d'Affaires</h6>
                            <h2 class="card-text">
                                <%= chiffreAffaires != null ? currencyFormat.format(chiffreAffaires) : "0,00 €" %>
                            </h2>
                        </div>
                        <div class="display-4">
                            <i class="fas fa-euro-sign"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card text-white bg-info">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title">Nombre de Publicités</h6>
                            <h2 class="card-text">
                                <%= nombrePublicites != null ? nombrePublicites : "0" %>
                            </h2>
                        </div>
                        <div class="display-4">
                            <i class="fas fa-ad"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card text-white bg-warning">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title">Moyenne par Publicité</h6>
                            <h2 class="card-text">
                                <%= moyenneParPublicite != null ? currencyFormat.format(moyenneParPublicite) : "0,00 €" %>
                            </h2>
                        </div>
                        <div class="display-4">
                            <i class="fas fa-chart-line"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphique et tableau -->
    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-bar me-2"></i>Chiffre d'Affaires par Jour
                    </h5>
                </div>
                <div class="card-body">
                    <% if (chiffreAffairesParJour != null && !chiffreAffairesParJour.isEmpty()) { %>
                    <div style="height: 300px;">
                        <!-- Graphique simple avec des barres -->
                        <div class="d-flex align-items-end" style="height: 250px;">
                            <%
                                // Trouver la valeur maximale pour l'échelle
                                double maxValue = 0;
                                for (Double value : chiffreAffairesParJour.values()) {
                                    if (value > maxValue) {
                                        maxValue = value;
                                    }
                                }

                                for (Map.Entry<LocalDate, Double> entry : chiffreAffairesParJour.entrySet()) {
                                    LocalDate date = entry.getKey();
                                    Double value = entry.getValue();
                                    double percentage = maxValue > 0 ? (value / maxValue) * 100 : 0;
                            %>
                            <div class="d-flex flex-column align-items-center me-2" style="width: 3%;">
                                <div class="bg-primary mb-1"
                                     style="height: <%= percentage %>% ; width: 100%;"></div>
                                <small class="text-muted"><%= dayFormatter.format(date) %></small>
                            </div>
                            <% } %>
                        </div>
                        <div class="text-center mt-3">
                            <small class="text-muted">Jours du mois</small>
                        </div>
                    </div>
                    <% } else { %>
                    <div class="text-center py-5">
                        <p class="text-muted">Aucune donnée disponible pour cette période</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-building me-2"></i>CA par Société
                    </h5>
                </div>
                <div class="card-body" style="max-height: 350px; overflow-y: auto;">
                    <% if (chiffreAffairesParSociete != null && !chiffreAffairesParSociete.isEmpty()) { %>
                    <table class="table table-sm table-hover">
                        <thead>
                        <tr>
                            <th>Société</th>
                            <th class="text-end">CA</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Map.Entry<String, Double> entry : chiffreAffairesParSociete.entrySet()) { %>
                        <tr>
                            <td>
                                <small><%= entry.getKey() %></small>
                            </td>
                            <td class="text-end">
                                <strong><%= currencyFormat.format(entry.getValue()) %></strong>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <div class="text-center py-4">
                        <p class="text-muted">Aucune donnée disponible</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- Légende et informations -->
    <div class="row mt-4">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-light">
                    <h6 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>Informations
                    </h6>
                </div>
                <div class="card-body">
                    <p class="mb-0">
                        Ce dashboard présente les chiffres d'affaires générés par les publicités diffusées avant les séances de cinéma.
                        Les données sont filtrées par mois et année.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Styles CSS pour le dashboard -->
<style>
    .card {
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0,0,0,.1);
        margin-bottom: 20px;
    }
    .card-header {
        border-radius: 10px 10px 0 0 !important;
    }
    .display-4 {
        font-size: 3rem;
        opacity: 0.7;
    }
    .table-sm th, .table-sm td {
        padding: 0.5rem;
    }
    .bg-primary {
        background-color: #007bff !important;
    }
    .bg-success {
        background-color: #28a745 !important;
    }
    .bg-info {
        background-color: #17a2b8 !important;
    }
    .bg-warning {
        background-color: #ffc107 !important;
    }
</style>