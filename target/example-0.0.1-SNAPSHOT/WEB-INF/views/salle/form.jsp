<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cinema.example.models.Siege" %>
<%@ page import="java.util.List" %>

<%
  List<Siege> sieges = (List<Siege>) request.getAttribute("sieges");
%>

<div class="row">
  <div class="col-12 col-lg-8 mx-auto">
    <div class="card">
      <div class="card-header bg-primary text-white">
        <h4 class="mb-0">
          <i class="bi bi-building"></i> Nouvelle Salle
        </h4>
      </div>
      <div class="card-body">
        <form action="${pageContext.request.contextPath}/salles" method="post" id="salleForm">

          <div class="mb-3">
            <label for="nom" class="form-label">
              <i class="bi bi-fonts"></i> Nom de la salle *
            </label>
            <input type="text" class="form-control" id="nom" name="nom"
                   placeholder="Ex: Salle 1, Salle VIP, etc." required>
            <div class="form-text">Nom unique pour identifier la salle</div>
          </div>

          <!-- Section configuration des sièges -->
          <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h5 class="mb-0">
                <i class="bi bi-ticket"></i> Configuration des sièges
              </h5>
              <button type="button" class="btn btn-sm btn-outline-primary"
                      id="addSiegeBtn">
                <i class="bi bi-plus-circle"></i> Ajouter un type de siège
              </button>
            </div>

            <div class="card border-0 bg-light">
              <div class="card-body">
                <div id="siegesContainer">
                  <!-- Les lignes de sièges seront ajoutées ici dynamiquement -->
                  <div class="text-muted text-center py-3" id="noSiegesMessage">
                    <i class="bi bi-info-circle"></i>
                    Aucun siège configuré. Cliquez sur "Ajouter un type de siège" pour commencer.
                  </div>
                </div>

                <div class="row mt-3">
                  <div class="col-md-6">
                    <div class="alert alert-info">
                      <div class="d-flex align-items-center">
                        <i class="bi bi-calculator fs-4 me-3"></i>
                        <div>
                          <strong>Capacité totale calculée:</strong>
                          <div class="fs-4 fw-bold" id="capaciteTotale">0</div>
                          <small class="text-muted">(Calcul automatique)</small>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="alert alert-success">
                      <div class="d-flex align-items-center">
                        <i class="bi bi-cash-stack fs-4 me-3"></i>
                        <div>
                          <strong>Valeur totale des sièges:</strong>
                          <div class="fs-4 fw-bold" id="valeurTotale">0.00 €</div>
                          <small class="text-muted">Prix × quantité</small>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Champs cachés pour soumettre les données -->
          <input type="hidden" id="capacite" name="capacite" value="0">
          <input type="hidden" id="siegesData" name="siegesData" value="[]">

          <div class="d-flex justify-content-between mt-4">
            <a href="${pageContext.request.contextPath}/salles" class="btn btn-secondary">
              <i class="bi bi-arrow-left"></i> Retour
            </a>
            <button type="submit" class="btn btn-primary">
              <i class="bi bi-check-circle"></i> Créer la salle
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- Template pour une ligne de siège (caché) -->
<template id="siegeTemplate">
  <div class="siege-row row g-3 align-items-center mb-3 p-3 border rounded bg-white">
    <div class="col-md-4">
      <label class="form-label">Type de siège *</label>
      <select class="form-select siege-type" required>
        <option value="">Sélectionner un type...</option>
        <% if (sieges != null) {
          for (Siege siege : sieges) { %>
        <option value="<%= siege.getId() %>"
                data-prix="<%=  0 %>"
                data-libelle="<%= siege.getLibelle() %>"
                data-prix-siege="<%=  0 %>">
          <%= siege.getLibelle() %> - <%= "0.00" %> €
        </option>
        <% }
        } %>
      </select>
    </div>
    <div class="col-md-3">
      <label class="form-label">Quantité *</label>
      <input type="number" class="form-control siege-quantity"
             min="1" value="1" required>
    </div>
    <div class="col-md-3">
      <label class="form-label">Prix unitaire</label>
      <div class="input-group">
        <input type="number" class="form-control siege-prix"
               min="0" step="0.01" value="0" required>
        <span class="input-group-text">€</span>
      </div>
      <small class="form-text text-muted">Prix par siège pour cette salle</small>
    </div>
    <div class="col-md-2 d-flex align-items-end">
      <button type="button" class="btn btn-sm btn-outline-danger remove-siege">
        <i class="bi bi-trash"></i>
      </button>
    </div>
  </div>
</template>

