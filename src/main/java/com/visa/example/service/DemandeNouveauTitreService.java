package com.visa.example.service;

import java.sql.Date;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.visa.example.dto.NouveauTitreForm;
import com.visa.example.entity.Demande;
import com.visa.example.entity.DemandePiece;
import com.visa.example.entity.Demandeur;
import com.visa.example.entity.Nationalite;
import com.visa.example.entity.Passeport;
import com.visa.example.entity.PieceJustificative;
import com.visa.example.entity.PieceSpecifiqueTypeVisa;
import com.visa.example.entity.SituationFamiliale;
import com.visa.example.entity.StatutDemande;
import com.visa.example.entity.TypeDemande;
import com.visa.example.entity.TypeVisa;
import com.visa.example.entity.VisaTransformable;
import com.visa.example.repository.DemandePieceRepository;
import com.visa.example.repository.DemandeRepository;
import com.visa.example.repository.DemandeurRepository;
import com.visa.example.repository.NationaliteRepository;
import com.visa.example.repository.PasseportRepository;
import com.visa.example.repository.PieceJustificativeRepository;
import com.visa.example.repository.PieceSpecifiqueTypeVisaRepository;
import com.visa.example.repository.SituationFamilialeRepository;
import com.visa.example.repository.StatutDemandeRepository;
import com.visa.example.repository.TypeDemandeRepository;
import com.visa.example.repository.TypeVisaRepository;
import com.visa.example.repository.VisaTransformableRepository;

@Service
public class DemandeNouveauTitreService {

    private static final List<String> TYPE_DEMANDE_CODES = List.of("NT", "DUP", "TRF");
    private static final List<String> STATUT_CODES = List.of("CREE", "EN_COURS", "VALIDE", "REFUSE","SCAN");

    private final DemandeRepository demandeRepository;
    private final DemandeurRepository demandeurRepository;
    private final PasseportRepository passeportRepository;
    private final TypeVisaRepository typeVisaRepository;
    private final TypeDemandeRepository typeDemandeRepository;
    private final StatutDemandeRepository statutDemandeRepository;
    private final NationaliteRepository nationaliteRepository;
    private final SituationFamilialeRepository situationFamilialeRepository;
    private final PieceJustificativeRepository pieceJustificativeRepository;
    private final PieceSpecifiqueTypeVisaRepository pieceSpecifiqueTypeVisaRepository;
    private final DemandePieceRepository demandePieceRepository;
    private final VisaTransformableRepository visaTransformableRepository;

    public DemandeNouveauTitreService(
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
            VisaTransformableRepository visaTransformableRepository
    ) {
        this.demandeRepository = demandeRepository;
        this.demandeurRepository = demandeurRepository;
        this.passeportRepository = passeportRepository;
        this.typeVisaRepository = typeVisaRepository;
        this.typeDemandeRepository = typeDemandeRepository;
        this.statutDemandeRepository = statutDemandeRepository;
        this.nationaliteRepository = nationaliteRepository;
        this.situationFamilialeRepository = situationFamilialeRepository;
        this.pieceJustificativeRepository = pieceJustificativeRepository;
        this.pieceSpecifiqueTypeVisaRepository = pieceSpecifiqueTypeVisaRepository;
        this.demandePieceRepository = demandePieceRepository;
        this.visaTransformableRepository = visaTransformableRepository;
    }

    public List<TypeVisa> getTypeVisas() {
        return typeVisaRepository.findAll();
    }

    public List<Demande> getAllDemandes() {
        List<Demande> demandes = new ArrayList<>(demandeRepository.findAll());
        demandes.sort(
                Comparator.comparing(Demande::getDateDemande, Comparator.nullsLast(Comparator.naturalOrder()))
                        .reversed()
        );
        return demandes;
    }

    public List<VisaTransformable> getVisaTransformablesParPasseport(Long passeportId) {
        return visaTransformableRepository.findByPasseportId(passeportId);
    }

    public Demande getDemandeByIdOrThrow(Long demandeId) {
        return demandeRepository.findById(demandeId)
                .orElseThrow(() -> new IllegalArgumentException("Demande introuvable."));
    }

    public List<PieceJustificative> getPiecesParDemande(Long demandeId) {
        List<DemandePiece> demandePieces = demandePieceRepository.findByDemandeId(demandeId);
        List<PieceJustificative> pieces = new ArrayList<>();
        for (DemandePiece demandePiece : demandePieces) {
            if (demandePiece.getPiece() != null) {
                pieces.add(demandePiece.getPiece());
            }
        }
        return pieces;
    }

