<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinema.example.models.Seance" %>
<%@ page import="com.cinema.example.models.Film" %>
<%@ page import="com.cinema.example.models.Salle" %>
<%@ page import="com.cinema.example.models.StatutSeance" %>
<%@ page import="com.cinema.example.models.Client" %>
<%@ page import="com.cinema.example.models.Siege" %>
<%@ page import="com.cinema.example.models.ModePaiement" %>
<%@ page import="com.cinema.example.models.Categorie" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
	List<Seance> seances = (List<Seance>) request.getAttribute("seances");
	List<Film> films = (List<Film>) request.getAttribute("films");
	List<Salle> salles = (List<Salle>) request.getAttribute("salles");
	List<StatutSeance> statuts = (List<StatutSeance>) request.getAttribute("statuts");
	List<Client> clients = (List<Client>) request.getAttribute("clients");
	List<Siege> sieges = (List<Siege>) request.getAttribute("sieges");
	List<ModePaiement> modesPaiement = (List<ModePaiement>) request.getAttribute("modesPaiement");
	List<Categorie> categories = (List<Categorie>) request.getAttribute("categories");
	String filmParam = request.getParameter("film");
	String salleParam = request.getParameter("salle");
	String statutParam = request.getParameter("statut");
	DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
	DateTimeFormatter htmlDateTime = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
	String nowHtml = LocalDateTime.now().format(htmlDateTime);
%>

