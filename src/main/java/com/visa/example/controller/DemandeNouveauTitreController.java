package com.visa.example.controller;

import com.visa.example.dto.DemandeEditForm;
import com.visa.example.dto.NouveauTitreForm;
import com.visa.example.entity.Demande;
import com.visa.example.entity.DemandePiece;
import com.visa.example.entity.PieceJustificative;
import com.visa.example.service.DemandeNouveauTitreService;
import com.visa.example.service.DemandeStatutService;
import com.visa.example.service.FileStorageService;
import com.visa.example.service.QRCodeService;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping("/demandes")
public class DemandeNouveauTitreController {

    private final DemandeNouveauTitreService demandeNouveauTitreService;
    private final DemandeStatutService       demandeStatutService;
    private final FileStorageService         fileStorageService;
    private final QRCodeService              qrCodeService;

    public DemandeNouveauTitreController(
            DemandeNouveauTitreService demandeNouveauTitreService,
            DemandeStatutService demandeStatutService,
            FileStorageService fileStorageService,
            QRCodeService qrCodeService) {
        this.demandeNouveauTitreService = demandeNouveauTitreService;
        this.demandeStatutService       = demandeStatutService;
        this.fileStorageService         = fileStorageService;
        this.qrCodeService              = qrCodeService;
    }

    // ══════════════════════════════════════════════════════
    // Liste
    // ══════════════════════════════════════════════════════

    @GetMapping
    public String listDemandes(Model model) {
        model.addAttribute("pageTitle", "Liste des Demandes");
        model.addAttribute("content", "demandes/list.jsp");
        model.addAttribute("demandes", demandeNouveauTitreService.getAllDemandes());
        return "layout";
    }

    // ══════════════════════════════════════════════════════
    // Détail
    // ══════════════════════════════════════════════════════

