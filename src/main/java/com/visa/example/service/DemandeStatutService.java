package com.visa.example.service;

import com.visa.example.entity.Demande;
import com.visa.example.entity.DemandePiece;
import com.visa.example.entity.HistoriqueStatutDemande;
import com.visa.example.entity.StatutDemande;
import com.visa.example.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Service
public class DemandeStatutService {

    private static final String CODE_SCAN   = "SCAN";
    private static final String CODE_VALIDE = "VALIDE";
    private static final String CODE_REFUSE = "REFUSE";

    private final DemandeRepository                  demandeRepository;
    private final DemandePieceRepository             demandePieceRepository;
    private final StatutDemandeRepository            statutDemandeRepository;
    private final FileStorageService                 fileStorageService;
    private final AdministrateurRepository           administrateurRepository;
    private final HistoriqueStatutDemandeRepository  historiqueStatutDemandeRepository;

    public DemandeStatutService(
            DemandeRepository demandeRepository,
            DemandePieceRepository demandePieceRepository,
            StatutDemandeRepository statutDemandeRepository,
            FileStorageService fileStorageService,
            HistoriqueStatutDemandeRepository historiqueStatutDemandeRepository,
            AdministrateurRepository administrateurRepository) {
        this.demandeRepository                  = demandeRepository;
        this.demandePieceRepository             = demandePieceRepository;
        this.statutDemandeRepository            = statutDemandeRepository;
        this.fileStorageService                 = fileStorageService;
        this.historiqueStatutDemandeRepository  = historiqueStatutDemandeRepository;
        this.administrateurRepository           = administrateurRepository;
    }

    // ══════════════════════════════════════════════════════
    // Upload PDF d'une pièce justificative
    // ══════════════════════════════════════════════════════

    @Transactional
    public DemandePiece uploaderFichierPiece(Long demandeId, Long pieceId, MultipartFile file)
            throws IOException {

        Demande demande = getDemandeModifiableOrThrow(demandeId);

        DemandePiece demandePiece = demandePieceRepository
                .findByDemandeIdAndPieceId(demandeId, pieceId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Cette pièce n'est pas associée à la demande #" + demandeId));

        if (demandePiece.isFichierUploaded()) {
            fileStorageService.supprimerFichier(demandePiece.getCheminFichier());
        }

        String cheminRelatif = fileStorageService.storerFichierPiece(
                demandeId, demandePiece.getPiece().getCode(), file);

        demandePiece.setCheminFichier(cheminRelatif);
        return demandePieceRepository.save(demandePiece);
    }

    // ══════════════════════════════════════════════════════
    // Changement de statut + insertion dans l'historique
    // ══════════════════════════════════════════════════════

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
                    "La demande est en statut " + statutActuelCode
                            + " et ne peut plus être modifiée.");
        }

        // Règle 2 : passage en SCAN → toutes les pièces obligatoires doivent être uploadées
        if (CODE_SCAN.equals(nouveauStatutCode)) {
            List<DemandePiece> manquantes =
                    demandePieceRepository.findPiecesObligatoiresSansUpload(demandeId);
            if (!manquantes.isEmpty()) {
                StringBuilder msg = new StringBuilder(
                        "Impossible de passer en statut SCAN : pièces obligatoires manquantes : ");
                for (int i = 0; i < manquantes.size(); i++) {
                    if (i > 0) msg.append(", ");
                    msg.append(manquantes.get(i).getPiece().getLibelle());
                }
                throw new IllegalArgumentException(msg.toString());
            }
        }

        StatutDemande nouveauStatut = statutDemandeRepository.findByCode(nouveauStatutCode);
        if (nouveauStatut == null) {
            throw new IllegalArgumentException("Statut inconnu : " + nouveauStatutCode);
        }

        // ── Mise à jour du statut ──────────────────────────
        demande.setStatut(nouveauStatut);
        Demande saved = demandeRepository.save(demande);

        // ── Insertion dans l'historique ────────────────────
        HistoriqueStatutDemande historique = new HistoriqueStatutDemande();
        historique.setDemande(saved);
        historique.setStatutDemande(nouveauStatut);
        // @PrePersist dans l'entité initialise dateUpdate automatiquement,
        // mais on le force explicitement pour être explicite.
        historique.setDateUpdate(new java.util.Date());
        // Administrateur : on utilise "admin" par défaut (à adapter selon la session)
        historique.setAdministrateur(administrateurRepository.findByLogin("admin"));
        historiqueStatutDemandeRepository.save(historique);

        return saved;
    }

    // ══════════════════════════════════════════════════════
    // Helpers
    // ══════════════════════════════════════════════════════

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

    public boolean estModifiable(Demande demande) {
        if (demande == null || demande.getStatut() == null) return true;
        String code = demande.getStatut().getCode();
        return !CODE_SCAN.equals(code) && !CODE_VALIDE.equals(code) && !CODE_REFUSE.equals(code);
    }

    public List<StatutDemande> getAllStatuts() {
        return statutDemandeRepository.findAll();
    }

    public DemandePiece getPiecePourDemande(Long demandeId, Long pieceId) {
        return demandePieceRepository
                .findByDemandeIdAndPieceId(demandeId, pieceId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Pièce introuvable pour la demande #" + demandeId));
    }
}