<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinema.example.models.Film" %>
<%@ page import="com.cinema.example.models.Genre" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    List<Film> films = (List<Film>) request.getAttribute("films");
    List<Genre> genres = (List<Genre>) request.getAttribute("genres");
    String searchParam = request.getParameter("search");
    String genreParam = request.getParameter("genre");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>

<div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-film"></i> Liste des Films</h2>
            <a href="${pageContext.request.contextPath}/films/new" class="btn btn-success">
                <i class="bi bi-plus-circle"></i> Nouveau Film
            </a>
        </div>

        <!-- Filtres -->
        <div class="card mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/films" method="get" class="row g-3">
                    <div class="col-md-4">
                        <label for="search" class="form-label">Rechercher</label>
                        <input type="text" class="form-control" id="search" name="search"
                               value="<%= searchParam != null ? searchParam : "" %>"
                               placeholder="Titre du film...">
                    </div>
                    <div class="col-md-4">
                        <label for="genre" class="form-label">Genre</label>
                        <select class="form-select" id="genre" name="genre">
                            <option value="">Tous les genres</option>
                            <% if (genres != null) {
                                for (Genre genre : genres) {
                                    String selected = "";
                                    if (genreParam != null && genreParam.equals(String.valueOf(genre.getId()))) {
                                        selected = "selected";
                                    }
                            %>
                            <option value="<%= genre.getId() %>" <%= selected %>>
                                <%= genre.getLibelle() %>
                            </option>
                            <% }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="bi bi-search"></i> Filtrer
                        </button>
                        <a href="${pageContext.request.contextPath}/films" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> Réinitialiser
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Liste des films -->
        <% if (films == null || films.isEmpty()) { %>
        <div class="alert alert-info">
            <i class="bi bi-info-circle"></i> Aucun film trouvé.
        </div>
        <% } else { %>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <% for (Film film : films) { %>
            <div class="col">
                <div class="card h-100 cinema-card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0"><%= film.getTitre() %></h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">
                            <strong><i class="bi bi-calendar"></i> Sortie:</strong>
                            <% if (film.getDateSortie() != null) { %>
                            <%= film.getDateSortie().format(dateFormatter) %>
                            <% } else { %>
                            Non spécifiée
                            <% } %>
                        </p>
                        <p class="card-text">
                            <strong><i class="bi bi-clock"></i> Durée:</strong>
                            <%= film.getDuree() != null ? film.getDuree() + " minutes" : "Non spécifiée" %>
                        </p>
                        <p class="card-text">
                            <strong><i class="bi bi-tags"></i> Genres:</strong>
                            <% if (film.getGenres() != null && !film.getGenres().isEmpty()) {
                                int count = 0;
                                for (Genre genre : film.getGenres()) {
                                    if (count > 0) out.print(", ");
                            %>
                            <span class="badge bg-secondary"><%= genre.getLibelle() %></span>
                            <%
                                    count++;
                                }
                            } else { %>
                            <span class="text-muted">Aucun genre</span>
                            <% } %>
                        </p>
                    </div>
                    <div class="card-footer bg-transparent">
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/films/<%= film.getId() %>"
                               class="btn btn-sm btn-outline-primary">
                                <i class="bi bi-eye"></i> Détails
                            </a>
                            <a href="${pageContext.request.contextPath}/films/<%= film.getId() %>/edit"
                               class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-pencil"></i> Modifier
                            </a>
                            <form action="${pageContext.request.contextPath}/films/<%= film.getId() %>/delete"
                                  method="post" style="display: inline;">
                                <button type="submit" class="btn btn-sm btn-outline-danger btn-delete">
                                    <i class="bi bi-trash"></i> Supprimer
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</div>