    @GetMapping("/{id}")
    public String showDemandeDetails(
            @PathVariable("id") Long demandeId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Demande demande = demandeNouveauTitreService.getDemandeByIdOrThrow(demandeId);
            model.addAttribute("pageTitle", "Détail Demande #" + demandeId);
            model.addAttribute("content", "demandes/detail.jsp");
            model.addAttribute("demande", demande);
            model.addAttribute("demandePieces",
                    demandeNouveauTitreService.getDemandePiecesParDemande(demandeId));
            return "layout";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/demandes";
        }
    }

    // ══════════════════════════════════════════════════════
    // Création Nouveau Titre
    // ══════════════════════════════════════════════════════

    @GetMapping("/nouveau-titre")
    public String showForm(Model model) {
        if (!model.containsAttribute("form")) {
            model.addAttribute("form", new NouveauTitreForm());
        }
        NouveauTitreForm form = (NouveauTitreForm) model.getAttribute("form");
        populateFormPage(model, form);
        return "layout";
    }

    /**
     * Soumission du formulaire nouveau titre avec upload facultatif de PDFs.
     * Le formulaire est en multipart/form-data.
     * Les fichiers sont transmis sous la clé "fichiers[{pieceId}]".
     */
    @PostMapping(value = "/nouveau-titre", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public String submitForm(
            @Valid @ModelAttribute("form") NouveauTitreForm form,
            BindingResult bindingResult,
            @RequestParam(required = false) Map<String, MultipartFile> fichiers,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (form.getDateDelivrancePasseport() != null
                && form.getDateExpirationPasseport() != null
                && form.getDateExpirationPasseport().isBefore(form.getDateDelivrancePasseport())) {
            bindingResult.rejectValue(
                    "dateExpirationPasseport",
                    "date.expiration.before.delivrance",
                    "La date d'expiration du passeport doit être postérieure à la date de délivrance.");
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Veuillez corriger les champs obligatoires du formulaire.");
            populateFormPage(model, form);
            return "layout";
        }

        try {
            Demande demande = demandeNouveauTitreService.creerDemandeNouveauTitre(form);

            // Upload des fichiers PDF fournis lors de la création
            uploadFichiersOptionnels(demande.getId(), fichiers);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Demande nouveau titre enregistrée avec succès. N° demande : " + demande.getId());
            return "redirect:/demandes/nouveau-titre";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            populateFormPage(model, form);
            return "layout";
        }
    }

    // ══════════════════════════════════════════════════════
    // Édition
    // ══════════════════════════════════════════════════════

    @GetMapping("/{id}/edit")
    public String showEditForm(
            @PathVariable("id") Long demandeId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Demande demande = demandeNouveauTitreService.getDemandeByIdOrThrow(demandeId);

            if (!model.containsAttribute("editForm")) {
                DemandeEditForm editForm = new DemandeEditForm();
                editForm.setTypeVisaId(
                        demande.getTypeVisa() != null ? demande.getTypeVisa().getId() : null);
                editForm.setPieceIds(
                        demandeNouveauTitreService.getPieceIdsParDemande(demandeId));
                model.addAttribute("editForm", editForm);
            }

            populateEditPage(model, demandeId, demande);
            return "layout";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/demandes";
        }
    }

    @PostMapping("/{id}/edit")
    public String submitEditForm(
            @PathVariable("id") Long demandeId,
            @Valid @ModelAttribute("editForm") DemandeEditForm editForm,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        Demande demande;
        try {
            demande = demandeStatutService.getDemandeModifiableOrThrow(demandeId);
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/demandes";
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Veuillez corriger le formulaire de modification.");
            populateEditPage(model, demandeId, demande);
            return "layout";
        }

        try {
            demandeNouveauTitreService.modifierDemande(
                    demandeId, editForm.getTypeVisaId(), editForm.getPieceIds());
            redirectAttributes.addFlashAttribute(
                    "success", "Demande #" + demandeId + " modifiée avec succès.");
            return "redirect:/demandes/" + demandeId + "/edit";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            populateEditPage(model, demandeId, demande);
            return "layout";
        }
    }

    // ══════════════════════════════════════════════════════
    // AJAX — pièces spécifiques
    // ══════════════════════════════════════════════════════

    @GetMapping(value = "/pieces-specifiques", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<PieceOptionResponse> getPiecesSpecifiques(
            @RequestParam(name = "typeVisaId", required = false) Long typeVisaId) {
        if (typeVisaId == null) return Collections.emptyList();

        List<PieceJustificative> pieces =
                demandeNouveauTitreService.getPiecesSpecifiquesParTypeVisa(typeVisaId);
        List<PieceOptionResponse> response = new ArrayList<>();
        for (PieceJustificative piece : pieces) response.add(new PieceOptionResponse(piece));
        return response;
    }

    // ══════════════════════════════════════════════════════
    // Génération QR Code
    // ══════════════════════════════════════════════════════

    /**
     * Génère un code QR pour une demande spécifique.
     * Le QR code contient l'URL complète vers la page de détail de la demande.
     *
     * @param demandeId l'ID de la demande
     * @return un objet JSON contenant le QR code en Base64 et l'URL encodée
     */
    @GetMapping("/{id}/qrcode")
    @ResponseBody
    public QRCodeResponse generateQRCode(
            @PathVariable("id") Long demandeId,
            jakarta.servlet.http.HttpServletRequest request) {
        try {
            // Construire l'URL complète vers la page de détail
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            if ((request.getScheme().equals("http") && request.getServerPort() != 80) ||
                    (request.getScheme().equals("https") && request.getServerPort() != 443)) {
                baseUrl += ":" + request.getServerPort();
            }
            String detailUrl = baseUrl + request.getContextPath() + "/demandes/" + demandeId;

            // Générer le QR code
            String qrCodeDataUri = qrCodeService.generateQRCodeDataURI(detailUrl);

            return new QRCodeResponse(qrCodeDataUri, detailUrl);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la génération du QR code : " + e.getMessage(), e);
        }
    }

    // ══════════════════════════════════════════════════════
    // Helpers privés
    // ══════════════════════════════════════════════════════

    private void populateFormPage(Model model, NouveauTitreForm form) {
        model.addAttribute("pageTitle", "Nouvelle Demande de Visa");
        model.addAttribute("content", "demandes/nouveau-titre-form.jsp");
        model.addAttribute("typeVisas", demandeNouveauTitreService.getTypeVisas());
        model.addAttribute("nationalites", demandeNouveauTitreService.getNationalites());
        model.addAttribute("situationsFamiliales", demandeNouveauTitreService.getSituationsFamiliales());
        model.addAttribute("piecesCommunes", demandeNouveauTitreService.getPiecesCommunes());
        model.addAttribute("piecesSpecifiques",
                demandeNouveauTitreService.getPiecesSpecifiquesParTypeVisa(form.getTypeVisaId()));
    }

    private void populateEditPage(Model model, Long demandeId, Demande demande) {
        DemandeEditForm editForm = (DemandeEditForm) model.getAttribute("editForm");
        Long typeVisaId = editForm != null ? editForm.getTypeVisaId() : null;

        List<DemandePiece> demandePieces =
                demandeNouveauTitreService.getDemandePiecesParDemande(demandeId);

        model.addAttribute("pageTitle", "Modifier Demande #" + demandeId);
        model.addAttribute("content", "demandes/edit.jsp");
        model.addAttribute("demande", demande);
        model.addAttribute("typeVisas", demandeNouveauTitreService.getTypeVisas());
        model.addAttribute("piecesCommunes", demandeNouveauTitreService.getPiecesCommunes());
        model.addAttribute("piecesSpecifiques",
                demandeNouveauTitreService.getPiecesSpecifiquesParTypeVisa(typeVisaId));
        model.addAttribute("demandePieces", demandePieces);
        model.addAttribute("tousStatuts", demandeStatutService.getAllStatuts());
    }

    /**
     * Upload silencieux des fichiers PDF fournis lors de la création d'une demande.
     * Les erreurs d'upload n'empêchent pas la création — elles seront traitables depuis edit.
     */
    private void uploadFichiersOptionnels(Long demandeId, Map<String, MultipartFile> fichiers) {
        if (fichiers == null) return;
        for (Map.Entry<String, MultipartFile> entry : fichiers.entrySet()) {
            String key = entry.getKey(); // ex : "fichiers[4]"
            MultipartFile file = entry.getValue();
            if (file == null || file.isEmpty()) continue;

            // Extraire l'id de pièce depuis la clé "fichiers[{pieceId}]"
            try {
                String stripped = key.replaceAll(".*\\[(\\d+)].*", "$1");
                Long pieceId = Long.parseLong(stripped);
                demandeStatutService.uploaderFichierPiece(demandeId, pieceId, file);
            } catch (  IllegalArgumentException | IOException ignored) {
                // Upload optionnel — on ne bloque pas la création
            }
        }
    }

    // ── Inner DTO JSON ────────────────────────────────────

    public static class PieceOptionResponse {
        private Long id;
        private String code;
        private String libelle;
        private boolean obligatoire;

        public PieceOptionResponse(PieceJustificative piece) {
            this.id          = piece.getId();
            this.code        = piece.getCode();
            this.libelle     = piece.getLibelle();
            this.obligatoire = Boolean.TRUE.equals(piece.getObligatoire());
        }

        public Long getId()            { return id; }
        public String getCode()        { return code; }
        public String getLibelle()     { return libelle; }
        public boolean isObligatoire() { return obligatoire; }
    }

    public static class QRCodeResponse {
        private String qrCode;
        private String url;

        public QRCodeResponse(String qrCode, String url) {
            this.qrCode = qrCode;
            this.url = url;
        }

        public String getQrCode() { return qrCode; }
        public String getUrl() { return url; }
    }
}