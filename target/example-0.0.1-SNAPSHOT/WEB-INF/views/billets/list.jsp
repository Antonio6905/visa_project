<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinema.example.models.Billet" %>
<%@ page import="com.cinema.example.models.Client" %>
<%@ page import="com.cinema.example.models.Seance" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    List<Billet> billets = (List<Billet>) request.getAttribute("billets");
    List<Client> clients = (List<Client>) request.getAttribute("clients");
    List<Seance> seances = (List<Seance>) request.getAttribute("seances");
    String seanceParam = request.getParameter("seance");
    String clientParam = request.getParameter("client");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-ticket"></i> Liste des Billets vendus</h2>
            <a href="${pageContext.request.contextPath}/billets/vendre" class="btn btn-success">
                <i class="bi bi-plus-circle"></i> Vendre un billet
            </a>
        </div>

        <!-- Filtres -->
        <div class="card mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/billets" method="get" class="row g-3">
                    <div class="col-md-4">
                        <label for="seance" class="form-label">Séance</label>
                        <select id="seance" name="seance" class="form-select">
                            <option value="">Toutes</option>
                            <% if (seances != null) {
                                for (Seance s : seances) {
                                    String sel = "";
                                    if (seanceParam != null && seanceParam.equals(String.valueOf(s.getId()))) sel = "selected";
                            %>
                            <option value="<%= s.getId() %>" <%= sel %>><%= s.getFilm() != null ? s.getFilm().getTitre() + " - " + s.getDateHeureDebut().format(dtf) : "Séance " + s.getId() %></option>
                            <% }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="client" class="form-label">Client</label>
                        <select id="client" name="client" class="form-select">
                            <option value="">Tous</option>
                            <% if (clients != null) {
                                for (Client c : clients) {
                                    String sel = "";
                                    if (clientParam != null && clientParam.equals(String.valueOf(c.getId()))) sel = "selected";
                            %>
                            <option value="<%= c.getId() %>" <%= sel %>><%= c.getNom() %></option>
                            <% }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary me-2"><i class="bi bi-search"></i> Filtrer</button>
                        <a href="${pageContext.request.contextPath}/billets" class="btn btn-secondary">Réinitialiser</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Liste -->
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Client</th>
                                <th>Film / Séance</th>
                                <th>Salle</th>
                                <th>Type siège</th>
                                <th>Numéro siège</th>
                                <th>Prix</th>
                                <th>Paiement</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (billets == null || billets.isEmpty()) { %>
                            <tr>
                                <td colspan="9" class="text-center p-4">Aucun billet trouvé.</td>
                            </tr>
                            <% } else {
                                for (Billet b : billets) {
                            %>
                            <tr>
                                <td><%= b.getId() %></td>
                                <td><%= b.getClient() != null ? b.getClient().getNom() : "Divers" %></td>
                                <td><%= b.getSeance() != null && b.getSeance().getFilm() != null ? b.getSeance().getFilm().getTitre() + "<br/>" + b.getSeance().getDateHeureDebut().format(dtf) : "-" %></td>
                                <td><%= b.getSeance() != null && b.getSeance().getSalle() != null ? b.getSeance().getSalle().getNom() : "-" %></td>
                                <td><%= b.getSiege() != null ? b.getSiege().getLibelle() : "-" %></td>
                                <td><%= b.getNumeroSiege() %></td>
                                <td><%= b.getPrix() != null ? String.format("%.2f €", b.getPrix()) : "-" %></td>
                                <td><%= b.getPaiement() != null ? (b.getPaiement().getModePaiement() != null ? b.getPaiement().getModePaiement().getLibelle() : "Payé") : "Non payé" %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/billets/<%= b.getId() %>" class="btn btn-sm btn-outline-primary">Détails</a>
                                    <form action="${pageContext.request.contextPath}/billets/<%= b.getId() %>/delete" method="post" style="display:inline-block;">
                                        <button type="submit" class="btn btn-sm btn-outline-danger btn-delete">Supprimer</button>
                                    </form>
                                </td>
                            </tr>
                            <% }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>
