<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page import="com.visa.example.entity.*" %>

<%
    Demande demande = (Demande) request.getAttribute("demande");
    List<DemandePiece> pieces = (List<DemandePiece>) request.getAttribute("demandePieces");
    if (pieces == null) {
        pieces = Collections.emptyList();
    }
    VisaTransformable visaTransfo = demande.getVisaTransformable();
    Demandeur demandeur = visaTransfo.getPasseport().getDemandeur();

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");

    String ctxPath = request.getContextPath();
%>

<div class="card shadow-sm border-0">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0">Detail demande #<%= demande.getId() %></h4>
        <div>
            <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#qrCodeModal" title="Afficher le code QR">
                <i class="bi bi-qr-code"></i> QR Code
            </button>
            <a href="${pageContext.request.contextPath}/demandes" class="btn btn-light btn-sm">Retour liste</a>
            <a href="${pageContext.request.contextPath}/demandes/<%= demande.getId() %>/edit" class="btn btn-warning btn-sm">Modifier</a>
        </div>
    </div>
    <div class="card-body">
        <div class="row g-3">
            <div class="col-md-4">
                <strong>Date demande:</strong><br>
                <%= demande.getDateDemande() != null ? sdf.format(demande.getDateDemande()) : "-" %>
            </div>
            <div class="col-md-4">
                <strong>Type demande:</strong><br>
                <%= demande.getTypeDemande() != null ? demande.getTypeDemande().getLibelle() : "-" %>
            </div>
            <div class="col-md-4">
                <strong>Statut:</strong><br>
                <%= demande.getStatut() != null ? demande.getStatut().getLibelle() : "-" %>
            </div>
            <div class="col-md-6">
                <strong>Type visa:</strong><br>
                <%= demande.getTypeVisa() != null ? demande.getTypeVisa().getLibelle() : "-" %>
            </div>
        </div>

        <hr>

        <h5>Informations sur le demandeur</h5>
        <% if (demandeur==null) { %>
        <div class="alert alert-secondary">Aucune informations disponibles .</div>
        <% } else { %>
        <div class="card border mb-2">
            <div class="card-body py-2">
                <div class="row g-2">
                    <div class="col-md-4">
                        <strong>Nom:</strong><br>
                        <%= demandeur.getNom() !=null ? demandeur.getNom() : "-" %>
                    </div>
                    <div class="col-md-4">
                        <strong>Date de Naissance:</strong><br>
                        <%= demandeur.getDateNaissance() !=null ? sdfDate.format(demandeur.getDateNaissance()) : "-"
                        %>
                    </div>
                    <div class="col-md-4">
                        <strong>Nationalite:</strong><br>
                        <%= demandeur.getNationalite() !=null ?
                                demandeur.getNationalite().getLibelle() : "-" %>
                    </div>
                    <div class="col-md-4">
                        <strong>Situation Familiale:</strong><br>
                        <%= demandeur.getSituationFamiliale() !=null ?
                                demandeur.getSituationFamiliale().getLibelle() : "-" %>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <hr>

        <h5>Visa(s) Transformable(s) et passeport</h5>
        <% if (visaTransfo==null) { %>
        <div class="alert alert-secondary">Aucun visa transformable associe.</div>
        <% } else { %>
        <div class="card border mb-2">
            <div class="card-body py-2">
                <div class="row g-2">
                    <div class="col-md-4">
                        <strong>Numero (visa):</strong><br>
                        <%= visaTransfo.getNumero() != null ? visaTransfo.getNumero() : "-" %>
                    </div>
                    <div class="col-md-4">
                        <strong>Lieu d'entree:</strong><br>
                        <%= visaTransfo.getLieuEntreeTerritoire() != null ? visaTransfo.getLieuEntreeTerritoire() : "-" %>
                    </div>
                    <div class="col-md-4">
                        <strong>Date d'entree:</strong><br>
                        <%= visaTransfo.getDateEntreeTerritoire() != null ? sdfDate.format(visaTransfo.getDateEntreeTerritoire()) : "-" %>
                    </div>
                    <div class="col-md-4">
                        <strong>Date de sortie:</strong><br>
                        <%= visaTransfo.getDateSortieTerritoire() != null ? sdfDate.format(visaTransfo.getDateSortieTerritoire()) : "-" %>
                    </div>
                    <div class="col-md-4">
                        <strong>Numero de passeport:</strong><br>
                        <%= visaTransfo.getPasseport() != null ? visaTransfo.getPasseport().getNumero() : "-" %>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <hr>

        <h5>Pieces justificatives fournies</h5>
        <% if (pieces.isEmpty()) { %>
        <div class="alert alert-secondary mb-0">Aucune piece associee.</div>
        <% } else { %>
        <ul class="list-group">
            <% for (DemandePiece demandePiece : pieces) {
                PieceJustificative piece = demandePiece.getPiece();
                boolean uploaded = demandePiece.isFichierUploaded();
            %>
            <li class="list-group-item d-flex justify-content-between align-items-center">
                <% if(uploaded){ %>
                <a href="<%= ctxPath %>/demandes/<%= demande.getId() %>/pieces/<%= piece.getId() %>/fichier"
                   target="_blank" class="btn btn-sm btn-outline-success">
                    <i class="bi bi-eye me-1"></i>Voir le PDF
                </a>
                <%} %>
                <span><%= piece.getLibelle() %></span>
                <span class="badge bg-<%= Boolean.TRUE.equals(piece.getObligatoire()) ? "danger" : "secondary" %>">
                            <%= Boolean.TRUE.equals(piece.getObligatoire()) ? "obligatoire" : "optionnelle" %>
                        </span>
            </li>
            <% } %>
        </ul>
        <% } %>

    </div>
</div>

<!-- Modal QR Code -->
<div class="modal fade" id="qrCodeModal" tabindex="-1" aria-labelledby="qrCodeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="qrCodeModalLabel">
                    <i class="bi bi-qr-code"></i> Code QR - Demande #<%= demande.getId() %>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <div class="modal-body text-center">
                <div id="qrCodeContainer" class="mb-3">
                    <img id="qrCodeImage" src="" alt="QR Code" style="max-width: 300px; width: 100%;">
                </div>
                <div id="urlContainer" class="alert alert-info">
                    <small><strong>URL:</strong></small><br>
                    <small id="detailUrl" style="word-break: break-all;"></small>
                </div>
                <button type="button" class="btn btn-primary btn-sm" id="downloadQRCodeBtn">
                    <i class="bi bi-download"></i> Télécharger
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const demandeId = <%= demande.getId() %>;
        const contextPath = '<%= ctxPath %>';

        // Générer le QR code à l'ouverture du modal
        document.getElementById('qrCodeModal').addEventListener('show.bs.modal', function () {
            generateQRCode(demandeId, contextPath);
        });

        // Télécharger le QR code
        document.getElementById('downloadQRCodeBtn').addEventListener('click', function () {
            const img = document.getElementById('qrCodeImage');
            const link = document.createElement('a');
            link.href = img.src;
            link.download = 'qrcode-demande-' + demandeId + '.png';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    });

    function generateQRCode(demandeId, contextPath) {
        fetch(contextPath + '/demandes/' + demandeId + '/qrcode')
            .then(function (response) {
                if (!response.ok) throw new Error('Erreur ' + response.status);
                return response.json();
            })
            .then(function (data) {
                document.getElementById('qrCodeImage').src = data.qrCode;
                document.getElementById('detailUrl').textContent = data.url;
            })
            .catch(function (error) {
                console.error('Erreur QR code :', error);
                document.getElementById('qrCodeContainer').innerHTML =
                    '<div class="alert alert-danger">Erreur lors de la génération du QR code.</div>';
            });
    }
</script>