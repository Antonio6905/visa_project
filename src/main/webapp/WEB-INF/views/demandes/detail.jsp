<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.visa.example.entity.Demande" %>
<%@ page import="com.visa.example.entity.Demandeur" %>
<%@ page import="com.visa.example.entity.PieceJustificative" %>
<%@ page import="com.visa.example.entity.VisaTransformable" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>

<%
    Demande demande = (Demande) request.getAttribute("demande");
    List<PieceJustificative> pieces = (List<PieceJustificative>) request.getAttribute("pieces");
    if (pieces == null) {
        pieces = Collections.emptyList();
    }
    VisaTransformable visaTransfo = demande.getVisaTransformable();
    Demandeur demandeur = visaTransfo.getPasseport().getDemandeur();

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
%>

<div class="card shadow-sm border-0">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0">Detail demande #<%= demande.getId() %></h4>
        <div>
            <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#qrCodeModal" id="showQRCodeBtn" title="Afficher le code QR">
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

        <h5>Visa(s) Transformable(s)</h5>
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
                <% for (PieceJustificative piece : pieces) { %>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
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

<!-- Modal pour afficher le QR Code -->
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
document.addEventListener('DOMContentLoaded', function() {
    const demandeId = <%= demande.getId() %>;
    const contextPath = "${pageContext.request.contextPath}";
    
    // Générer le QR code quand le modal est ouvert
    document.getElementById('qrCodeModal').addEventListener('show.bs.modal', function() {
        generateQRCode(demandeId, contextPath);
    });
    
    // Télécharger le QR code
    document.getElementById('downloadQRCodeBtn').addEventListener('click', function() {
        const qrCodeImage = document.getElementById('qrCodeImage');
        const link = document.createElement('a');
        link.href = qrCodeImage.src;
        link.download = 'qrcode-demande-' + demandeId + '.png';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    });
});

function generateQRCode(demandeId, contextPath) {
    fetch(contextPath + '/demandes/' + demandeId + '/qrcode')
        .then(response => response.json())
        .then(data => {
            document.getElementById('qrCodeImage').src = data.qrCode;
            document.getElementById('detailUrl').textContent = data.url;
            console.log('QR code généré avec succès');
        })
        .catch(error => {
            console.error('Erreur lors de la génération du QR code:', error);
            document.getElementById('qrCodeContainer').innerHTML = 
                '<div class="alert alert-danger">Erreur lors de la génération du QR code</div>';
        });
}
</script>