    public List<Long> getPieceIdsParDemande(Long demandeId) {
        List<DemandePiece> demandePieces = demandePieceRepository.findByDemandeId(demandeId);
        List<Long> ids = new ArrayList<>();
        for (DemandePiece demandePiece : demandePieces) {
            if (demandePiece.getPiece() != null && demandePiece.getPiece().getId() != null) {
                ids.add(demandePiece.getPiece().getId());
            }
        }
        return ids;
    }

    public List<PieceJustificative> getPiecesAutoriseesParTypeVisa(Long typeVisaId) {
        return getPiecesAutorisees(typeVisaId);
    }

    public List<Nationalite> getNationalites() {
        return nationaliteRepository.findAll();
    }

    public List<SituationFamiliale> getSituationsFamiliales() {
        return situationFamilialeRepository.findAll();
    }

    public List<PieceJustificative> getPiecesCommunes() {
        return pieceJustificativeRepository.findByCommun(true);
    }

    public List<PieceJustificative> getPiecesSpecifiquesParTypeVisa(Long typeVisaId) {
        if (typeVisaId == null) {
            return Collections.emptyList();
        }

        List<PieceSpecifiqueTypeVisa> liens = pieceSpecifiqueTypeVisaRepository.findByTypeVisaId(typeVisaId);
        List<PieceJustificative> pieces = new ArrayList<>();
        for (PieceSpecifiqueTypeVisa lien : liens) {
            if (lien.getPieceJustificative() != null) {
                pieces.add(lien.getPieceJustificative());
            }
        }
        return pieces;
    }

    @Transactional
    public Demande creerDemandeNouveauTitre(NouveauTitreForm form) {
        if (form.getDateExpirationPasseport().isBefore(form.getDateDelivrancePasseport())) {
            throw new IllegalArgumentException("La date d'expiration du passeport doit etre posterieure a la date de delivrance.");
        }

        if (passeportRepository.findByNumero(form.getNumeroPasseport()) != null) {
            throw new IllegalArgumentException("Ce numero de passeport existe deja.");
        }

        TypeVisa typeVisa = typeVisaRepository.findById(form.getTypeVisaId())
                .orElseThrow(() -> new IllegalArgumentException("Type de visa introuvable."));

        TypeDemande typeDemande = resolveTypeDemandeNouveauTitre();
        StatutDemande statutCree = resolveStatutCree();

        Demandeur demandeur = new Demandeur();
        demandeur.setNom(form.getNom().trim());
        demandeur.setPrenom(trimToNull(form.getPrenom()));
        demandeur.setDateNaissance(toSqlDate(form.getDateNaissance()));
        demandeur.setAdresseMada(form.getAdresseMada().trim());
        demandeur.setContact(form.getContact().trim());
        demandeur.setEmail(trimToNull(form.getEmail()));

        if (form.getNationaliteId() != null) {
            Nationalite nationalite = nationaliteRepository.findById(form.getNationaliteId())
                    .orElseThrow(() -> new IllegalArgumentException("Nationalite invalide."));
            demandeur.setNationalite(nationalite);
        }

        if (form.getSituationFamilialeId() != null) {
            SituationFamiliale situationFamiliale = situationFamilialeRepository.findById(form.getSituationFamilialeId())
                    .orElseThrow(() -> new IllegalArgumentException("Situation familiale invalide."));
            demandeur.setSituationFamiliale(situationFamiliale);
        }

        Demandeur demandeurSauvegarde = demandeurRepository.save(demandeur);

        Passeport passeport = new Passeport();
        passeport.setNumero(form.getNumeroPasseport().trim());
        passeport.setDemandeur(demandeurSauvegarde);
        passeport.setDateDelivrance(toSqlDate(form.getDateDelivrancePasseport()));
        passeport.setDateExpiration(toSqlDate(form.getDateExpirationPasseport()));
        Passeport passeportSauvegarde = passeportRepository.save(passeport);

        VisaTransformable visaTransformable = new VisaTransformable();
        visaTransformable.setPasseport(passeportSauvegarde);
        visaTransformable.setNumero(form.getNumeroVisaTransformable().trim());
        visaTransformable.setDateEntreeTerritoire(toSqlDate(form.getDateEntreeTerritoire()));
        visaTransformable.setLieuEntreeTerritoire(form.getLieuEntreeTerritoire().trim());
        if (form.getDateSortieTerritoire() != null) {
            visaTransformable.setDateSortieTerritoire(toSqlDate(form.getDateSortieTerritoire()));
        }
        visaTransformableRepository.save(visaTransformable);

        Demande demande = new Demande();
        demande.setTypeVisa(typeVisa);
        demande.setTypeDemande(typeDemande);
        demande.setStatut(statutCree);
        demande.setVisaTransformable(visaTransformable);
        Demande demandeSauvegardee = demandeRepository.save(demande);

        savePiecesSelectionnees(demandeSauvegardee, typeVisa.getId(), form.getPieceIds());

        return demandeSauvegardee;
    }

