package com.visa.example.controller;

import com.visa.example.dto.NouveauTitreForm;
import com.visa.example.entity.Demande;
import com.visa.example.entity.PieceJustificative;
import com.visa.example.service.DemandeNouveauTitreService;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/demandes")
public class DemandeNouveauTitreController {

    private final DemandeNouveauTitreService demandeNouveauTitreService;

    public DemandeNouveauTitreController(DemandeNouveauTitreService demandeNouveauTitreService) {
        this.demandeNouveauTitreService = demandeNouveauTitreService;
    }

    @GetMapping("/nouveau-titre")
    public String showForm(Model model) {
        if (!model.containsAttribute("form")) {
            model.addAttribute("form", new NouveauTitreForm());
        }

        NouveauTitreForm form = (NouveauTitreForm) model.getAttribute("form");
        populateFormPage(model, form);
        return "layout";
    }

    @PostMapping("/nouveau-titre")
    public String submitForm(
            @Valid @ModelAttribute("form") NouveauTitreForm form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if (form.getDateDelivrancePasseport() != null
                && form.getDateExpirationPasseport() != null
                && form.getDateExpirationPasseport().isBefore(form.getDateDelivrancePasseport())) {
            bindingResult.rejectValue(
                    "dateExpirationPasseport",
                    "date.expiration.before.delivrance",
                    "La date d'expiration du passeport doit etre posterieure a la date de delivrance"
            );
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Veuillez corriger les champs obligatoires du formulaire.");
            populateFormPage(model, form);
            return "layout";
        }

        try {
            Demande demande = demandeNouveauTitreService.creerDemandeNouveauTitre(form);
            redirectAttributes.addFlashAttribute(
                    "success",
                    "Demande nouveau titre enregistree avec succes. Numero de demande: " + demande.getId()
            );
            return "redirect:/demandes/nouveau-titre";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            populateFormPage(model, form);
            return "layout";
        }
    }

    @GetMapping(value = "/pieces-specifiques", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<PieceOptionResponse> getPiecesSpecifiques(@RequestParam(name = "typeVisaId", required = false) Long typeVisaId) {
        if (typeVisaId == null) {
            return Collections.emptyList();
        }

        List<PieceJustificative> pieces = demandeNouveauTitreService.getPiecesSpecifiquesParTypeVisa(typeVisaId);
        List<PieceOptionResponse> response = new ArrayList<>();
        for (PieceJustificative piece : pieces) {
            response.add(new PieceOptionResponse(piece));
        }
        return response;
    }

    private void populateFormPage(Model model, NouveauTitreForm form) {
        model.addAttribute("pageTitle", "Nouvelle Demande de Visa");
        model.addAttribute("content", "demandes/nouveau-titre-form.jsp");
        model.addAttribute("typeVisas", demandeNouveauTitreService.getTypeVisas());
        model.addAttribute("nationalites", demandeNouveauTitreService.getNationalites());
        model.addAttribute("situationsFamiliales", demandeNouveauTitreService.getSituationsFamiliales());
        model.addAttribute("piecesCommunes", demandeNouveauTitreService.getPiecesCommunes());
        model.addAttribute(
                "piecesSpecifiques",
                demandeNouveauTitreService.getPiecesSpecifiquesParTypeVisa(form.getTypeVisaId())
        );
    }

    public static class PieceOptionResponse {
        private Long id;
        private String code;
        private String libelle;
        private boolean obligatoire;

        public PieceOptionResponse(PieceJustificative piece) {
            this.id = piece.getId();
            this.code = piece.getCode();
            this.libelle = piece.getLibelle();
            this.obligatoire = Boolean.TRUE.equals(piece.getObligatoire());
        }

        public Long getId() {
            return id;
        }

        public String getCode() {
            return code;
        }

        public String getLibelle() {
            return libelle;
        }

        public boolean isObligatoire() {
            return obligatoire;
        }
    }
}
