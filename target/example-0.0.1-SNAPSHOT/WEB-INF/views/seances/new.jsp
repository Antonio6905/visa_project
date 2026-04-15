[file name]: new.jsp
[file content begin]
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cinema.example.models.Film" %>
<%@ page import="com.cinema.example.models.Salle" %>
<%@ page import="com.cinema.example.models.Langage" %>
<%@ page import="com.cinema.example.models.StatutSeance" %>
<%@ page import="com.cinema.example.models.Categorie" %>
<%@ page import="com.cinema.example.models.Siege" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    List<Film> films = (List<Film>) request.getAttribute("films");
    List<Salle> salles = (List<Salle>) request.getAttribute("salles");
    List<Langage> langages = (List<Langage>) request.getAttribute("langages");
    List<StatutSeance> statuts = (List<StatutSeance>) request.getAttribute("statuts");
    List<Categorie> categories = (List<Categorie>) request.getAttribute("categories");
    List<Siege> sieges = (List<Siege>) request.getAttribute("sieges");

    DateTimeFormatter htmlDateTime = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    String nowHtml = LocalDateTime.now().format(htmlDateTime);
%>

<div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-calendar-plus"></i> Créer une nouvelle séance</h2>
            <a href="${pageContext.request.contextPath}/seances" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Retour à la liste
            </a>
        </div>

        <div class="card">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/seances/save" id="seanceForm">
                    <div class="row g-3">
                        <!-- Film -->
                        <div class="col-md-6">
                            <label for="film" class="form-label">Film <span class="text-danger">*</span></label>
                            <select id="film" name="filmId" class="form-select" required>
                                <option value="">-- Sélectionner un film --</option>
                                <% if (films != null) {
                                    for (Film film : films) { %>
                                <option value="<%= film.getId() %>"><%= film.getTitre() %> (<%= film.getDuree() %> min)</option>
                                <% }
                                } %>
                            </select>
                            <div class="form-text">Sélectionnez le film à projeter</div>
                        </div>

                        <!-- Salle -->
                        <div class="col-md-6">
                            <label for="salle" class="form-label">Salle <span class="text-danger">*</span></label>
                            <select id="salle" name="salleId" class="form-select" required>
                                <option value="">-- Sélectionner une salle --</option>
                                <% if (salles != null) {
                                    for (Salle salle : salles) { %>
                                <option value="<%= salle.getId() %>" data-capacity="<%= salle.getCapacite() %>">
                                    <%= salle.getNom() %> (Capacité: <%= salle.getCapacite() %> places)
                                </option>
                                <% }
                                } %>
                            </select>
                            <div class="form-text">Sélectionnez la salle de projection</div>
                        </div>

                        <!-- Date et heure de début -->
                        <div class="col-md-6">
                            <label for="dateHeureDebut" class="form-label">Date et heure de début <span class="text-danger">*</span></label>
                            <input type="datetime-local" class="form-control" id="dateHeureDebut" name="dateHeureDebut"
                                   value="<%= nowHtml %>" min="<%= nowHtml %>" required>
                            <div class="form-text">La séance doit être programmée dans le futur</div>
                        </div>

                        <!-- Langage -->
                        <div class="col-md-6">
                            <label for="langage" class="form-label">Langage <span class="text-danger">*</span></label>
                            <select id="langage" name="langageId" class="form-select" required>
                                <option value="">-- Sélectionner un langage --</option>
                                <% if (langages != null) {
                                    for (Langage langage : langages) { %>
                                <option value="<%= langage.getId() %>"><%= langage.getLibelle() %></option>
                                <% }
                                } %>
                            </select>
                            <div class="form-text">Sélectionnez le langage de la séance</div>
                        </div>

                        <!-- Prix de base -->
                        <div class="col-md-6">
                            <label for="prixBase" class="form-label">Prix de base (Ar) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="prixBase" name="prixBase"
                                   step="0.01" min="0" value="9.90" required>
                            <div class="form-text">Tarif plein pour un adulte en siège standard</div>
                        </div>

                        <!-- Statut -->
                        <div class="col-md-6">
                            <label for="statut" class="form-label">Statut <span class="text-danger">*</span></label>
                            <select id="statut" name="statutId" class="form-select" required>
                                <option value="">-- Sélectionner un statut --</option>
                                <% if (statuts != null) {
                                    for (StatutSeance statut : statuts) { %>
                                <option value="<%= statut.getId() %>"
                                        <%= "Programmée".equals(statut.getLibelle()) ? "selected" : "" %>>
                                    <%= statut.getLibelle() %>
                                </option>
                                <% }
                                } %>
                            </select>
                            <div class="form-text">Statut initial de la séance</div>
                        </div>
                    </div>

                    <!-- Informations calculées -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="alert alert-info">
                                <h6><i class="bi bi-info-circle"></i> Informations calculées</h6>
                                <div class="row">
                                    <div class="col-md-4">
                                        <strong>Fin estimée :</strong> <span id="heureFin">--:--</span>
                                    </div>
                                    <div class="col-md-4">
                                        <strong>CA prévisionnel max :</strong> <span id="caPrevisionnel">0.00 Ar</span>
                                    </div>
                                    <div class="col-md-4">
                                        <strong>Date programmée :</strong> <span id="dateFormattee">--</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Section pour les prix spécifiques -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card border-primary">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="card-title mb-0">
                                        <i class="bi bi-tags"></i> Prix spécifiques par catégorie
                                        <span class="badge bg-light text-primary ms-2" id="prixCount">0</span>
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-warning mb-3">
                                        <i class="bi bi-exclamation-triangle"></i>
                                        Ajoutez des tarifs spécifiques pour différentes catégories de clients (étudiants, enfants, seniors, etc.) et types de sièges.
                                        Si aucun prix spécifique n'est défini, le prix de base sera appliqué.
                                    </div>

                                    <!-- Formulaire pour ajouter un prix spécifique -->
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <h6 class="card-subtitle mb-3 text-muted">Ajouter un prix spécifique</h6>
                                            <div class="row g-3 align-items-end">
                                                <div class="col-md-4">
                                                    <label for="categorieSelect" class="form-label">Catégorie client</label>
                                                    <select id="categorieSelect" class="form-select">
                                                        <option value="">-- Sélectionner une catégorie --</option>
                                                        <% if (categories != null) {
                                                            for (Categorie categorie : categories) { %>
                                                        <option value="<%= categorie.getId() %>"><%= categorie.getLibelle() %></option>
                                                        <% }
                                                        } %>
                                                    </select>
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="siegeSelect" class="form-label">Type de siège</label>
                                                    <select id="siegeSelect" class="form-select">
                                                        <option value="">-- Sélectionner un type --</option>
                                                        <% if (sieges != null) {
                                                            for (Siege siege : sieges) { %>
                                                        <option value="<%= siege.getId() %>"><%= siege.getLibelle() %></option>
                                                        <% }
                                                        } %>
                                                    </select>
                                                </div>
                                                <div class="col-md-3">
                                                    <label for="prixSpecifique" class="form-label">Remise (Ar)</label>
                                                    <input type="number" id="prixSpecifique" class="form-control"
                                                           step="0.01" min="0" placeholder="ex: 7.50">
                                                </div>
                                                <div class="col-md-1">
                                                    <button type="button" class="btn btn-success w-100" id="btnAddPrix">
                                                        <i class="bi bi-plus-lg"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Tableau des prix spécifiques -->
                                    <div class="table-responsive">
                                        <table class="table table-hover" id="tablePrixSpecifiques">
                                            <thead class="table-light">
                                            <tr>
                                                <th>Catégorie</th>
                                                <th>Type de siège</th>
                                                <th>Prix (Ar)</th>
                                                <th>Action</th>
                                            </tr>
                                            </thead>
                                            <tbody id="tbodyPrix">
                                            <!-- Les lignes seront ajoutées dynamiquement ici -->
                                            </tbody>
                                            <tfoot>
                                            <tr id="emptyRow" style="display: none;">
                                                <td colspan="4" class="text-center text-muted py-4">
                                                    <i class="bi bi-tags fs-1"></i>
                                                    <p class="mt-2 mb-0">Aucun prix spécifique défini</p>
                                                    <small>Utilisez le formulaire ci-dessus pour en ajouter</small>
                                                </td>
                                            </tr>
                                            </tfoot>
                                        </table>
                                    </div>

                                    <!-- Inputs cachés pour les prix spécifiques -->
                                    <div id="hiddenInputsContainer">
                                        <!-- Les inputs cachés seront ajoutés ici dynamiquement -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Boutons -->
                    <div class="row mt-4">
                        <div class="col-12 d-flex justify-content-end gap-2">
                            <button type="reset" class="btn btn-secondary">
                                <i class="bi bi-x-circle"></i> Annuler
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> Créer la séance avec les prix
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('seanceForm');
        const filmSelect = document.getElementById('film');
        const salleSelect = document.getElementById('salle');
        const dateHeureInput = document.getElementById('dateHeureDebut');
        const prixBaseInput = document.getElementById('prixBase');

        // Éléments pour les prix spécifiques
        const categorieSelect = document.getElementById('categorieSelect');
        const siegeSelect = document.getElementById('siegeSelect');
        const prixSpecifiqueInput = document.getElementById('prixSpecifique');
        const btnAddPrix = document.getElementById('btnAddPrix');
        const tbodyPrix = document.getElementById('tbodyPrix');
        const emptyRow = document.getElementById('emptyRow');
        const prixCountBadge = document.getElementById('prixCount');
        const hiddenInputsContainer = document.getElementById('hiddenInputsContainer');

        // Stocker les données des films (durée)
        const filmsData = {};
        <% if (films != null) {
            for (Film film : films) { %>
        filmsData[<%= film.getId() %>] = {
            duree: <%= film.getDuree() %>,
            titre: '<%= film.getTitre().replace("'", "\\'") %>'
        };
        <% }
        } %>

        // Stocker les données des salles (capacité)
        const sallesData = {};
        <% if (salles != null) {
            for (Salle salle : salles) { %>
        sallesData[<%= salle.getId() %>] = {
            capacite: <%= salle.getCapacite() %>,
            nom: '<%= salle.getNom().replace("'", "\\'") %>'
        };
        <% }
        } %>

        // Stocker les données des catégories
        const categoriesData = {};
        <% if (categories != null) {
            for (Categorie categorie : categories) { %>
        categoriesData[<%= categorie.getId() %>] = '<%= categorie.getLibelle().replace("'", "\\'") %>';
        <% }
        } %>

        // Stocker les données des sièges
        const siegesData = {};
        <% if (sieges != null) {
            for (Siege siege : sieges) { %>
        siegesData[<%= siege.getId() %>] = '<%= siege.getLibelle().replace("'", "\\'") %>';
        <% }
        } %>

        // Stocker les combinaisons déjà ajoutées
        const addedCombinations = new Set();

        // Éléments d'affichage des informations calculées
        const heureFinSpan = document.getElementById('heureFin');
        const caPrevisionnelSpan = document.getElementById('caPrevisionnel');
        const dateFormatteeSpan = document.getElementById('dateFormattee');

        // Fonction pour formater une date
        function formatDateTime(date) {
            return date.toLocaleDateString('fr-FR', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        // Fonction pour calculer l'heure de fin
        function calculerHeureFin(dateDebut, dureeMinutes) {
            if (!dateDebut || !dureeMinutes) return null;

            const dateFin = new Date(dateDebut.getTime() + (dureeMinutes * 60000));
            return dateFin.toLocaleTimeString('fr-FR', {
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        // Fonction pour calculer le CA prévisionnel
        function calculerCAPrevisionnel(prix, capacite) {
            if (!prix || !capacite) return 0;
            return (prix * capacite).toFixed(2);
        }

        // Fonction pour mettre à jour les informations calculées
        function updateCalculatedInfo() {
            const filmId = filmSelect.value;
            const salleId = salleSelect.value;
            const dateHeure = dateHeureInput.value;
            const prixBase = parseFloat(prixBaseInput.value) || 0;

            // Mettre à jour la date formatée
            if (dateHeure) {
                const date = new Date(dateHeure);
                dateFormatteeSpan.textContent = formatDateTime(date);
            } else {
                dateFormatteeSpan.textContent = '--';
            }

            // Mettre à jour l'heure de fin
            if (filmId && filmsData[filmId] && dateHeure) {
                const date = new Date(dateHeure);
                const duree = filmsData[filmId].duree;
                const heureFin = calculerHeureFin(date, duree);
                heureFinSpan.textContent = heureFin || '--:--';
            } else {
                heureFinSpan.textContent = '--:--';
            }

            // Mettre à jour le CA prévisionnel
            if (salleId && sallesData[salleId] && prixBase > 0) {
                const capacite = sallesData[salleId].capacite;
                const ca = calculerCAPrevisionnel(prixBase, capacite);
                caPrevisionnelSpan.textContent = ca + ' Ar';
            } else {
                caPrevisionnelSpan.textContent = '0.00 Ar';
            }
        }

        // Fonction pour ajouter une ligne de prix spécifique
        // Fonction pour ajouter une ligne de prix spécifique
        function addPrixSpecifique(categorieId, siegeId, prix) {
            const combinationKey = categorieId + '_' + siegeId;

            // Vérifier si la combinaison existe déjà
            if (addedCombinations.has(combinationKey)) {
                alert('Cette combinaison catégorie/siège existe déjà !');
                return false;
            }

            // Valider les données
            if (!categorieId || !siegeId || !prix || prix <= 0) {
                alert('Veuillez remplir tous les champs avec des valeurs valides');
                return false;
            }

            // Vérifier que le prix est inférieur au prix de base
            const prixBase = parseFloat(prixBaseInput.value) || 0;
            const prixNum = parseFloat(prix);
            if (prixNum >= prixBase) {
                if (!confirm('Le prix spécifique (' + prixNum.toFixed(2) + ' €) est supérieur ou égal au prix de base (' + prixBase.toFixed(2) + ' €). Voulez-vous continuer ?')) {
                    return false;
                }
            }

            // Ajouter la combinaison
            addedCombinations.add(combinationKey);

            // Récupérer les noms
            const categorieName = categoriesData[categorieId] || 'Inconnue';
            const siegeName = siegesData[siegeId] || 'Inconnu';

            // Créer la ligne de tableau
            const tr = document.createElement('tr');

            // Créer les cellules une par une
            const tdCategorie = document.createElement('td');
            tdCategorie.textContent = categorieName;

            const tdSiege = document.createElement('td');
            tdSiege.textContent = siegeName;

            const tdPrix = document.createElement('td');
            const strongPrix = document.createElement('strong');
            strongPrix.textContent = prixNum.toFixed(2) + ' Ar';
            tdPrix.appendChild(strongPrix);

            const tdAction = document.createElement('td');
            const btnRemove = document.createElement('button');
            btnRemove.type = 'button';
            btnRemove.className = 'btn btn-sm btn-danger btn-remove-prix';
            btnRemove.setAttribute('data-categorie', categorieId);
            btnRemove.setAttribute('data-siege', siegeId);

            const iconRemove = document.createElement('i');
            iconRemove.className = 'bi bi-trash';
            btnRemove.appendChild(iconRemove);

            // Ajouter l'événement de suppression
            btnRemove.addEventListener('click', function() {
                const categ = this.getAttribute('data-categorie');
                const sieg = this.getAttribute('data-siege');
                removePrixSpecifique(categ, sieg, tr);
            });

            tdAction.appendChild(btnRemove);

            // Assembler la ligne
            tr.appendChild(tdCategorie);
            tr.appendChild(tdSiege);
            tr.appendChild(tdPrix);
            tr.appendChild(tdAction);

            // Ajouter à la table
            tbodyPrix.appendChild(tr);

            // Créer les inputs cachés pour le formulaire
            const inputGroup = document.createElement('div');
            inputGroup.className = 'prix-input-group';

            const inputCategorie = document.createElement('input');
            inputCategorie.type = 'hidden';
            inputCategorie.name = 'prixCategorieIds';
            inputCategorie.value = categorieId;

            const inputSiege = document.createElement('input');
            inputSiege.type = 'hidden';
            inputSiege.name = 'prixSiegeIds';
            inputSiege.value = siegeId;

            const inputPrix = document.createElement('input');
            inputPrix.type = 'hidden';
            inputPrix.name = 'prixSpecifiques';
            inputPrix.value = prix;

            inputGroup.appendChild(inputCategorie);
            inputGroup.appendChild(inputSiege);
            inputGroup.appendChild(inputPrix);

            hiddenInputsContainer.appendChild(inputGroup);

            // Mettre à jour le compteur
            updatePrixCount();

            // Masquer le message vide s'il est affiché
            emptyRow.style.display = 'none';

            // Réinitialiser le formulaire d'ajout
            categorieSelect.value = '';
            siegeSelect.value = '';
            prixSpecifiqueInput.value = '';

            return true;
        }

        // Fonction pour supprimer une ligne de prix spécifique
        // Fonction pour supprimer une ligne de prix spécifique
        function removePrixSpecifique(categorieId, siegeId, rowElement) {
            const combinationKey = categorieId + '_' + siegeId;
            addedCombinations.delete(combinationKey);

            // Supprimer la ligne du tableau
            rowElement.remove();

            // Supprimer les inputs cachés correspondants
            const inputGroups = hiddenInputsContainer.querySelectorAll('.prix-input-group');
            inputGroups.forEach(function(group) {
                const catInput = group.querySelector('input[name="prixCategorieIds"]');
                const sieInput = group.querySelector('input[name="prixSiegeIds"]');
                if (catInput && catInput.value == categorieId &&
                    sieInput && sieInput.value == siegeId) {
                    group.remove();
                }
            });

            // Mettre à jour le compteur
            updatePrixCount();

            // Afficher le message vide si plus de prix
            if (addedCombinations.size === 0) {
                emptyRow.style.display = '';
            }
        }

        // Fonction pour mettre à jour le compteur de prix
        function updatePrixCount() {
            const count = addedCombinations.size;
            prixCountBadge.textContent = count;

            // Changer la couleur du badge selon le nombre
            if (count === 0) {
                prixCountBadge.className = 'badge bg-secondary ms-2';
            } else if (count < 3) {
                prixCountBadge.className = 'badge bg-warning text-dark ms-2';
            } else {
                prixCountBadge.className = 'badge bg-success ms-2';
            }
        }

        // Fonction pour valider les prix spécifiques
        function validatePrixSpecifiques() {
            const prixBase = parseFloat(prixBaseInput.value) || 0;
            let isValid = true;
            let warningMessage = '';

            // Vérifier chaque prix spécifique
            const prixInputs = hiddenInputsContainer.querySelectorAll('input[name="prixSpecifiques"]');
            prixInputs.forEach(input => {
                const prix = parseFloat(input.value);
                if (prix >= prixBase) {
                    warningMessage += `Un prix spécifique (${prix} Ar) est supérieur ou égal au prix de base (${prixBase} Ar).\n`;
                }
                if (prix <= 0) {
                    isValid = false;
                    alert('Tous les prix spécifiques doivent être supérieurs à 0.');
                }
            });

            // Afficher un avertissement si nécessaire
            if (warningMessage && !confirm(warningMessage + '\nVoulez-vous continuer ?')) {
                return false;
            }

            return isValid;
        }

        // Écouter les changements sur les inputs principaux
        filmSelect.addEventListener('change', updateCalculatedInfo);
        salleSelect.addEventListener('change', updateCalculatedInfo);
        dateHeureInput.addEventListener('change', updateCalculatedInfo);
        prixBaseInput.addEventListener('input', updateCalculatedInfo);

        // Gérer l'ajout de prix spécifique
        btnAddPrix.addEventListener('click', function() {
            const categorieId = categorieSelect.value;
            const siegeId = siegeSelect.value;
            const prix = prixSpecifiqueInput.value;

            console.log("MANDEHHHAAAAAAA VE PRIX");
            console.log(prix);
            console.log(categorieId);

            addPrixSpecifique(categorieId, siegeId, prix);
        });

        // Permettre l'ajout avec la touche Entrée
        prixSpecifiqueInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                btnAddPrix.click();
            }
        });

        // Validation personnalisée du formulaire
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            // Vérifier que la date est dans le futur
            const selectedDate = new Date(dateHeureInput.value);
            const now = new Date();

            if (selectedDate <= now) {
                alert('La date et heure doivent être dans le futur.');
                dateHeureInput.focus();
                return false;
            }

            // Vérifier que le prix est valide
            const prixBase = parseFloat(prixBaseInput.value);
            if (prixBase <= 0) {
                alert('Le prix de base doit être supérieur à 0.');
                prixBaseInput.focus();
                return false;
            }

            // Valider les prix spécifiques
            if (!validatePrixSpecifiques()) {
                return false;
            }

            // Afficher un récapitulatif
            let confirmMessage = `Voulez-vous créer cette séance ?\n\n`;
            confirmMessage += `Film: ${filmSelect.options[filmSelect.selectedIndex].text}\n`;
            confirmMessage += `Salle: ${salleSelect.options[salleSelect.selectedIndex].text}\n`;
            confirmMessage += `Date: ${selectedDate.toLocaleString('fr-FR')}\n`;
            confirmMessage += `Prix de base: ${prixBase.toFixed(2)} Ar\n`;
            confirmMessage += `Prix spécifiques: ${addedCombinations.size}\n\n`;

            if (!confirm(confirmMessage)) {
                return false;
            }

            // Si tout est valide, soumettre le formulaire
            this.submit();
        });

        // Initialiser les informations calculées
        updateCalculatedInfo();
        updatePrixCount();

        // Afficher le message vide initialement
        emptyRow.style.display = '';

        // Ajouter un effet de chargement lors de la soumission
        // form.addEventListener('submit', function() {
        //     const submitBtn = this.querySelector('button[type="submit"]');
        //     submitBtn.disabled = true;
        //     submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Création en cours...';
        // });
    });
