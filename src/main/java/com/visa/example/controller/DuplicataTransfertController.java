package com.visa.example.controller;

import com.visa.example.dto.DuplicataTransfertAvecAnterieurForm;
import com.visa.example.dto.DuplicataTransfertSansAnterieurForm;
import com.visa.example.entity.CarteResident;
import com.visa.example.entity.Demande;
import com.visa.example.entity.PieceJustificative;
import com.visa.example.service.DuplicataTransfertService;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/demandes/duplicata-transfert")
public class DuplicataTransfertController {

    private final DuplicataTransfertService service;

    public DuplicataTransfertController(DuplicataTransfertService service) {
        this.service = service;
    }

    // ══════════════════════════════════════════════════════
    // GET — affichage du formulaire principal (choix du type + radio)
    // ══════════════════════════════════════════════════════

    @GetMapping
    public String showForm(
            @RequestParam(name = "type", defaultValue = "DUP") String type,
            Model model) {

        if (!model.containsAttribute("avecAnterieurForm")) {
            DuplicataTransfertAvecAnterieurForm f = new DuplicataTransfertAvecAnterieurForm();
            f.setTypeDemande(type);
            model.addAttribute("avecAnterieurForm", f);
        }
        if (!model.containsAttribute("sansAnterieurForm")) {
            DuplicataTransfertSansAnterieurForm f = new DuplicataTransfertSansAnterieurForm();
            f.setTypeDemande(type);
            model.addAttribute("sansAnterieurForm", f);
        }

        populatePage(model, type, null);
        return "layout";
    }

    // ══════════════════════════════════════════════════════
    // AJAX — recherche carte résident (retourne JSON)
    // ══════════════════════════════════════════════════════

    @GetMapping(value = "/recherche-carte", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public CarteResidentResponse rechercherCarte(
            @RequestParam("numero") String numero) {

        CarteResident carte = service.findCarteResidentByNumero(numero.trim());
        if (carte == null) {
            return new CarteResidentResponse(false, null, null, null, null, null);
        }

        Demande demande = carte.getDemande();
        String nomDemandeur  = "Inconnu";
        String prenomDemandeur = "";

        // Remonte jusqu'au demandeur via passeport → visa_transformable → demande
        if (demande.getVisaTransformable() != null
                && demande.getVisaTransformable().getPasseport() != null
                && demande.getVisaTransformable().getPasseport().getDemandeur() != null) {
            var d = demande.getVisaTransformable().getPasseport().getDemandeur();
            nomDemandeur    = d.getNom();
            prenomDemandeur = d.getPrenom() != null ? d.getPrenom() : "";
        }

        return new CarteResidentResponse(
                true,
                carte.getNumeroCarteResident(),
                nomDemandeur,
                prenomDemandeur,
                demande.getTypeVisa() != null ? demande.getTypeVisa().getLibelle() : "N/A",
                demande.getId()
        );
    }

    // ══════════════════════════════════════════════════════
    // POST — CAS 1 : avec données antérieures
    // ══════════════════════════════════════════════════════

    @PostMapping("/avec-anterieur")
    public String submitAvecAnterieur(
            @Valid @ModelAttribute("avecAnterieurForm") DuplicataTransfertAvecAnterieurForm form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Veuillez corriger le formulaire.");
            populatePage(model, form.getTypeDemande(), null);
            return "layout";
        }

        try {
            Demande demande = service.creerDemandeAvecDonneesAnterieures(form);
            redirectAttributes.addFlashAttribute(
                    "success",
                    "Demande " + form.getTypeDemande() + " créée avec succès. N° demande : " + demande.getId()
            );
            return "redirect:/demandes/duplicata-transfert?type=" + form.getTypeDemande();
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            populatePage(model, form.getTypeDemande(), null);
            return "layout";
        }
    }

    // ══════════════════════════════════════════════════════
    // POST — CAS 2 : sans données antérieures (formulaire complet)
    // ══════════════════════════════════════════════════════