    @Transactional
    public Demande modifierDemande(Long demandeId, Long typeVisaId, List<Long> pieceIds) {
        Demande demande = getDemandeByIdOrThrow(demandeId);
        TypeVisa typeVisa = typeVisaRepository.findById(typeVisaId)
                .orElseThrow(() -> new IllegalArgumentException("Type de visa introuvable."));

        demande.setTypeVisa(typeVisa);
        Demande demandeSauvegardee = demandeRepository.save(demande);

        List<DemandePiece> existantes = demandePieceRepository.findByDemandeId(demandeId);
        if (!existantes.isEmpty()) {
            demandePieceRepository.deleteAll(existantes);
        }

        savePiecesSelectionnees(demandeSauvegardee, typeVisa.getId(), pieceIds);

        return demandeSauvegardee;
    }

    private void savePiecesSelectionnees(Demande demande, Long typeVisaId, List<Long> pieceIds) {
        List<PieceJustificative> piecesAutorisees = getPiecesAutorisees(typeVisaId);

        Set<Long> selectedIds = new LinkedHashSet<>();
        if (pieceIds != null) {
            selectedIds.addAll(pieceIds);
        }

        Set<Long> allowedIds = new HashSet<>();
        Map<Long, PieceJustificative> allowedById = new HashMap<>();
        for (PieceJustificative piece : piecesAutorisees) {
            allowedIds.add(piece.getId());
            allowedById.put(piece.getId(), piece);
        }

        for (Long selectedId : selectedIds) {
            if (!allowedIds.contains(selectedId)) {
                throw new IllegalArgumentException("Une piece justificative selectionnee est invalide pour ce type de visa.");
            }
        }

        List<String> manquantes = new ArrayList<>();
        for (PieceJustificative piece : piecesAutorisees) {
            if (Boolean.TRUE.equals(piece.getObligatoire()) && !selectedIds.contains(piece.getId())) {
                manquantes.add(piece.getLibelle());
            }
        }

        if (!manquantes.isEmpty()) {
            throw new IllegalArgumentException("Pieces obligatoires manquantes: " + String.join(", ", manquantes));
        }

        for (Long selectedId : selectedIds) {
            PieceJustificative piece = allowedById.get(selectedId);
            DemandePiece demandePiece = new DemandePiece();
            demandePiece.setDemande(demande);
            demandePiece.setPiece(piece);
            demandePieceRepository.save(demandePiece);
        }
    }

    private List<PieceJustificative> getPiecesAutorisees(Long typeVisaId) {
        Map<Long, PieceJustificative> distinctMap = new HashMap<>();

        for (PieceJustificative piece : getPiecesCommunes()) {
            distinctMap.put(piece.getId(), piece);
        }

        for (PieceJustificative piece : getPiecesSpecifiquesParTypeVisa(typeVisaId)) {
            distinctMap.put(piece.getId(), piece);
        }

        return new ArrayList<>(distinctMap.values());
    }

    private TypeDemande resolveTypeDemandeNouveauTitre() {
        String typeNouveauTitre = TYPE_DEMANDE_CODES.get(0);

        TypeDemande createStatut = typeDemandeRepository.findByCode(typeNouveauTitre);
        if (createStatut != null) {
            return createStatut;
        }
        else {
            throw new IllegalArgumentException("Aucun type de demande configure pour 'nouveau titre' (ou renouvellement).");
        }

    }

    private StatutDemande resolveStatutCree() {
        String createCode = STATUT_CODES.get(0);

        StatutDemande createStatut = statutDemandeRepository.findByCode(createCode);
        if (createStatut != null) {
            return createStatut;
        }
        else {
            throw new IllegalArgumentException("Aucun statut 'cree' n'est configure dans statut_demande.");
        }

    }

    private Date toSqlDate(java.time.LocalDate value) {
        return Date.valueOf(value);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String safeLower(String value) {
        if (value == null) {
            return "";
        }
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "");
        return normalized.toLowerCase(Locale.ROOT);
    }

    public List<DemandePiece> getDemandePiecesParDemande(Long demandeId) {
        return demandePieceRepository.findByDemandeId(demandeId);
    }
}