</script>

<style>
    .card {
        border: none;
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
    }

    .card-header.bg-primary {
        background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
    }

    .form-label {
        font-weight: 500;
        margin-bottom: 0.5rem;
    }

    .form-control:focus, .form-select:focus {
        border-color: #86b7fe;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
    }

    .alert-info {
        background-color: #e7f1ff;
        border-color: #cfe2ff;
        color: #084298;
    }

    .alert-warning {
        background-color: #fff3cd;
        border-color: #ffeaa7;
        color: #664d03;
    }

    .btn-primary {
        background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
        border: none;
    }

    .btn-primary:hover {
        background: linear-gradient(135deg, #0b5ed7 0%, #0949a9 100%);
    }

    .btn-success {
        background: linear-gradient(135deg, #198754 0%, #146c43 100%);
        border: none;
    }

    .btn-success:hover {
        background: linear-gradient(135deg, #157347 0%, #115c39 100%);
    }

    .btn-danger {
        background: linear-gradient(135deg, #dc3545 0%, #b02a37 100%);
        border: none;
    }

    .btn-danger:hover {
        background: linear-gradient(135deg, #bb2d3b 0%, #8a2530 100%);
    }

    .table-hover tbody tr:hover {
        background-color: rgba(13, 110, 253, 0.05);
    }

    .table thead th {
        border-bottom: 2px solid #dee2e6;
        font-weight: 600;
    }

    #prixCount {
        font-size: 0.8rem;
        padding: 0.25rem 0.5rem;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .card-body {
            padding: 1rem;
        }

        .row.g-3 {
            margin-bottom: -0.5rem;
        }

        .col-md-6, .col-md-4, .col-md-3, .col-md-1 {
            margin-bottom: 1rem;
        }

        .table-responsive {
            font-size: 0.9rem;
        }
    }
</style>