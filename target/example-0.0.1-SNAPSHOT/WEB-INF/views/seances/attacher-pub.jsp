<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.cinema.example.models.Seance" %>
<%@ page import="com.cinema.example.models.Publicite" %>
<%@ page import="com.cinema.example.models.PubSeance" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
  Seance seance = (Seance) request.getAttribute("seance");
  List<Publicite> publicites = (List<Publicite>) request.getAttribute("publicites");
  List<PubSeance> pubSeancesExistantes = (List<PubSeance>) request.getAttribute("pubSeancesExistantes");
  String heureDiffusionDefaut = (String) request.getAttribute("heureDiffusionDefaut");

  NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.FRANCE);
  DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

  // Messages flash
  String successMsg = (String) request.getAttribute("success");
  String errorMsg = (String) request.getAttribute("error");
%>

<div class="container-fluid">
  <!-- Messages -->
  <% if (successMsg != null) { %>
  <div class="alert alert-success">
    <%= successMsg %>
  </div>
  <% } %>
  <% if (errorMsg != null) { %>
  <div class="alert alert-danger">
    <%= errorMsg %>
  </div>
  <% } %>

  <div class="row">
    <div class="col-md-6">
      <div class="card">
        <div class="card-header bg-primary text-white">
          <h5 class="mb-0">Attacher une publicité</h5>
        </div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/seances/<%= seance.getId() %>/attacher-pub/save">
            <div class="mb-3">
              <label class="form-label">Publicité</label>
              <select class="form-select" name="publiciteId" required>
                <option value="">-- Choisir --</option>
                <% for (Publicite pub : publicites) { %>
                <option value="<%= pub.getId() %>"
                        data-prix="<%= pub.getPrix() %>">
                  <%= pub.getNom() %> (<%= pub.getSociete().getNom() %>)
                </option>
                <% } %>
              </select>
            </div>

            <div class="row">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">Nombre</label>
                  <input type="number" class="form-control" name="nombre" value="1" min="1">
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">Prix unitaire</label>
                  <input type="number" class="form-control" name="prixUnitaire"
                         step="0.01" id="prixUnitaire" value="0">
                </div>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">Heure de diffusion</label>
              <input type="datetime-local" class="form-control"
                     name="heureDiffusion" value="<%= heureDiffusionDefaut %>">
            </div>

            <button type="submit" class="btn btn-success">Attacher</button>
          </form>
        </div>
      </div>
    </div>

    <div class="col-md-6">
      <div class="card">
        <div class="card-header bg-success text-white">
          <h5 class="mb-0">Publicités attachées</h5>
        </div>
        <div class="card-body">
          <% if (pubSeancesExistantes.isEmpty()) { %>
          <p class="text-muted">Aucune publicité attachée</p>
          <% } else { %>
          <table class="table table-sm">
            <thead>
            <tr>
              <th>Publicité</th>
              <th>Heure</th>
              <th>Nombre</th>
              <th>Prix</th>
              <th></th>
            </tr>
            </thead>
            <tbody>
            <% for (PubSeance ps : pubSeancesExistantes) { %>
            <tr>
              <td><%= ps.getPublicite().getNom() %></td>
              <td><%= ps.getHeureDiffusion().format(dateTimeFormatter) %></td>
              <td><%= ps.getNombre() %></td>
              <td><%= currencyFormat.format(ps.getPrixUnitaire()) %></td>
              <td>
                <form method="post"
                      action="${pageContext.request.contextPath}/seances/<%= seance.getId() %>/detacher-pub/<%= ps.getId() %>"
                      style="display: inline;">
                  <button type="submit" class="btn btn-sm btn-danger">
                    Détacher
                  </button>
                </form>
              </td>
            </tr>
            <% } %>
            </tbody>
          </table>
          <% } %>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const publiciteSelect = document.querySelector('select[name="publiciteId"]');
    const prixInput = document.getElementById('prixUnitaire');

    // Mettre à jour le prix automatiquement quand on sélectionne une pub
    publiciteSelect.addEventListener('change', function() {
      const selectedOption = this.options[this.selectedIndex];
      if (selectedOption.dataset.prix) {
        prixInput.value = selectedOption.dataset.prix;
      }
    });
  });
</script>