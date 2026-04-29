<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.visa.example.dto.DuplicataTransfertAvecAnterieurForm" %>
<%@ page import="com.visa.example.dto.DuplicataTransfertSansAnterieurForm" %>
<%@ page import="com.visa.example.entity.Nationalite" %>
<%@ page import="com.visa.example.entity.PieceJustificative" %>
<%@ page import="com.visa.example.entity.SituationFamiliale" %>
<%@ page import="com.visa.example.entity.TypeVisa" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>

<%
    String typeDemandeCode  = (String)  request.getAttribute("typeDemandeCode");
    String typeDemandeLabel = (String)  request.getAttribute("typeDemandeLabel");
    if (typeDemandeCode  == null) typeDemandeCode  = "DUP";
    if (typeDemandeLabel == null) typeDemandeLabel = "Duplicata";

    DuplicataTransfertAvecAnterieurForm avecForm =
            (DuplicataTransfertAvecAnterieurForm) request.getAttribute("avecAnterieurForm");
    if (avecForm == null) {
        avecForm = new DuplicataTransfertAvecAnterieurForm();
        avecForm.setTypeDemande(typeDemandeCode);
    }

    DuplicataTransfertSansAnterieurForm sansForm =
            (DuplicataTransfertSansAnterieurForm) request.getAttribute("sansAnterieurForm");
    if (sansForm == null) {
        sansForm = new DuplicataTransfertSansAnterieurForm();
        sansForm.setTypeDemande(typeDemandeCode);
    }

    List<TypeVisa> typeVisas = (List<TypeVisa>) request.getAttribute("typeVisas");
    if (typeVisas == null) typeVisas = Collections.emptyList();

    List<Nationalite> nationalites = (List<Nationalite>) request.getAttribute("nationalites");
    if (nationalites == null) nationalites = Collections.emptyList();

    List<SituationFamiliale> situationsFamiliales =
            (List<SituationFamiliale>) request.getAttribute("situationsFamiliales");
    if (situationsFamiliales == null) situationsFamiliales = Collections.emptyList();

    List<PieceJustificative> piecesCommunes =
            (List<PieceJustificative>) request.getAttribute("piecesCommunes");
    if (piecesCommunes == null) piecesCommunes = Collections.emptyList();

    List<PieceJustificative> piecesSpecifiques =
            (List<PieceJustificative>) request.getAttribute("piecesSpecifiques");
    if (piecesSpecifiques == null) piecesSpecifiques = Collections.emptyList();

    Set<Long> selectedPieceIds = new HashSet<>();
    if (sansForm.getPieceIds() != null) selectedPieceIds.addAll(sansForm.getPieceIds());

    String ctxPath = request.getContextPath();
%>