<div class="row">
	<div class="col-12">
		<% String successMsg = request.getParameter("success");
			String errorMsg = request.getParameter("error");
			if (successMsg != null) { %>
		<div class="alert alert-success">
			<%= java.net.URLDecoder.decode(successMsg, java.nio.charset.StandardCharsets.UTF_8) %>
		</div>
		<% } else if (errorMsg != null) { %>
		<div class="alert alert-danger">
			<%= java.net.URLDecoder.decode(errorMsg, java.nio.charset.StandardCharsets.UTF_8) %>
		</div>
		<% } %>
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2><i class="bi bi-calendar-event"></i> Séances programmées</h2>
			<a href="${pageContext.request.contextPath}/seances/new" class="btn btn-success">
				<i class="bi bi-plus-circle"></i> Nouvelle séance
			</a>
		</div>

		<!-- Filtres -->
		<div class="card mb-4">
			<div class="card-body">
				<form action="${pageContext.request.contextPath}/seances" method="get" class="row g-3">
					<div class="col-md-3">
						<label for="film" class="form-label">Film</label>
						<select class="form-select" id="film" name="film">
							<option value="">Tous les films</option>
							<% if (films != null) {
								for (Film f : films) {
									String selected = "";
									if (filmParam != null && filmParam.equals(String.valueOf(f.getId()))) {
										selected = "selected";
									}
							%>
							<option value="<%= f.getId() %>" <%= selected %>><%= f.getTitre() %></option>
							<% }
							} %>
						</select>
					</div>
					<div class="col-md-3">
						<label for="salle" class="form-label">Salle</label>
						<select class="form-select" id="salle" name="salle">
							<option value="">Toutes les salles</option>
							<% if (salles != null) {
								for (Salle s : salles) {
									String selected = "";
									if (salleParam != null && salleParam.equals(String.valueOf(s.getId()))) {
										selected = "selected";
									}
							%>
							<option value="<%= s.getId() %>" <%= selected %>><%= s.getNom() %></option>
							<% }
							} %>
						</select>
					</div>
					<div class="col-md-3">
						<label for="statut" class="form-label">Statut</label>
						<select class="form-select" id="statut" name="statut">
							<option value="">Tous</option>
							<% if (statuts != null) {
								for (StatutSeance st : statuts) {
									String selected = "";
									if (statutParam != null && statutParam.equals(String.valueOf(st.getId()))) {
										selected = "selected";
									}
							%>
							<option value="<%= st.getId() %>" <%= selected %>><%= st.getLibelle() %></option>
							<% }
							} %>
						</select>
					</div>
					<div class="col-md-3 d-flex align-items-end">
						<button type="submit" class="btn btn-primary me-2">
							<i class="bi bi-search"></i> Filtrer
						</button>
						<a href="${pageContext.request.contextPath}/seances" class="btn btn-secondary">
							<i class="bi bi-x-circle"></i> Réinitialiser
						</a>
					</div>
				</form>
			</div>
		</div>

		<!-- Liste des séances -->
		<% if (seances == null || seances.isEmpty()) { %>
		<div class="alert alert-info">
			<i class="bi bi-info-circle"></i> Aucune séance trouvée.
		</div>
		<% } else { %>
		<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
			<% for (Seance seance : seances) { %>
			<div class="col">
				<div class="card h-100 seance-card">
					<div class="card-header bg-primary text-white">
						<h5 class="card-title mb-0"><%= seance.getFilm() != null ? seance.getFilm().getTitre() : "–" %></h5>
					</div>
					<div class="card-header bg-primary text-white">
						<h5 class="card-title mb-0">CA previsionnel:<%= seance.getChiffrePrevisionnel()%></h5>
					</div>
					<div class="card-body">
						<p class="card-text">
							<strong><i class="bi bi-clock"></i> Début:</strong>
							<% if (seance.getDateHeureDebut() != null) { %>
							<%= seance.getDateHeureDebut().format(dateTimeFormatter) %>
							<% } else { %>
							Non spécifiée
							<% } %>
						</p>
						<p class="card-text">
							<strong><i class="bi bi-building"></i> Salle:</strong>
							<%= seance.getSalle() != null ? seance.getSalle().getNom() : "–" %>
						</p>
						<p class="card-text">
							<strong><i class="bi bi-translate"></i> Langage:</strong>
							<%= seance.getLangage() != null ? seance.getLangage().getLibelle() : "–" %>
						</p>
						<p class="card-text">
							<strong><i class="bi bi-currency-euro"></i> Prix:</strong>
							<%= seance.getPrixBase() != null ? String.format("%.2f €", seance.getPrixBase()) : "–" %>
						</p>
						<p class="card-text">
							<strong><i class="bi bi-info-circle"></i> Statut:</strong>
							<%= seance.getStatutSeance() != null ? seance.getStatutSeance().getLibelle() : "–" %>
						</p>
					</div>
					<div class="card-footer bg-transparent">
						<div class="d-flex justify-content-between">
							<div>
								<a href="${pageContext.request.contextPath}/seances/<%= seance.getId() %>"
								   class="btn btn-sm btn-outline-primary me-1">
									<i class="bi bi-eye"></i> Détails
								</a>
								<a href="${pageContext.request.contextPath}/seances/<%= seance.getId() %>/edit"
								   class="btn btn-sm btn-outline-secondary me-1">
									<i class="bi bi-pencil"></i> Modifier
								</a>
								<!-- Dans la section des boutons d'actions de la séance -->
								<a href="${pageContext.request.contextPath}/seances/<%= seance.getId() %>/attacher-pub"
								   class="btn btn-sm btn-outline-warning me-1">
									<i class="bi bi-megaphone"></i> Attacher Pub
								</a>
								<form action="${pageContext.request.contextPath}/seances/<%= seance.getId() %>/delete"
									  method="post" style="display: inline;">
									<button type="submit" class="btn btn-sm btn-outline-danger btn-delete">
										<i class="bi bi-trash"></i> Supprimer
									</button>
								</form>
							</div>

							<!-- Bouton Vendre billet -->
							<button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal"
									data-bs-target="#sellModal-<%= seance.getId() %>">
								<i class="bi bi-ticket"></i> Vendre billet
							</button>
						</div>
					</div>
				</div>
			</div>

			<!-- Modal vente de billet -->
			<div class="modal fade" id="sellModal-<%= seance.getId() %>" tabindex="-1" aria-labelledby="sellModalLabel-<%= seance.getId() %>" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="sellModalLabel-<%= seance.getId() %>">Vendre un billet - <%= seance.getFilm() != null ? seance.getFilm().getTitre() : "Séance" %></h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<form method="post" action="${pageContext.request.contextPath}/billets/vendre" id="form-<%= seance.getId() %>">
								<div class="mb-3">
									<label for="client-<%= seance.getId() %>" class="form-label">Client</label>
									<select id="client-<%= seance.getId() %>" name="clientId" class="form-select">
										<option value="">-- Sélectionner un client --</option>
										<% if (clients != null) {
											for (Client c : clients) {
										%>
										<option value="<%= c.getId() %>"><%= c.getNom() %></option>
										<% }
										} %>
									</select>
								</div>

								<input type="hidden" name="seanceId" value="<%= seance.getId() %>" />

								<div class="mb-3">
									<label for="date-<%= seance.getId() %>" class="form-label">Date/heure de vente</label>
									<input id="date-<%= seance.getId() %>" name="dateHeure" type="datetime-local" class="form-control" value="<%= nowHtml %>">
								</div>

								<div class="mb-3">
									<label for="siege-<%= seance.getId() %>" class="form-label">Type de siège</label>
									<select id="siege-<%= seance.getId() %>" name="siegeId" class="form-select siege-select">
										<option value="">-- Sélectionner un type de siège --</option>
										<% if (sieges != null) {
											for (Siege sg : sieges) {
										%>
										<option value="<%= sg.getId() %>"><%= sg.getLibelle() %></option>
										<% }
										} %>
									</select>
								</div>

								<div class="mb-3">
									<label for="numsiege-<%= seance.getId() %>" class="form-label">Numéro de siège</label>
									<input id="numsiege-<%= seance.getId() %>" name="numeroSiege" type="text" class="form-control" placeholder="ex: A1">
									<div class="form-text">Saisir le numéro ou choisir depuis l'interface .</div>
								</div>

								<div class="mb-3">
									<label for="prix-<%= seance.getId() %>" class="form-label">Prix (€)</label>
									<input id="prix-<%= seance.getId() %>"
										   name="prix"
										   type="number"
										   step="0.01"
										   class="form-control prix-input"
										   value="<%= seance.getPrixBase() != null ? String.format(java.util.Locale.US, "%.2f", seance.getPrixBase()) : "0.00" %>"
										   data-base-price="<%= seance.getPrixBase() != null ? seance.getPrixBase() : 0 %>"
										   required>
									<div class="form-text">
										Le prix sera ajusté automatiquement en fonction de la catégorie client et du type de siège.
									</div>
								</div>

								<div class="mb-3">
									<label for="mode-<%= seance.getId() %>" class="form-label">Mode de paiement</label>
									<select id="mode-<%= seance.getId() %>" name="modePaiementId" class="form-select">
										<option value="">-- Sélectionner un mode --</option>
										<% if (modesPaiement != null) {
											for (ModePaiement mp : modesPaiement) {
										%>
										<option value="<%= mp.getId() %>"><%= mp.getLibelle() %></option>
										<% }
										} %>
									</select>
								</div>

								<div class="mb-3">
									<label for="categorie-<%= seance.getId() %>" class="form-label">Type de client / Catégorie</label>
									<select id="categorie-<%= seance.getId() %>" name="categorieId" class="form-select categorie-select">
										<option value="">-- Aucun (Plein tarif) --</option>
										<% if (categories != null) {
											for (Categorie cat : categories) {
										%>
										<option value="<%= cat.getId() %>"><%= cat.getLibelle() %></option>
										<% }
										} %>
									</select>
									<div class="form-text">
										Sélectionnez une catégorie pour appliquer un tarif spécifique.
									</div>
								</div>

								<div class="mb-3">
									<label for="nombre-<%= seance.getId() %>" class="form-label">Nombre de billets</label>
									<input id="nombre-<%= seance.getId() %>" name="nombre" type="number" class="form-control" value="1" min="1">
								</div>

								<div class="modal-footer">
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
									<button type="submit" class="btn btn-primary">Vendre</button>
								</div>
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

<script>
	document.addEventListener('DOMContentLoaded', function() {
		// Fonction pour mettre à jour le prix dynamiquement
		function updatePrice(seanceId) {
			const modal = document.getElementById('sellModal-' + seanceId);
			if (!modal) return;

			const categorieSelect = modal.querySelector('select[name="categorieId"]');
			const siegeSelect = modal.querySelector('select[name="siegeId"]');
			const prixInput = modal.querySelector('input[name="prix"]');

			if (!categorieSelect || !prixInput) return;

			const categorieId = categorieSelect.value;
			const siegeId = siegeSelect ? siegeSelect.value : '';

			// Si aucune catégorie sélectionnée, utiliser le prix de base
			if (!categorieId) {
				const basePrice = parseFloat(prixInput.dataset.basePrice || '0');
				prixInput.value = basePrice.toFixed(2);
				return;
			}

			// Afficher un indicateur de chargement
			const originalValue = prixInput.value;
			prixInput.value = 'Chargement...';

			// Appel AJAX pour récupérer le prix spécifique
			fetch('${pageContext.request.contextPath}/api/prix', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
				},
				body: new URLSearchParams({
					'seanceId': seanceId,
					'categorieId': categorieId,
					'siegeId': siegeId
				})
			})
					.then(response => {
						if (!response.ok) {
							throw new Error('Erreur réseau: ' + response.status);
						}
						return response.json();
					})
					.then(data => {
						if (data.success && data.prix !== null) {
							// Formater le prix avec 2 décimales
							prixInput.value = parseFloat(data.prix).toFixed(2);

							// Ajouter un feedback visuel
							prixInput.classList.add('border-success');
							setTimeout(() => {
								prixInput.classList.remove('border-success');
							}, 1000);
						} else {
							// Fallback au prix de base
							const basePrice = parseFloat(prixInput.dataset.basePrice || '0');
							prixInput.value = basePrice.toFixed(2);
							console.warn('Aucun prix spécifique trouvé, utilisation du prix de base');
						}
					})
					.catch(error => {
						console.error('Erreur lors de la récupération du prix:', error);
						const basePrice = parseFloat(prixInput.dataset.basePrice || '0');
						prixInput.value = basePrice.toFixed(2);
						prixInput.classList.add('border-danger');
						setTimeout(() => {
							prixInput.classList.remove('border-danger');
						}, 2000);
					});
		}

		// Initialiser tous les modals
		document.querySelectorAll('[data-bs-target^="#sellModal-"]').forEach(button => {
			const target = button.getAttribute('data-bs-target');
			const seanceId = target.replace('#sellModal-', '');

			const modal = document.getElementById('sellModal-' + seanceId);
			if (modal) {
				// Quand le modal s'ouvre
				modal.addEventListener('show.bs.modal', function() {
					// Initialiser le prix de base
					const prixInput = this.querySelector('input[name="prix"]');
					if (prixInput && !prixInput.dataset.basePrice) {
						const baseValue = prixInput.value || '0';
						prixInput.dataset.basePrice = baseValue;
					}

					// Ajouter les événements aux selects
					const categorieSelect = this.querySelector('select[name="categorieId"]');
					const siegeSelect = this.querySelector('select[name="siegeId"]');

					if (categorieSelect) {
						categorieSelect.addEventListener('change', function() {
							updatePrice(seanceId);
						});
					}

					if (siegeSelect) {
						siegeSelect.addEventListener('change', function() {
							updatePrice(seanceId);
						});
					}

					// Mettre à jour le prix initial
					updatePrice(seanceId);
				});

				// Réinitialiser quand le modal se ferme
				modal.addEventListener('hidden.bs.modal', function() {
					const prixInput = this.querySelector('input[name="prix"]');
					if (prixInput && prixInput.dataset.basePrice) {
						prixInput.value = parseFloat(prixInput.dataset.basePrice).toFixed(2);
					}

					// Réinitialiser les sélecteurs
					const categorieSelect = this.querySelector('select[name="categorieId"]');
					if (categorieSelect) {
						categorieSelect.value = '';
					}

					const siegeSelect = this.querySelector('select[name="siegeId"]');
					if (siegeSelect) {
						siegeSelect.value = '';
					}

					// Retirer les classes de style
					prixInput.classList.remove('border-success', 'border-danger');
				});
			}
		});

		// Gérer la soumission du formulaire
		document.querySelectorAll('form[id^="form-"]').forEach(form => {
			form.addEventListener('submit', function(e) {
				const prixInput = this.querySelector('input[name="prix"]');
				if (prixInput && prixInput.value === 'Chargement...') {
					e.preventDefault();
					alert('Veuillez attendre que le prix soit chargé avant de soumettre.');
					return false;
				}

				// Validation supplémentaire
				const categorieSelect = this.querySelector('select[name="categorieId"]');
				const siegeSelect = this.querySelector('select[name="siegeId"]');

				if (categorieSelect && categorieSelect.value) {
					// Si une catégorie est sélectionnée, vérifier que le prix n'est pas le prix de base
					const basePrice = parseFloat(prixInput.dataset.basePrice || '0');
					const currentPrice = parseFloat(prixInput.value || '0');

					if (Math.abs(currentPrice - basePrice) < 0.01) {
						// Le prix est identique au prix de base
						if (!confirm('Vous avez sélectionné une catégorie mais le prix reste le prix de base. Continuer ?')) {
							e.preventDefault();
							return false;
						}
					}
				}

				return true;
			});
		});
	});
</script>

<style>
	.prix-input:read-only {
		background-color: #f8f9fa;
		cursor: not-allowed;
	}

	.prix-input.border-success {
		border-color: #198754 !important;
		box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25);
	}

	.prix-input.border-danger {
		border-color: #dc3545 !important;
		box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
	}

	.seance-card {
		transition: transform 0.2s;
	}

	.seance-card:hover {
		transform: translateY(-5px);
		box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
	}
</style>