<style>
  .siege-row {
    transition: all 0.3s ease;
    animation: fadeIn 0.3s ease;
  }
  .siege-row:hover {
    background-color: #f8f9fa;
  }
  #noSiegesMessage {
    min-height: 100px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
  }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const siegesContainer = document.getElementById('siegesContainer');
    const noSiegesMessage = document.getElementById('noSiegesMessage');
    const addSiegeBtn = document.getElementById('addSiegeBtn');
    const capaciteInput = document.getElementById('capacite');
    const capaciteTotaleSpan = document.getElementById('capaciteTotale');
    const valeurTotaleSpan = document.getElementById('valeurTotale');
    const siegesDataInput = document.getElementById('siegesData');
    const form = document.getElementById('salleForm');
    const template = document.getElementById('siegeTemplate');

    let siegeRows = [];

    // Ajouter un siège par défaut
    addSiegeRow();
    updateTotals();

    addSiegeBtn.addEventListener('click', function() {
      addSiegeRow();
      updateTotals();
    });

    function addSiegeRow() {
      noSiegesMessage.style.display = 'none';

      const clone = template.content.cloneNode(true);
      const row = clone.querySelector('.siege-row');

      // Événements pour cette ligne
      row.querySelector('.remove-siege').addEventListener('click', function() {
        row.remove();
        siegeRows = siegeRows.filter(r => r !== row);
        if (siegeRows.length === 0) {
          noSiegesMessage.style.display = 'flex';
        }
        updateTotals();
      });

      // Quand le type de siège change, mettre à jour le prix par défaut
      row.querySelector('.siege-type').addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];
        if (selectedOption && selectedOption.value) {
          const defaultPrix = parseFloat(selectedOption.getAttribute('data-prix-siege')) || 0;
          row.querySelector('.siege-prix').value = defaultPrix.toFixed(2);
        }
        updateTotals();
      });

      // Écouter les changements de quantité et de prix
      row.querySelector('.siege-quantity').addEventListener('input', updateTotals);
      row.querySelector('.siege-prix').addEventListener('input', updateTotals);

      siegesContainer.appendChild(row);
      siegeRows.push(row);

      // Focus sur le select du nouveau siège
      setTimeout(() => {
        row.querySelector('.siege-type').focus();
      }, 100);
    }

    function updateTotals() {
      let totalCapacite = 0;
      let totalValeur = 0;
      const siegesData = [];

      siegeRows.forEach((row, index) => {
        const select = row.querySelector('.siege-type');
        const quantityInput = row.querySelector('.siege-quantity');
        const prixInput = row.querySelector('.siege-prix');

        const siegeId = select.value;
        const quantity = parseInt(quantityInput.value) || 0;
        const prix = parseFloat(prixInput.value) || 0;

        if (siegeId && quantity > 0) {
          totalCapacite += quantity;
          totalValeur += prix * quantity;

          siegesData.push({
            siegeId: siegeId,
            quantity: quantity,
            prixSiege: prix
          });
        }
      });

      capaciteInput.value = totalCapacite;
      capaciteTotaleSpan.textContent = totalCapacite;
      valeurTotaleSpan.textContent = totalValeur.toFixed(2) + ' €';
      siegesDataInput.value = JSON.stringify(siegesData);
    }

    // Validation du formulaire
    form.addEventListener('submit', function(e) {
      e.preventDefault();

      const nom = document.getElementById('nom').value.trim();
      if (!nom) {
        alert('Veuillez saisir un nom pour la salle');
        document.getElementById('nom').focus();
        return;
      }

      // Vérifier si au moins un siège est configuré
      if (siegeRows.length === 0) {
        alert('Veuillez ajouter au moins un type de siège');
        addSiegeBtn.focus();
        return;
      }

      // Vérifier que tous les sièges sont correctement configurés
      let hasError = false;
      siegeRows.forEach((row, index) => {
        const select = row.querySelector('.siege-type');
        const quantityInput = row.querySelector('.siege-quantity');
        const prixInput = row.querySelector('.siege-prix');

        if (!select.value) {
          alert(`Veuillez sélectionner un type de siège pour la ligne ${index + 1}`);
          select.focus();
          hasError = true;
          return;
        }

        if (!quantityInput.value || parseInt(quantityInput.value) <= 0) {
          alert(`Veuillez saisir une quantité valide (≥ 1) pour la ligne ${index + 1}`);
          quantityInput.focus();
          hasError = true;
          return;
        }

        if (!prixInput.value || parseFloat(prixInput.value) < 0) {
          alert(`Veuillez saisir un prix valide (≥ 0) pour la ligne ${index + 1}`);
          prixInput.focus();
          hasError = true;
          return;
        }
      });

      if (hasError) return;

      if (parseInt(capaciteInput.value) === 0) {
        if (!confirm('La capacité totale est de 0. Voulez-vous vraiment créer une salle vide ?')) {
          return;
        }
      }

      // Afficher un message de confirmation
      if (confirm(`Créer la salle "${nom}" avec une capacité de ${capaciteInput.value} places ?`)) {
        // Soumettre le formulaire
        this.submit();
      }
    });
  });
</script>