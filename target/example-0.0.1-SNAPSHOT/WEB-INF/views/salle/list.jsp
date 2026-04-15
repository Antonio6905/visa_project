<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinema.example.models.Salle" %>
<%@ page import="com.cinema.example.models.SalleSiege" %>

<%
    List<Salle> salles = (List<Salle>) request.getAttribute("salles");
    String searchParam = (String) request.getAttribute("search");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer pageSize = (Integer) request.getAttribute("pageSize");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalItems = (Integer) request.getAttribute("totalItems");

    if (searchParam == null) searchParam = "";
%>

<div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-building"></i> Liste des Salles</h2>
            <a href="${pageContext.request.contextPath}/salles/new" class="btn btn-success">
                <i class="bi bi-plus-circle"></i> Nouvelle Salle
            </a>
        </div>

        <!-- Filtres -->
        <div class="card mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/salles" method="get" class="row g-3">
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="size" value="<%= pageSize %>">

                    <div class="col-md-6">
                        <label for="search" class="form-label">Rechercher</label>
                        <input type="text" class="form-control" id="search" name="search"
                               value="<%= searchParam %>"
                               placeholder="Nom de la salle...">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="bi bi-search"></i> Filtrer
                        </button>
                        <a href="${pageContext.request.contextPath}/salles" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> Réinitialiser
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Liste des salles -->
        <% if (salles == null || salles.isEmpty()) { %>
        <div class="alert alert-info">
            <i class="bi bi-info-circle"></i> Aucune salle trouvée.
        </div>
        <% } else { %>

        <!-- Statistiques -->
        <div class="alert alert-light border mb-4">
            <div class="row">
                <div class="col-md-4">
                    <strong><i class="bi bi-collection"></i> Total:</strong>
                    <span class="badge bg-info"><%= totalItems %> salles</span>
                </div>
                <div class="col-md-4">
                    <strong><i class="bi bi-file-text"></i> Page:</strong>
                    <span class="badge bg-secondary"><%= currentPage %>/<%= totalPages %></span>
                </div>
                <div class="col-md-4">
                    <strong><i class="bi bi-eye"></i> Affichage:</strong>
                    <span class="badge bg-success"><%= Math.min(pageSize, totalItems - (currentPage-1)*pageSize) %> salles</span>
                </div>
            </div>
        </div>

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <% for (Salle salle : salles) { %>
            <div class="col">
                <div class="card h-100">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-building"></i> <%= salle.getNom() %>
                        </h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">
                            <strong><i class="bi bi-people"></i> Capacité:</strong>
                            <%= salle.getCapacite() %> places
                        </p>
                        <p class="card-text">
                            <strong><i class="bi bi-ticket"></i> Types de sièges:</strong>
                            <%
                                if (salle.getSalleSieges() != null && !salle.getSalleSieges().isEmpty()) {
                                    int count = 0;
                                    for (SalleSiege salleSiege : salle.getSalleSieges()) {
                                        if (count > 0) out.print(", ");
                            %>
                            <span class="badge bg-secondary">
                                <%= salleSiege.getSiege().getLibelle() %> (x<%= salleSiege.getNombre() %>)
                            </span>
                            <%
                                    count++;
                                }
                            } else {
                            %>
                            <span class="text-muted">Aucun siège configuré</span>
                            <% } %>
                        </p>
                        <p class="card-text">
                            <strong><i class="bi bi-cash-stack"></i> Valeur totale:</strong>
                            <span class="badge bg-success">
                                <%= String.format("%.2f", salle.prixSiegeTotal()) %> €
                            </span>
                        </p>
                        <p class="card-text">
                            <strong><i class="bi bi-calendar-event"></i> Séances programmées:</strong>
                            <%= salle.getSeances() != null ? salle.getSeances().size() : 0 %>
                        </p>
                    </div>
                    <div class="card-footer bg-transparent">
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/salles/<%= salle.getId() %>"
                               class="btn btn-sm btn-outline-primary">
                                <i class="bi bi-eye"></i> Détails
                            </a>
                            <a href="${pageContext.request.contextPath}/salles/<%= salle.getId() %>/edit"
                               class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-pencil"></i> Modifier
                            </a>
                            <form action="${pageContext.request.contextPath}/salles/<%= salle.getId() %>/delete"
                                  method="post" style="display: inline;"
                                  onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette salle ?');">
                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                    <i class="bi bi-trash"></i> Supprimer
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Pagination -->
        <% if (totalPages > 1) { %>
        <nav aria-label="Pagination des salles" class="mt-4">
            <ul class="pagination justify-content-center">
                <!-- Premier et Précédent -->
                <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                    <a class="page-link" href="?page=1&size=<%= pageSize %>&search=<%= searchParam %>" aria-label="Premier">
                        <i class="bi bi-chevron-double-left"></i>
                    </a>
                </li>
                <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                    <a class="page-link" href="?page=<%= currentPage-1 %>&size=<%= pageSize %>&search=<%= searchParam %>" aria-label="Précédent">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>

                <!-- Pages numérotées -->
                <%
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);

                    // Ajuster pour avoir toujours 5 pages affichées si possible
                    if (endPage - startPage < 4) {
                        if (startPage == 1) {
                            endPage = Math.min(totalPages, startPage + 4);
                        } else if (endPage == totalPages) {
                            startPage = Math.max(1, endPage - 4);
                        }
                    }

                    for (int i = startPage; i <= endPage; i++) {
                %>
                <li class="page-item <%= i == currentPage ? "active" : "" %>">
                    <a class="page-link" href="?page=<%= i %>&size=<%= pageSize %>&search=<%= searchParam %>">
                        <%= i %>
                    </a>
                </li>
                <% } %>

                <!-- Suivant et Dernier -->
                <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                    <a class="page-link" href="?page=<%= currentPage+1 %>&size=<%= pageSize %>&search=<%= searchParam %>" aria-label="Suivant">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
                <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                    <a class="page-link" href="?page=<%= totalPages %>&size=<%= pageSize %>&search=<%= searchParam %>" aria-label="Dernier">
                        <i class="bi bi-chevron-double-right"></i>
                    </a>
                </li>
            </ul>
            <div class="text-center text-muted mt-2">
                Affichage de <strong><%= Math.min(pageSize, totalItems - (currentPage-1)*pageSize) %></strong>
                sur <strong><%= totalItems %></strong> salles
            </div>
        </nav>
        <% } %>

        <% } %>
    </div>
</div>

<style>
    .pagination .page-item.active .page-link {
        background-color: #0d6efd;
        border-color: #0d6efd;
    }
    .pagination .page-link {
        color: #0d6efd;
    }
    .pagination .page-link:hover {
        background-color: #e9ecef;
    }
</style>