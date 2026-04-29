package com.visa.example.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * Gère le stockage physique des fichiers PDF uploadés.
 *
 * Structure sur disque :
 *   ${app.upload.dir}/demandes/{demandeId}/{pieceCode}_{timestamp}.pdf
 *
 * La propriété app.upload.dir se configure dans application.properties :
 *   app.upload.dir=uploads
 * (chemin relatif au répertoire de travail, ou absolu selon le déploiement)
 */
@Service
public class FileStorageService {

    private static final String PDF_CONTENT_TYPE  = "application/pdf";
    private static final long   MAX_SIZE_BYTES    = 10 * 1024 * 1024L; // 10 Mo

    private final Path baseUploadDir;

    public FileStorageService(
            @Value("${app.upload.dir:uploads}") String uploadDir) {
        this.baseUploadDir = Paths.get(uploadDir).toAbsolutePath().normalize();
    }

    /**
     * Stocke le fichier PDF pour une pièce donnée d'une demande.
     *
     * @param demandeId  identifiant de la demande
     * @param pieceCode  code de la pièce justificative (ex : "PASS")
     * @param file       fichier uploadé
     * @return chemin relatif du fichier sauvegardé (à persister dans demande_piece.chemin_fichier)
     * @throws IllegalArgumentException si le fichier n'est pas un PDF valide ou dépasse la taille limite
     * @throws IOException              si l'écriture échoue
     */
    public String storerFichierPiece(Long demandeId, String pieceCode, MultipartFile file)
            throws IOException {

        validerFichierPdf(file);

        // Répertoire cible : uploads/demandes/{demandeId}/
        Path demandeDir = baseUploadDir
                .resolve("demandes")
                .resolve(String.valueOf(demandeId));
        Files.createDirectories(demandeDir);

        // Nom de fichier : PASS_1713262800000.pdf
        String safeCode = pieceCode.replaceAll("[^A-Za-z0-9_-]", "_");
        String fileName = safeCode + "_" + System.currentTimeMillis() + ".pdf";
        Path targetPath = demandeDir.resolve(fileName);

        Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);

        // Chemin relatif stocké en base (portable, indépendant du serveur)
        return "demandes/" + demandeId + "/" + fileName;
    }

    /**
     * Supprime un fichier existant (lors d'un remplacement ou d'une suppression).
     * Ne lève pas d'exception si le fichier est introuvable.
     */
    public void supprimerFichier(String cheminRelatif) {
        if (cheminRelatif == null || cheminRelatif.isBlank()) return;
        try {
            Path path = baseUploadDir.resolve(cheminRelatif).normalize();
            // Sécurité : interdit de sortir du répertoire de base
            if (path.startsWith(baseUploadDir)) {
                Files.deleteIfExists(path);
            }
        } catch (IOException ignored) {
            // Suppression best-effort
        }
    }

    /**
     * Retourne le chemin absolu d'un fichier à partir de son chemin relatif.
     * Utilisé par le controller pour servir le fichier en téléchargement.
     */
    public Path resoudreCheminAbsolu(String cheminRelatif) {
        return baseUploadDir.resolve(cheminRelatif).normalize();
    }

    // ── Validation ────────────────────────────────────────

    private void validerFichierPdf(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Le fichier est vide ou absent.");
        }
        if (file.getSize() > MAX_SIZE_BYTES) {
            throw new IllegalArgumentException(
                    "Le fichier dépasse la taille maximale autorisée (10 Mo).");
        }

        String contentType = file.getContentType();
        if (!PDF_CONTENT_TYPE.equalsIgnoreCase(contentType)) {
            throw new IllegalArgumentException(
                    "Seuls les fichiers PDF sont acceptés. Type reçu : " + contentType);
        }

        // Double vérification via les magic bytes PDF (%PDF-)
        try {
            byte[] header = new byte[5];
            int read = file.getInputStream().read(header);
            if (read < 5 || header[0] != '%' || header[1] != 'P'
                    || header[2] != 'D' || header[3] != 'F' || header[4] != '-') {
                throw new IllegalArgumentException(
                        "Le fichier ne semble pas être un PDF valide (en-tête invalide).");
            }
        } catch (IOException e) {
            throw new IllegalArgumentException("Impossible de lire le fichier : " + e.getMessage());
        }
    }
}