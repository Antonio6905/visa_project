package com.visa.example.controller;

import com.visa.example.entity.Demande;
import com.visa.example.entity.DemandePiece;
import com.visa.example.service.DemandeStatutService;
import com.visa.example.service.FileStorageService;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Path;

/**
 * Gère :
 *  - POST  /demandes/{id}/pieces/{pieceId}/upload  → upload PDF d'une pièce
 *  - GET   /demandes/{id}/pieces/{pieceId}/fichier → téléchargement du PDF
 *  - POST  /demandes/{id}/statut                  → changement de statut
 */
@Controller
@RequestMapping("/demandes")
public class DemandeStatutController {

    private final DemandeStatutService demandeStatutService;
    private final FileStorageService   fileStorageService;

    public DemandeStatutController(
            DemandeStatutService demandeStatutService,
            FileStorageService fileStorageService) {
        this.demandeStatutService = demandeStatutService;
        this.fileStorageService   = fileStorageService;
    }

    // ══════════════════════════════════════════════════════
    // Upload PDF d'une pièce justificative
    // ══════════════════════════════════════════════════════

    /**
     * Reçoit un fichier PDF pour une pièce justificative d'une demande.
     * Redirige vers la page d'édition de la demande avec un message flash.
     */
    @PostMapping("/{id}/pieces/{pieceId}/upload")
    public String uploaderFichier(
            @PathVariable("id")      Long demandeId,
            @PathVariable("pieceId") Long pieceId,
            @RequestParam("fichier") MultipartFile fichier,
            RedirectAttributes redirectAttributes) {

        try {
            demandeStatutService.uploaderFichierPiece(demandeId, pieceId, fichier);
            redirectAttributes.addFlashAttribute("success",
                    "Fichier uploadé avec succès pour la pièce #" + pieceId + ".");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        } catch (IOException ex) {
            redirectAttributes.addFlashAttribute("error",
                    "Erreur lors de l'enregistrement du fichier : " + ex.getMessage());
        }

        return "redirect:/demandes/" + demandeId + "/edit";
    }

    // ══════════════════════════════════════════════════════
    // Téléchargement d'un fichier PDF uploadé
    // ══════════════════════════════════════════════════════

    @GetMapping("/{id}/pieces/{pieceId}/fichier")
    public ResponseEntity<Resource> telechargerFichier(
            @PathVariable("id")      Long demandeId,
            @PathVariable("pieceId") Long pieceId) {

        try {
            DemandePiece dp = demandeStatutService
                    .getPiecePourDemande(demandeId, pieceId);

            if (!dp.isFichierUploaded()) {
                return ResponseEntity.notFound().build();
            }

            Path filePath = fileStorageService.resoudreCheminAbsolu(dp.getCheminFichier());
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.notFound().build();
            }

            String filename = filePath.getFileName().toString();
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION,
                            "inline; filename=\"" + filename + "\"")
                    .body(resource);

        } catch (MalformedURLException | IllegalArgumentException ex) {
            return ResponseEntity.badRequest().build();
        }
    }

    // ══════════════════════════════════════════════════════
    // Changement de statut
    // ══════════════════════════════════════════════════════

    /**
     * Change le statut d'une demande.
     * Redirige vers la page de détail avec un message flash.
     */
    @PostMapping("/{id}/statut")
    public String changerStatut(
            @PathVariable("id")              Long demandeId,
            @RequestParam("nouveauStatut")   String nouveauStatutCode,
            RedirectAttributes redirectAttributes) {

        try {
            Demande demande = demandeStatutService.changerStatut(demandeId, nouveauStatutCode);
            redirectAttributes.addFlashAttribute("success",
                    "Statut de la demande #" + demandeId + " mis à jour : "
                    + demande.getStatut().getLibelle());
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }

        return "redirect:/demandes/" + demandeId;
    }
}