package com.visa.example.service;

import com.visa.example.dto.DuplicataTransfertAvecAnterieurForm;
import com.visa.example.dto.DuplicataTransfertSansAnterieurForm;
import com.visa.example.entity.*;
import com.visa.example.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class DuplicataTransfertService {

    // ── Codes métier ───────────────────────────────────────
    private static final String CODE_NT    = "NT";
    private static final String CODE_DUP   = "DUP";
    private static final String CODE_TRF   = "TRF";
    private static final String CODE_CREE  = "CREE";
    private static final String CODE_VALIDE = "VALIDE";

    // ── Repositories ───────────────────────────────────────
    private final CarteResidentRepository    carteResidentRepository;
    private final VisaRepository             visaRepository;
    private final DemandeRepository          demandeRepository;
    private final DemandeurRepository        demandeurRepository;
    private final PasseportRepository        passeportRepository;
    private final TypeVisaRepository         typeVisaRepository;
    private final TypeDemandeRepository      typeDemandeRepository;
    private final StatutDemandeRepository    statutDemandeRepository;
    private final NationaliteRepository      nationaliteRepository;
    private final SituationFamilialeRepository situationFamilialeRepository;
    private final PieceJustificativeRepository pieceJustificativeRepository;
    private final PieceSpecifiqueTypeVisaRepository pieceSpecifiqueTypeVisaRepository;
    private final DemandePieceRepository     demandePieceRepository;
    private final VisaTransformableRepository visaTransformableRepository;
    private final AdministrateurRepository administrateurRepository;
    private final HistoriqueStatutDemandeRepository  historiqueStatutDemandeRepository;

    public DuplicataTransfertService(
            CarteResidentRepository carteResidentRepository,
            VisaRepository visaRepository,
            DemandeRepository demandeRepository,
            DemandeurRepository demandeurRepository,
            PasseportRepository passeportRepository,
            TypeVisaRepository typeVisaRepository,
            TypeDemandeRepository typeDemandeRepository,
            StatutDemandeRepository statutDemandeRepository,
            NationaliteRepository nationaliteRepository,
            SituationFamilialeRepository situationFamilialeRepository,
            PieceJustificativeRepository pieceJustificativeRepository,
            PieceSpecifiqueTypeVisaRepository pieceSpecifiqueTypeVisaRepository,
            DemandePieceRepository demandePieceRepository,
            VisaTransformableRepository visaTransformableRepository, AdministrateurRepository administrateurRepository, HistoriqueStatutDemandeRepository historiqueStatutDemandeRepository
    ) {
        this.carteResidentRepository         = carteResidentRepository;
        this.visaRepository                  = visaRepository;
        this.demandeRepository               = demandeRepository;
        this.demandeurRepository             = demandeurRepository;
        this.passeportRepository             = passeportRepository;
        this.typeVisaRepository              = typeVisaRepository;
        this.typeDemandeRepository           = typeDemandeRepository;
        this.statutDemandeRepository         = statutDemandeRepository;
        this.nationaliteRepository           = nationaliteRepository;
        this.situationFamilialeRepository    = situationFamilialeRepository;
        this.pieceJustificativeRepository    = pieceJustificativeRepository;
        this.pieceSpecifiqueTypeVisaRepository = pieceSpecifiqueTypeVisaRepository;
        this.demandePieceRepository          = demandePieceRepository;
        this.visaTransformableRepository     = visaTransformableRepository;
        this.administrateurRepository = administrateurRepository;
        this.historiqueStatutDemandeRepository = historiqueStatutDemandeRepository;
    }

    // ══════════════════════════════════════════════════════
    // CAS 1 : avec données antérieures (recherche par N° carte résident)
    // ══════════════════════════════════════════════════════

    /**
     * Recherche le demandeur associé à une carte résident.
     * Retourne null si introuvable (pour affichage côté JSP via AJAX).
     */
    public CarteResident findCarteResidentByNumero(String numero) {
        return carteResidentRepository.findByNumeroCarteResident(numero);
    }

    /**
     * Crée une demande de type DUP ou TRF à partir d'une carte résident existante.
     * La nouvelle demande hérite du type de visa de la demande source.
     * Statut : CREE.
     */
    @Transactional
    public Demande creerDemandeAvecDonneesAnterieures(DuplicataTransfertAvecAnterieurForm form) {
        CarteResident carte = carteResidentRepository
                .findByNumeroCarteResident(form.getNumeroCarteResident().trim());
        if (carte == null) {
            throw new IllegalArgumentException(
                    "Aucune carte résident trouvée pour le numéro : " + form.getNumeroCarteResident());
        }

        Demande demandeSource = carte.getDemande();
        TypeVisa typeVisa     = demandeSource.getTypeVisa();
        TypeDemande typeDemande = resolveTypeDemande(form.getTypeDemande());
        StatutDemande statutCree = resolveStatut(CODE_CREE);

        Demande nouvelleDemande = new Demande();
        nouvelleDemande.setTypeVisa(typeVisa);
        nouvelleDemande.setTypeDemande(typeDemande);
        nouvelleDemande.setStatut(statutCree);
        nouvelleDemande.setVisaTransformable(demandeSource.getVisaTransformable());
        // Pas de visaTransformable pour un duplicata/transfert avec données antérieures

        Demande sauvegardee = demandeRepository.save(nouvelleDemande);

        // Copier les pièces justificatives de la demande source
        List<DemandePiece> piecesSource = demandePieceRepository.findByDemandeId(demandeSource.getId());
        for (DemandePiece dp : piecesSource) {
            if (dp.getPiece() != null) {
                DemandePiece nouvellePiece = new DemandePiece();
                nouvellePiece.setDemande(sauvegardee);
                nouvellePiece.setPiece(dp.getPiece());
                demandePieceRepository.save(nouvellePiece);
            }
        }

        return sauvegardee;
    }

    // ══════════════════════════════════════════════════════
    // CAS 2 : sans données antérieures (formulaire complet)
    // ══════════════════════════════════════════════════════

    /**
     * Crée deux demandes :
     *   1. Demande NT  → statut VALIDE  + Visa + CarteResident
     *   2. Demande DUP ou TRF → statut CREE
     *
     * @return tableau [demandeNT, demandeDupOuTrf]
     */
    @Transactional
    public Demande[] creerDemandeSansDonneesAnterieures(DuplicataTransfertSansAnterieurForm form) {

        // ── Validations ───────────────────────────────────
        if (form.getDateExpirationPasseport().isBefore(form.getDateDelivrancePasseport())) {
            throw new IllegalArgumentException(
                    "La date d'expiration du passeport doit être postérieure à la date de délivrance.");
        }
        if (form.getDateFinVisa().isBefore(form.getDateDebutVisa())) {
            throw new IllegalArgumentException(
                    "La date de fin du visa doit être postérieure à la date de début.");
        }
        if (form.getDateFinCarteResident().isBefore(form.getDateDebutCarteResident())) {
            throw new IllegalArgumentException(
                    "La date de fin de la carte résident doit être postérieure à la date de début.");
        }
        if (passeportRepository.findByNumero(form.getNumeroPasseport()) != null) {
            throw new IllegalArgumentException("Ce numéro de passeport existe déjà.");
        }
        if (visaRepository.findByNumeroVisa(form.getNumeroVisa()) != null) {
            throw new IllegalArgumentException("Ce numéro de visa existe déjà.");
        }
        if (carteResidentRepository.findByNumeroCarteResident(form.getNumeroCarteResident()) != null) {
            throw new IllegalArgumentException("Ce numéro de carte résident existe déjà.");
        }

        // ── Références partagées ──────────────────────────
        TypeVisa typeVisa          = typeVisaRepository.findById(form.getTypeVisaId())
                .orElseThrow(() -> new IllegalArgumentException("Type de visa introuvable."));
        TypeDemande typeNT         = resolveTypeDemande(CODE_NT);
        TypeDemande typeDupOuTrf   = resolveTypeDemande(form.getTypeDemande());
        StatutDemande statutValide = resolveStatut(CODE_VALIDE);
        StatutDemande statutCree   = resolveStatut(CODE_CREE);

        // ── Demandeur ─────────────────────────────────────
        Demandeur demandeur = new Demandeur();
        demandeur.setNom(form.getNom().trim());
        demandeur.setPrenom(trimToNull(form.getPrenom()));
        demandeur.setDateNaissance(toSqlDate(form.getDateNaissance()));
        demandeur.setAdresseMada(form.getAdresseMada().trim());
        demandeur.setContact(form.getContact().trim());
        demandeur.setEmail(trimToNull(form.getEmail()));

        if (form.getNationaliteId() != null) {
            demandeur.setNationalite(
                    nationaliteRepository.findById(form.getNationaliteId())
                            .orElseThrow(() -> new IllegalArgumentException("Nationalité invalide.")));
        }
        if (form.getSituationFamilialeId() != null) {
            demandeur.setSituationFamiliale(
                    situationFamilialeRepository.findById(form.getSituationFamilialeId())
                            .orElseThrow(() -> new IllegalArgumentException("Situation familiale invalide.")));
        }
        Demandeur demandeurSauvegarde = demandeurRepository.save(demandeur);

        // ── Passeport ─────────────────────────────────────
        Passeport passeport = new Passeport();
        passeport.setNumero(form.getNumeroPasseport().trim());
        passeport.setDemandeur(demandeurSauvegarde);
        passeport.setDateDelivrance(toSqlDate(form.getDateDelivrancePasseport()));
        passeport.setDateExpiration(toSqlDate(form.getDateExpirationPasseport()));
        Passeport passeportSauvegarde = passeportRepository.save(passeport);

        // ── Visa transformable ────────────────────────────
        VisaTransformable visaTransformable = new VisaTransformable();
        visaTransformable.setPasseport(passeportSauvegarde);
        visaTransformable.setNumero(form.getNumeroVisaTransformable().trim());
        visaTransformable.setDateEntreeTerritoire(toSqlDate(form.getDateEntreeTerritoire()));
        visaTransformable.setLieuEntreeTerritoire(form.getLieuEntreeTerritoire().trim());
        if (form.getDateSortieTerritoire() != null) {
            visaTransformable.setDateSortieTerritoire(toSqlDate(form.getDateSortieTerritoire()));
        }
        visaTransformableRepository.save(visaTransformable);

        // ─────────────────────────────────────────────────
        // DEMANDE 1 : Nouveau Titre → VALIDE
        // ─────────────────────────────────────────────────
        Demande demandeNT = new Demande();
        demandeNT.setTypeVisa(typeVisa);
        demandeNT.setTypeDemande(typeNT);
        demandeNT.setStatut(statutValide);
        demandeNT.setVisaTransformable(visaTransformable);
        Demande demandeNTSauvegardee = demandeRepository.save(demandeNT);

        HistoriqueStatutDemande historique = new HistoriqueStatutDemande();
        historique.setDemande(demandeNTSauvegardee);
        historique.setStatutDemande(statutValide);
        // @PrePersist dans l'entité initialise dateUpdate automatiquement,
        // mais on le force explicitement pour être explicite.
        historique.setDateUpdate(new java.util.Date());
        // Administrateur : on utilise "admin" par défaut (à adapter selon la session)
        historique.setAdministrateur(administrateurRepository.findByLogin("admin"));
        historiqueStatutDemandeRepository.save(historique);

        savePiecesSelectionnees(demandeNTSauvegardee, typeVisa.getId(), form.getPieceIds());

        // Visa lié à la demande NT
        Visa visa = new Visa();
        visa.setDemande(demandeNTSauvegardee);
        visa.setNumeroVisa(form.getNumeroVisa().trim());
        visa.setDateDelivrance(toSqlDate(LocalDate.now()));
        visa.setDateDebut(toSqlDate(form.getDateDebutVisa()));
        visa.setDateFin(toSqlDate(form.getDateFinVisa()));
        visaRepository.save(visa);

        // CarteResident liée à la demande NT
        CarteResident carteResident = new CarteResident();
        carteResident.setDemande(demandeNTSauvegardee);
        carteResident.setNumeroCarteResident(form.getNumeroCarteResident().trim());
        carteResident.setDateDelivrance(toSqlDate(LocalDate.now()));
        carteResident.setDateDebut(toSqlDate(form.getDateDebutCarteResident()));
        carteResident.setDateFin(toSqlDate(form.getDateFinCarteResident()));
        carteResidentRepository.save(carteResident);

        // ─────────────────────────────────────────────────
        // DEMANDE 2 : DUP ou TRF → CREE
        // ─────────────────────────────────────────────────
        Demande demandeDupOuTrf = new Demande();
        demandeDupOuTrf.setTypeVisa(typeVisa);
        demandeDupOuTrf.setTypeDemande(typeDupOuTrf);
        demandeDupOuTrf.setStatut(statutCree);
        // Référence le même visa transformable
        demandeDupOuTrf.setVisaTransformable(visaTransformable);
        Demande demandeDupOuTrfSauvegardee = demandeRepository.save(demandeDupOuTrf);

        HistoriqueStatutDemande historique2 = new HistoriqueStatutDemande();
        historique2.setDemande(demandeDupOuTrfSauvegardee);
        historique2.setStatutDemande(statutCree);
        // @PrePersist dans l'entité initialise dateUpdate automatiquement,
        // mais on le force explicitement pour être explicite.
        historique2.setDateUpdate(new java.util.Date());
        // Administrateur : on utilise "admin" par défaut (à adapter selon la session)
        historique2.setAdministrateur(administrateurRepository.findByLogin("admin"));
        historiqueStatutDemandeRepository.save(historique2);

        savePiecesSelectionnees(demandeDupOuTrfSauvegardee, typeVisa.getId(), form.getPieceIds());

        return new Demande[]{ demandeNTSauvegardee, demandeDupOuTrfSauvegardee };
    }

    // ══════════════════════════════════════════════════════
    // Méthodes utilitaires publiques (pour alimenter les vues)
    // ══════════════════════════════════════════════════════

    public List<com.visa.example.entity.TypeVisa> getTypeVisas() {
        return typeVisaRepository.findAll();
    }

    public List<com.visa.example.entity.Nationalite> getNationalites() {
        return nationaliteRepository.findAll();
    }

    public List<com.visa.example.entity.SituationFamiliale> getSituationsFamiliales() {
        return situationFamilialeRepository.findAll();
    }

    public List<PieceJustificative> getPiecesCommunes() {
        return pieceJustificativeRepository.findByCommun(true);
    }

    public List<PieceJustificative> getPiecesSpecifiquesParTypeVisa(Long typeVisaId) {
        if (typeVisaId == null) return List.of();
        List<PieceSpecifiqueTypeVisa> liens = pieceSpecifiqueTypeVisaRepository.findByTypeVisaId(typeVisaId);
        List<PieceJustificative> pieces = new ArrayList<>();
        for (PieceSpecifiqueTypeVisa lien : liens) {
            if (lien.getPieceJustificative() != null) pieces.add(lien.getPieceJustificative());
        }
        return pieces;
    }

    // ══════════════════════════════════════════════════════
    // Méthodes privées
    // ══════════════════════════════════════════════════════

    private void savePiecesSelectionnees(Demande demande, Long typeVisaId, List<Long> pieceIds) {
        List<PieceJustificative> piecesAutorisees = getPiecesAutorisees(typeVisaId);

        Set<Long> selectedIds = new LinkedHashSet<>();
        if (pieceIds != null) selectedIds.addAll(pieceIds);

        Set<Long> allowedIds = new HashSet<>();
        Map<Long, PieceJustificative> allowedById = new HashMap<>();
        for (PieceJustificative p : piecesAutorisees) {
            allowedIds.add(p.getId());
            allowedById.put(p.getId(), p);
        }

        for (Long id : selectedIds) {
            if (!allowedIds.contains(id)) {
                throw new IllegalArgumentException(
                        "Une pièce justificative sélectionnée est invalide pour ce type de visa.");
            }
        }

        List<String> manquantes = new ArrayList<>();
        for (PieceJustificative p : piecesAutorisees) {
            if (Boolean.TRUE.equals(p.getObligatoire()) && !selectedIds.contains(p.getId())) {
                manquantes.add(p.getLibelle());
            }
        }
        if (!manquantes.isEmpty()) {
            throw new IllegalArgumentException(
                    "Pièces obligatoires manquantes : " + String.join(", ", manquantes));
        }

        for (Long id : selectedIds) {
            DemandePiece dp = new DemandePiece();
            dp.setDemande(demande);
            dp.setPiece(allowedById.get(id));
            demandePieceRepository.save(dp);
        }
    }

    private List<PieceJustificative> getPiecesAutorisees(Long typeVisaId) {
        Map<Long, PieceJustificative> map = new HashMap<>();
        for (PieceJustificative p : getPiecesCommunes())                    map.put(p.getId(), p);
        for (PieceJustificative p : getPiecesSpecifiquesParTypeVisa(typeVisaId)) map.put(p.getId(), p);
        return new ArrayList<>(map.values());
    }

    private TypeDemande resolveTypeDemande(String code) {
        TypeDemande td = typeDemandeRepository.findByCode(code);
        if (td == null) throw new IllegalArgumentException("Type de demande introuvable pour le code : " + code);
        return td;
    }

    private StatutDemande resolveStatut(String code) {
        StatutDemande sd = statutDemandeRepository.findByCode(code);
        if (sd == null) throw new IllegalArgumentException("Statut introuvable pour le code : " + code);
        return sd;
    }

    private Date toSqlDate(LocalDate value) {
        return Date.valueOf(value);
    }

    private String trimToNull(String value) {
        if (value == null) return null;
        String t = value.trim();
        return t.isEmpty() ? null : t;
    }
}