<div class="card shadow-sm border-0">
    <div class="card-header bg-warning text-dark">
        <h4 class="mb-0">
            <i class="bi bi-files me-2"></i>Formulaire de Demande — <%= typeDemandeLabel %>
        </h4>
    </div>
    <div class="card-body">

        <%-- ══════════════════════════════════════════════ --%>
        <%-- ÉTAPE 1 : Choix "avec / sans données antérieures" --%>
        <%-- ══════════════════════════════════════════════ --%>
        <div class="mb-4">
            <p class="fw-semibold mb-2">Le demandeur possède-t-il des données antérieures ?</p>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="modeAnterieur"
                       id="radioAvec" value="avec" checked>
                <label class="form-check-label" for="radioAvec">
                    <i class="bi bi-search me-1"></i>Oui — recherche par numéro de carte résident
                </label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="modeAnterieur"
                       id="radioSans" value="sans">
                <label class="form-check-label" for="radioSans">
                    <i class="bi bi-pencil-square me-1"></i>Non — remplir le formulaire complet
                </label>
            </div>
        </div>

        <%-- ══════════════════════════════════════════════ --%>
        <%-- SECTION A : AVEC données antérieures           --%>
        <%-- ══════════════════════════════════════════════ --%>
        <div id="sectionAvec">
            <div class="alert alert-info">
                <i class="bi bi-info-circle me-1"></i>
                Saisissez le numéro de carte résident pour récupérer les informations du demandeur.
                La nouvelle demande <%= typeDemandeLabel %> sera créée avec le statut <strong>CRÉÉ</strong>.
            </div>

            <%-- Champ de recherche AJAX --%>
            <div class="row g-3 mb-3">
                <div class="col-md-5">
                    <label class="form-label fw-semibold">Numéro de carte résident *</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="rechercheNumeroCarte"
                               placeholder="Ex : CR-001"
                               value="<%= avecForm.getNumeroCarteResident() != null
                                         ? avecForm.getNumeroCarteResident() : "" %>">
                        <button class="btn btn-outline-primary" type="button" id="btnRechercher">
                            <i class="bi bi-search"></i> Rechercher
                        </button>
                    </div>
                    <div id="rechercheSpinner" class="text-muted small mt-1 d-none">
                        <span class="spinner-border spinner-border-sm"></span> Recherche en cours…
                    </div>
                </div>
            </div>

            <%-- Résultat de la recherche --%>
            <div id="carteResidentResult" class="d-none">
                <div class="card border-success mb-3">
                    <div class="card-header bg-success text-white">
                        <i class="bi bi-person-check me-1"></i>Demandeur trouvé
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <small class="text-muted">Nom complet</small>
                                <p class="fw-bold mb-1" id="resultNom">—</p>
                            </div>
                            <div class="col-md-4">
                                <small class="text-muted">Type de visa</small>
                                <p class="fw-bold mb-1" id="resultTypeVisa">—</p>
                            </div>
                            <div class="col-md-4">
                                <small class="text-muted">N° carte résident</small>
                                <p class="fw-bold mb-1" id="resultNumero">—</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="carteResidentNotFound" class="alert alert-danger d-none">
                <i class="bi bi-exclamation-triangle me-1"></i>
                Aucune carte résident trouvée pour ce numéro.
            </div>

            <%-- Formulaire POST "avec antérieur" --%>
            <form method="post"
                  action="<%= ctxPath %>/demandes/duplicata-transfert/avec-anterieur"
                  id="formAvecAnterieur">
                <input type="hidden" name="typeDemande" value="<%= typeDemandeCode %>">
                <input type="hidden" name="numeroCarteResident" id="hiddenNumeroCarte"
                       value="<%= avecForm.getNumeroCarteResident() != null
                                  ? avecForm.getNumeroCarteResident() : "" %>">

                <div class="d-flex justify-content-end mt-3">
                    <button type="submit" class="btn btn-warning" id="btnSubmitAvec" disabled>
                        <i class="bi bi-send me-1"></i>
                        Créer la demande <%= typeDemandeLabel %> (statut : CRÉÉ)
                    </button>
                </div>
            </form>
        </div>

        <%-- ══════════════════════════════════════════════ --%>
        <%-- SECTION B : SANS données antérieures           --%>
        <%-- ══════════════════════════════════════════════ --%>
        <div id="sectionSans" class="d-none">
            <div class="alert alert-warning">
                <i class="bi bi-exclamation-circle me-1"></i>
                Le formulaire ci-dessous créera <strong>deux demandes</strong> :
                <ul class="mb-0 mt-1">
                    <li>Une demande <strong>Nouveau Titre</strong> avec statut <strong>VALIDÉ</strong>
                        (+ Visa + Carte résident associés)</li>
                    <li>Une demande <strong><%= typeDemandeLabel %></strong>
                        avec statut <strong>CRÉÉ</strong></li>
                </ul>
            </div>

            <form method="post"
                  action="<%= ctxPath %>/demandes/duplicata-transfert/sans-anterieur"
                  id="formSansAnterieur">
                <input type="hidden" name="typeDemande" value="<%= typeDemandeCode %>">

                <div class="row g-3">

                    <%-- ── Demandeur ── --%>
                    <div class="col-12">
                        <h5 class="text-primary border-bottom pb-1">Informations Demandeur</h5>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Nom *</label>
                        <input type="text" class="form-control" name="nom" required maxlength="100"
                               value="<%= sansForm.getNom() != null ? sansForm.getNom() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Prénom</label>
                        <input type="text" class="form-control" name="prenom" maxlength="100"
                               value="<%= sansForm.getPrenom() != null ? sansForm.getPrenom() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Date de naissance *</label>
                        <input type="date" class="form-control" name="dateNaissance" required
                               value="<%= sansForm.getDateNaissance() != null
                                         ? sansForm.getDateNaissance().toString() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Nationalité</label>
                        <select class="form-select" name="nationaliteId">
                            <option value="">Sélectionner…</option>
                            <% for (Nationalite n : nationalites) { %>
                            <option value="<%= n.getId() %>"
                                <%= sansForm.getNationaliteId() != null
                                   && sansForm.getNationaliteId().equals(n.getId()) ? "selected" : "" %>>
                                <%= n.getLibelle() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Situation familiale</label>
                        <select class="form-select" name="situationFamilialeId">
                            <option value="">Sélectionner…</option>
                            <% for (SituationFamiliale s : situationsFamiliales) { %>
                            <option value="<%= s.getId() %>"
                                <%= sansForm.getSituationFamilialeId() != null
                                   && sansForm.getSituationFamilialeId().equals(s.getId()) ? "selected" : "" %>>
                                <%= s.getLibelle() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Adresse à Madagascar *</label>
                        <textarea class="form-control" name="adresseMada" rows="2" required
                        ><%= sansForm.getAdresseMada() != null ? sansForm.getAdresseMada() : "" %></textarea>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Contact *</label>
                        <input type="text" class="form-control" name="contact" required maxlength="50"
                               value="<%= sansForm.getContact() != null ? sansForm.getContact() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" maxlength="100"
                               value="<%= sansForm.getEmail() != null ? sansForm.getEmail() : "" %>">
                    </div>

                    <%-- ── Passeport ── --%>
                    <div class="col-12 mt-3">
                        <h5 class="text-primary border-bottom pb-1">Informations Passeport</h5>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Numéro passeport *</label>
                        <input type="text" class="form-control" name="numeroPasseport" required maxlength="50"
                               value="<%= sansForm.getNumeroPasseport() != null
                                         ? sansForm.getNumeroPasseport() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Date de délivrance *</label>
                        <input type="date" class="form-control" name="dateDelivrancePasseport" required
                               value="<%= sansForm.getDateDelivrancePasseport() != null
                                         ? sansForm.getDateDelivrancePasseport().toString() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Date d'expiration *</label>
                        <input type="date" class="form-control" name="dateExpirationPasseport" required
                               value="<%= sansForm.getDateExpirationPasseport() != null
                                         ? sansForm.getDateExpirationPasseport().toString() : "" %>">
                    </div>

                    <%-- ── Visa transformable ── --%>
                    <div class="col-12 mt-3">
                        <h5 class="text-primary border-bottom pb-1">Informations Visa Transformable</h5>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Numéro du visa transformable *</label>
                        <input type="text" class="form-control" name="numeroVisaTransformable" required maxlength="50"
                               value="<%= sansForm.getNumeroVisaTransformable() != null
                                         ? sansForm.getNumeroVisaTransformable() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Date d'entrée sur le territoire *</label>
                        <input type="date" class="form-control" name="dateEntreeTerritoire" required
                               value="<%= sansForm.getDateEntreeTerritoire() != null
                                         ? sansForm.getDateEntreeTerritoire().toString() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Lieu d'entrée sur le territoire *</label>
                        <input type="text" class="form-control" name="lieuEntreeTerritoire" required maxlength="200"
                               value="<%= sansForm.getLieuEntreeTerritoire() != null
                                         ? sansForm.getLieuEntreeTerritoire() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Date de sortie du territoire</label>
                        <input type="date" class="form-control" name="dateSortieTerritoire"
                               value="<%= sansForm.getDateSortieTerritoire() != null
                                         ? sansForm.getDateSortieTerritoire().toString() : "" %>">
                    </div>

                    <%-- ── Type de visa & Pièces ── --%>
                    <div class="col-12 mt-3">
                        <h5 class="text-primary border-bottom pb-1">Visa et Pièces Justificatives</h5>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Type de visa *</label>
                        <select class="form-select" name="typeVisaId" id="typeVisaIdSans" required>
                            <option value="">Sélectionner…</option>
                            <% for (TypeVisa tv : typeVisas) { %>
                            <option value="<%= tv.getId() %>"
                                <%= sansForm.getTypeVisaId() != null
                                   && sansForm.getTypeVisaId().equals(tv.getId()) ? "selected" : "" %>>
                                <%= tv.getLibelle() %>
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Pièces communes</label>
                        <div class="row g-2">
                            <% for (PieceJustificative piece : piecesCommunes) { %>
                            <div class="col-md-6">
                                <div class="form-check border rounded p-2">
                                    <input class="form-check-input" type="checkbox"
                                           name="pieceIds" value="<%= piece.getId() %>"
                                           id="pc-sans-<%= piece.getId() %>"
                                        <%= selectedPieceIds.contains(piece.getId()) ? "checked" : "" %>>
                                    <label class="form-check-label" for="pc-sans-<%= piece.getId() %>">
                                        <%= piece.getLibelle() %>
                                        <%= Boolean.TRUE.equals(piece.getObligatoire()) ? " *" : "" %>
                                    </label>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Pièces spécifiques au type de visa</label>
                        <div id="specificPiecesContainerSans"
                             data-endpoint="<%= ctxPath %>/demandes/duplicata-transfert/pieces-specifiques">
                            <div class="row g-2">
                                <% if (piecesSpecifiques.isEmpty()) { %>
                                <div class="col-12 text-muted">
                                    Sélectionnez un type de visa pour afficher les pièces spécifiques.
                                </div>
                                <% } else {
                                    for (PieceJustificative piece : piecesSpecifiques) { %>
                                <div class="col-md-6">
                                    <div class="form-check border rounded p-2">
                                        <input class="form-check-input" type="checkbox"
                                               name="pieceIds" value="<%= piece.getId() %>"
                                               id="ps-sans-<%= piece.getId() %>"
                                            <%= selectedPieceIds.contains(piece.getId()) ? "checked" : "" %>>
                                        <label class="form-check-label" for="ps-sans-<%= piece.getId() %>">
                                            <%= piece.getLibelle() %>
                                            <%= Boolean.TRUE.equals(piece.getObligatoire()) ? " *" : "" %>
                                        </label>
                                    </div>
                                </div>
                                <% } } %>
                            </div>
                        </div>
                    </div>

                    <%-- ── Visa & Carte Résident (générés pour la demande NT VALIDE) ── --%>
                    <div class="col-12 mt-3">
                        <h5 class="text-primary border-bottom pb-1">
                            Visa & Carte Résident
                            <small class="text-muted fw-normal fs-6">
                                (associés à la demande Nouveau Titre VALIDÉ)
                            </small>
                        </h5>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Numéro du visa *</label>
                        <input type="text" class="form-control" name="numeroVisa" required maxlength="50"
                               value="<%= sansForm.getNumeroVisa() != null ? sansForm.getNumeroVisa() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Début validité visa *</label>
                        <input type="date" class="form-control" name="dateDebutVisa" required
                               value="<%= sansForm.getDateDebutVisa() != null
                                         ? sansForm.getDateDebutVisa().toString() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Fin validité visa *</label>
                        <input type="date" class="form-control" name="dateFinVisa" required
                               value="<%= sansForm.getDateFinVisa() != null
                                         ? sansForm.getDateFinVisa().toString() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Numéro carte résident *</label>
                        <input type="text" class="form-control" name="numeroCarteResident" required maxlength="50"
                               value="<%= sansForm.getNumeroCarteResident() != null
                                         ? sansForm.getNumeroCarteResident() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Début carte résident *</label>
                        <input type="date" class="form-control" name="dateDebutCarteResident" required
                               value="<%= sansForm.getDateDebutCarteResident() != null
                                         ? sansForm.getDateDebutCarteResident().toString() : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Fin carte résident *</label>
                        <input type="date" class="form-control" name="dateFinCarteResident" required
                               value="<%= sansForm.getDateFinCarteResident() != null
                                         ? sansForm.getDateFinCarteResident().toString() : "" %>">
                    </div>

                    <div class="col-12 mt-3 d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-send me-1"></i>
                            Créer les deux demandes (NT VALIDÉ + <%= typeDemandeLabel %> CRÉÉ)
                        </button>
                    </div>

                </div><%-- /row --%>
            </form>
        </div><%-- /sectionSans --%>

    </div><%-- /card-body --%>
</div><%-- /card --%>

<script>
    (function () {
        const ctxPath  = '<%= ctxPath %>';
        const radioAvec = document.getElementById('radioAvec');
        const radioSans = document.getElementById('radioSans');
        const sectionAvec = document.getElementById('sectionAvec');
        const sectionSans = document.getElementById('sectionSans');

        // ── Basculement radio ──────────────────────────────
        function toggleSections() {
            if (radioAvec.checked) {
                sectionAvec.classList.remove('d-none');
                sectionSans.classList.add('d-none');
            } else {
                sectionAvec.classList.add('d-none');
                sectionSans.classList.remove('d-none');
            }
        }
        radioAvec.addEventListener('change', toggleSections);
        radioSans.addEventListener('change', toggleSections);

        // ── Recherche carte résident (AJAX) ────────────────
        const inputCarte    = document.getElementById('rechercheNumeroCarte');
        const btnRechercher = document.getElementById('btnRechercher');
        const spinner       = document.getElementById('rechercheSpinner');
        const resultDiv     = document.getElementById('carteResidentResult');
        const notFoundDiv   = document.getElementById('carteResidentNotFound');
        const hiddenInput   = document.getElementById('hiddenNumeroCarte');
        const btnSubmit     = document.getElementById('btnSubmitAvec');

        function rechercherCarte() {
            const numero = inputCarte.value.trim();
            if (!numero) return;

            spinner.classList.remove('d-none');
            resultDiv.classList.add('d-none');
            notFoundDiv.classList.add('d-none');
            btnSubmit.disabled = true;

            fetch(ctxPath + '/demandes/duplicata-transfert/recherche-carte?numero=' + encodeURIComponent(numero))
                .then(r => r.json())
                .then(data => {
                    spinner.classList.add('d-none');
                    if (data.found) {
                        document.getElementById('resultNom').textContent =
                            data.nomDemandeur + ' ' + data.prenomDemandeur;
                        document.getElementById('resultTypeVisa').textContent = data.typeVisa;
                        document.getElementById('resultNumero').textContent   = data.numeroCarteResident;
                        hiddenInput.value = data.numeroCarteResident;
                        resultDiv.classList.remove('d-none');
                        btnSubmit.disabled = false;
                    } else {
                        notFoundDiv.classList.remove('d-none');
                        hiddenInput.value  = '';
                        btnSubmit.disabled = true;
                    }
                })
                .catch(() => {
                    spinner.classList.add('d-none');
                    notFoundDiv.classList.remove('d-none');
                });
        }

        btnRechercher.addEventListener('click', rechercherCarte);
        inputCarte.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); rechercherCarte(); } });

        // ── Pièces spécifiques dynamiques (section SANS) ───
        const selectTypeVisa = document.getElementById('typeVisaIdSans');
        const container      = document.getElementById('specificPiecesContainerSans');
        const endpoint       = container ? container.dataset.endpoint : null;

        if (selectTypeVisa && endpoint) {
            selectTypeVisa.addEventListener('change', function () {
                const typeVisaId = this.value;
                if (!typeVisaId) {
                    container.innerHTML =
                        '<div class="row g-2"><div class="col-12 text-muted">' +
                        'Sélectionnez un type de visa pour afficher les pièces spécifiques.</div></div>';
                    return;
                }
                fetch(endpoint + '?typeVisaId=' + typeVisaId)
                    .then(r => r.json())
                    .then(pieces => {
                        if (!pieces.length) {
                            container.innerHTML =
                                '<div class="row g-2"><div class="col-12 text-muted">' +
                                'Aucune pièce spécifique pour ce type de visa.</div></div>';
                            return;
                        }
                        let html = '<div class="row g-2">';
                        pieces.forEach(p => {
                            html += `
                            <div class="col-md-6">
                                <div class="form-check border rounded p-2">
                                    <input class="form-check-input" type="checkbox"
                                           name="pieceIds" value="${p.id}" id="ps-dyn-${p.id}">
                                    <label class="form-check-label" for="ps-dyn-${p.id}">
                                        ${p.libelle}${p.obligatoire ? ' *' : ''}
                                    </label>
                                </div>
                            </div>`;
                        });
                        html += '</div>';
                        container.innerHTML = html;
                    });
            });
        }
    })();
</script>