    @PostMapping("/sans-anterieur")
    public String submitSansAnterieur(
            @Valid @ModelAttribute("sansAnterieurForm") DuplicataTransfertSansAnterieurForm form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        // Validation croisée dates passeport
        if (form.getDateDelivrancePasseport() != null
                && form.getDateExpirationPasseport() != null
                && form.getDateExpirationPasseport().isBefore(form.getDateDelivrancePasseport())) {
            bindingResult.rejectValue(
                    "dateExpirationPasseport",
                    "date.expiration.before.delivrance",
                    "La date d'expiration du passeport doit être postérieure à la date de délivrance."
            );
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Veuillez corriger les champs obligatoires du formulaire.");
            populatePage(model, form.getTypeDemande(),
                    form.getTypeVisaId());
            return "layout";
        }

        try {
            Demande[] demandes = service.creerDemandeSansDonneesAnterieures(form);
            redirectAttributes.addFlashAttribute(
                    "success",
                    "Deux demandes créées avec succès : "
                            + "N° NT=" + demandes[0].getId()
                            + " (VALIDE) et N° " + form.getTypeDemande()
                            + "=" + demandes[1].getId() + " (CRÉÉ)."
            );
            return "redirect:/demandes/duplicata-transfert?type=" + form.getTypeDemande();
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            populatePage(model, form.getTypeDemande(), form.getTypeVisaId());
            return "layout";
        }
    }

    // ══════════════════════════════════════════════════════
    // AJAX — pièces spécifiques (réutilisé côté JS)
    // ══════════════════════════════════════════════════════

    @GetMapping(value = "/pieces-specifiques", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<PieceOptionResponse> getPiecesSpecifiques(
            @RequestParam(name = "typeVisaId", required = false) Long typeVisaId) {
        if (typeVisaId == null) return Collections.emptyList();

        List<PieceJustificative> pieces = service.getPiecesSpecifiquesParTypeVisa(typeVisaId);
        List<PieceOptionResponse> result = new ArrayList<>();
        for (PieceJustificative p : pieces) result.add(new PieceOptionResponse(p));
        return result;
    }

    // ══════════════════════════════════════════════════════
    // Helpers privés
    // ══════════════════════════════════════════════════════

    private void populatePage(Model model, String type, Long typeVisaId) {
        String label = "TRF".equals(type) ? "Transfert" : "Duplicata";
        model.addAttribute("pageTitle", "Demande " + label);
        model.addAttribute("content", "demandes/duplicata-transfert-form.jsp");
        model.addAttribute("typeDemandeCode", type);
        model.addAttribute("typeDemandeLabel", label);
        model.addAttribute("typeVisas", service.getTypeVisas());
        model.addAttribute("nationalites", service.getNationalites());
        model.addAttribute("situationsFamiliales", service.getSituationsFamiliales());
        model.addAttribute("piecesCommunes", service.getPiecesCommunes());
        model.addAttribute("piecesSpecifiques", service.getPiecesSpecifiquesParTypeVisa(typeVisaId));
    }

    // ── Inner DTOs pour les réponses JSON ─────────────────

    public static class CarteResidentResponse {
        private boolean found;
        private String numeroCarteResident;
        private String nomDemandeur;
        private String prenomDemandeur;
        private String typeVisa;
        private Long demandeSourceId;

        public CarteResidentResponse(boolean found, String numero, String nom,
                                     String prenom, String typeVisa, Long demandeSourceId) {
            this.found               = found;
            this.numeroCarteResident = numero;
            this.nomDemandeur        = nom;
            this.prenomDemandeur     = prenom;
            this.typeVisa            = typeVisa;
            this.demandeSourceId     = demandeSourceId;
        }

        public boolean isFound()                  { return found; }
        public String getNumeroCarteResident()    { return numeroCarteResident; }
        public String getNomDemandeur()           { return nomDemandeur; }
        public String getPrenomDemandeur()        { return prenomDemandeur; }
        public String getTypeVisa()               { return typeVisa; }
        public Long getDemandeSourceId()          { return demandeSourceId; }
    }

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

        public Long getId()          { return id; }
        public String getCode()      { return code; }
        public String getLibelle()   { return libelle; }
        public boolean isObligatoire() { return obligatoire; }
    }
}