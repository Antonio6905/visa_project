package com.visa.example.service;

import com.visa.example.entity.Demande;
import com.visa.example.entity.DemandePiece;
import com.visa.example.entity.StatutDemande;
import com.visa.example.repository.DemandePieceRepository;
import com.visa.example.repository.DemandeRepository;
import com.visa.example.repository.StatutDemandeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

/**
 * Gère l'upload de fichiers PDF sur les pièces justificatives d'une demande,
 * ainsi que le changement de statut avec ses règles métier.
 */
@Service
public class DemandeStatutService {

    // Statuts bloquants (demande figée — plus de modification possible)
    private static final String CODE_SCAN   = "SCAN";
    private static final String CODE_VALIDE = "VALIDE";
    private static final String CODE_REFUSE = "REFUSE";

    private final DemandeRepository        demandeRepository;
    private final DemandePieceRepository   demandePieceRepository;
    private final StatutDemandeRepository  statutDemandeRepository;
    private final FileStorageService       fileStorageService;
    private final SignatureImageService    signatureImageService;

    public DemandeStatutService(
            DemandeRepository demandeRepository,
            DemandePieceRepository demandePieceRepository,
            StatutDemandeRepository statutDemandeRepository,
            FileStorageService fileStorageService,
            SignatureImageService signatureImageService) {
        this.demandeRepository       = demandeRepository;
        this.demandePieceRepository  = demandePieceRepository;
        this.statutDemandeRepository = statutDemandeRepository;
        this.fileStorageService      = fileStorageService;
        this.signatureImageService   = signatureImageService;
    }

    // ══════════════════════════════════════════════════════
    // Upload PDF d'une pièce justificative
    // ══════════════════════════════════════════════════════

    /**
     * Upload (ou remplacement) du fichier PDF pour une pièce d'une demande.
     * La demande doit être modifiable (statut != SCAN/VALIDE/REFUSE).
     *
     * @param demandeId identifiant de la demande
     * @param pieceId   identifiant de la pièce justificative
     * @param file      fichier PDF uploadé
     * @return la DemandePiece mise à jour
     */
    @Transactional
    public DemandePiece uploaderFichierPiece(Long demandeId, Long pieceId, MultipartFile file)
            throws IOException {

        Demande demande = getDemandeModifiableOrThrow(demandeId);

        DemandePiece demandePiece = demandePieceRepository
                .findByDemandeIdAndPieceId(demandeId, pieceId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Cette pièce n'est pas associée à la demande #" + demandeId));

        // Supprimer l'ancien fichier si existant
        if (demandePiece.isFichierUploaded()) {
            fileStorageService.supprimerFichier(demandePiece.getCheminFichier());
        }

        String cheminRelatif = fileStorageService.storerFichierPiece(
                demandeId,
                demandePiece.getPiece().getCode(),
                file);

        demandePiece.setCheminFichier(cheminRelatif);
        return demandePieceRepository.save(demandePiece);
    }

    // ══════════════════════════════════════════════════════
    // Changement de statut
    // ══════════════════════════════════════════════════════

    /**
     * Change le statut d'une demande en appliquant les règles métier :
     * <ul>
     *   <li>La demande ne peut plus être modifiée si son statut est SCAN, VALIDE ou REFUSE.</li>
     *   <li>On ne peut pas passer en SCAN si des pièces obligatoires n'ont pas été uploadées.</li>
     * </ul>
     *
     * @param demandeId      identifiant de la demande
     * @param nouveauStatutCode code du nouveau statut (ex : "EN_COURS", "SCAN", "VALIDE", "REFUSE")
     * @return la demande mise à jour
     */
    @Transactional
    public Demande changerStatut(Long demandeId, String nouveauStatutCode) {
        Demande demande = demandeRepository.findById(demandeId)
                .orElseThrow(() -> new IllegalArgumentException("Demande introuvable."));

        // Règle 1 : statut actuel bloquant ?
        String statutActuelCode = demande.getStatut() != null
                ? demande.getStatut().getCode() : null;
        if (CODE_SCAN.equals(statutActuelCode)
                || CODE_VALIDE.equals(statutActuelCode)
                || CODE_REFUSE.equals(statutActuelCode)) {
            throw new IllegalArgumentException(
                    "La demande est en statut " + statutActuelCode +
                    " et ne peut plus être modifiée.");
        }

        // Règle 2 : passage en SCAN → toutes les pièces obligatoires doivent être uploadées
        if (CODE_SCAN.equals(nouveauStatutCode)) {
            List<DemandePiece> manquantes =
                    demandePieceRepository.findPiecesObligatoiresSansUpload(demandeId);
            if (!manquantes.isEmpty()) {
                StringBuilder msg = new StringBuilder(
                        "Impossible de passer en statut SCAN : les pièces obligatoires suivantes " +
                        "n'ont pas encore été uploadées : ");
                for (int i = 0; i < manquantes.size(); i++) {
                    if (i > 0) msg.append(", ");
                    msg.append(manquantes.get(i).getPiece().getLibelle());
                }
                throw new IllegalArgumentException(msg.toString());
            }
        }

        if (CODE_SCAN.equals(nouveauStatutCode) || CODE_VALIDE.equals(nouveauStatutCode)) {
            if (!signatureImageService.hasPhotoAndSignature(demandeId)) {
                throw new IllegalArgumentException(
                        "Impossible de passer au statut " + nouveauStatutCode
                        + " : la photo et la signature sont obligatoires.");
            }
        }

        StatutDemande nouveauStatut = statutDemandeRepository.findByCode(nouveauStatutCode);
        if (nouveauStatut == null) {
            throw new IllegalArgumentException(
                    "Statut inconnu : " + nouveauStatutCode);
        }

        demande.setStatut(nouveauStatut);
        return demandeRepository.save(demande);
    }

    // ══════════════════════════════════════════════════════
    // Helpers
    // ══════════════════════════════════════════════════════

    /**
     * Retourne la demande uniquement si elle est encore modifiable.
     * Lève une exception si le statut est SCAN, VALIDE ou REFUSE.
     */
    public Demande getDemandeModifiableOrThrow(Long demandeId) {
        Demande demande = demandeRepository.findById(demandeId)
                .orElseThrow(() -> new IllegalArgumentException("Demande introuvable."));

        String code = demande.getStatut() != null ? demande.getStatut().getCode() : null;
        if (CODE_SCAN.equals(code) || CODE_VALIDE.equals(code) || CODE_REFUSE.equals(code)) {
            throw new IllegalArgumentException(
                    "La demande est en statut " + code + " et ne peut plus être modifiée.");
        }
        return demande;
    }

    /**
     * Vérifie si une demande est encore modifiable (sans lever d'exception).
     */
    public boolean estModifiable(Demande demande) {
        if (demande == null || demande.getStatut() == null) return true;
        String code = demande.getStatut().getCode();
        return !CODE_SCAN.equals(code) && !CODE_VALIDE.equals(code) && !CODE_REFUSE.equals(code);
    }

    /**
     * Retourne tous les statuts disponibles pour affichage dans le select.
     */
    public List<StatutDemande> getAllStatuts() {
        return statutDemandeRepository.findAll();
    }

    /**
     * Retourne la DemandePiece pour un couple (demandeId, pieceId).
     */
    public DemandePiece getPiecePourDemande(Long demandeId, Long pieceId) {
        return demandePieceRepository
                .findByDemandeIdAndPieceId(demandeId, pieceId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Pièce introuvable pour la demande #" + demandeId));
    }
}