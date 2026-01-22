package com.example.cinema.service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.cinema.model.Billet;
import com.example.cinema.model.Salle;
import com.example.cinema.model.Seance;
import com.example.cinema.repository.BilletRepository;
import com.example.cinema.repository.SalleRepository;
import com.example.cinema.repository.SeanceRepository;

@Service
public class RevenuService {

    private final BilletRepository billetRepository;
    private final SeanceRepository seanceRepository;
    private final SalleRepository salleRepository;

    // Constantes de tarification
    public static final Double PRIX_STANDARD_ADULTE = 80000.0;
    public static final Double PRIX_STANDARD_ENFANT = 40000.0; // 50% moins cher
    public static final Double PRIX_PREMIUM_ADULTE = 140000.0;
    public static final Double PRIX_PREMIUM_ENFANT = 70000.0; // 50% moins cher
    public static final Double PRIX_VIP_ADULTE = 180000.0;
    public static final Double PRIX_VIP_ENFANT = 90000.0; // 50% moins cher

    public RevenuService(BilletRepository billetRepository, SeanceRepository seanceRepository, SalleRepository salleRepository) {
        this.billetRepository = billetRepository;
        this.seanceRepository = seanceRepository;
        this.salleRepository = salleRepository;
    }

    /**
     * Calcule le chiffre d'affaires réel généré par une salle pour une séance donnée
     * en prenant en compte les billets vendus et les réductions enfants
     */
    public Double calculerRevenuSeance(Long idSeance) {
        Seance seance = seanceRepository.findById(idSeance)
                .orElseThrow(() -> new RuntimeException("Séance non trouvée"));

        List<Billet> billets = billetRepository.findBySeance(seance);

        return billets.stream()
                .mapToDouble(Billet::getPrix)
                .sum();
    }

    /**
     * Calcule le chiffre d'affaires réel pour une salle et une date donnée
     */
    public Double calculerRevenuSalleParDate(Long idSalle, LocalDate date) {
        Salle salle = salleRepository.findById(idSalle)
                .orElseThrow(() -> new RuntimeException("Salle non trouvée"));

        List<Seance> seances = seanceRepository.findBySalleAndDateSeance(salle, date);

        return seances.stream()
                .mapToDouble(seance -> calculerRevenuSeance(seance.getIdSeance()))
                .sum();
    }

    /**
     * Calcule le chiffre d'affaires réel pour une salle entre deux dates
     */
    public Double calculerRevenuSallePeriode(Long idSalle, LocalDate dateDebut, LocalDate dateFin) {
        Salle salle = salleRepository.findById(idSalle)
                .orElseThrow(() -> new RuntimeException("Salle non trouvée"));

        List<Seance> seances = seanceRepository.findBySalleAndDateSeanceBetween(salle, dateDebut, dateFin);

        return seances.stream()
                .mapToDouble(seance -> calculerRevenuSeance(seance.getIdSeance()))
                .sum();
    }

    /**
     * Calcule le prix d'un billet en fonction du type de place et du type de billet
     * Applique 50% de réduction pour les enfants sur tous les types de places
     */
    public Double calculerPrixBillet(String typePlaceLibelle, Boolean isEnfant) {
        if ("Standard".equalsIgnoreCase(typePlaceLibelle)) {
            return isEnfant ? PRIX_STANDARD_ENFANT : PRIX_STANDARD_ADULTE;
        } else if ("Premium".equalsIgnoreCase(typePlaceLibelle)) {
            return isEnfant ? PRIX_PREMIUM_ENFANT : PRIX_PREMIUM_ADULTE;
        } else if ("VIP".equalsIgnoreCase(typePlaceLibelle)) {
            return isEnfant ? PRIX_VIP_ENFANT : PRIX_VIP_ADULTE;
        } else if ("PMR".equalsIgnoreCase(typePlaceLibelle)) {
            return isEnfant ? (PRIX_STANDARD_ADULTE / 2) : PRIX_STANDARD_ADULTE;
        }
        return PRIX_STANDARD_ADULTE;
    }

    /**
     * Obtient le détail du revenu d'une séance avec breakdown par type de place
     */
    public Map<String, Object> obtenirDetailRevenuSeance(Long idSeance) {
        Seance seance = seanceRepository.findById(idSeance)
                .orElseThrow(() -> new RuntimeException("Séance non trouvée"));

        List<Billet> billets = billetRepository.findBySeance(seance);

        Map<String, Object> detail = new HashMap<>();
        detail.put("idSeance", idSeance);
        detail.put("film", seance.getFilm().getTitre());
        detail.put("salle", seance.getSalle().getNomSalle());
        detail.put("dateSeance", seance.getDateSeance());
        detail.put("heureDebut", seance.getHeureDebut());

        // Breakdown par type de place
        double revenuStandard = billets.stream()
                .filter(b -> "Standard".equalsIgnoreCase(b.getPlace().getTypePlace().getLibelle()))
                .mapToDouble(Billet::getPrix)
                .sum();

        double revenuPremium = billets.stream()
                .filter(b -> "Premium".equalsIgnoreCase(b.getPlace().getTypePlace().getLibelle()))
                .mapToDouble(Billet::getPrix)
                .sum();

        // Breakdown par type de billet
        long nombreAdultes = billets.stream()
                .filter(b -> b.getTypeBillet() != null && !b.getTypeBillet().getIsEnfant())
                .count();

        long nombreEnfants = billets.stream()
                .filter(b -> b.getTypeBillet() != null && b.getTypeBillet().getIsEnfant())
                .count();

        detail.put("revenuStandard", revenuStandard);
        detail.put("revenuPremium", revenuPremium);
        detail.put("revenuTotal", revenuStandard + revenuPremium);
        detail.put("nombreBillets", billets.size());
        detail.put("nombreAdultes", nombreAdultes);
        detail.put("nombreEnfants", nombreEnfants);

        return detail;
    }

    /**
     * Obtient le détail du revenu d'une salle pour une date donnée
     */
    public Map<String, Object> obtenirDetailRevenuSalleParDate(Long idSalle, LocalDate date) {
        Salle salle = salleRepository.findById(idSalle)
                .orElseThrow(() -> new RuntimeException("Salle non trouvée"));

        List<Seance> seances = seanceRepository.findBySalleAndDateSeance(salle, date);

        Map<String, Object> detail = new HashMap<>();
        detail.put("idSalle", idSalle);
        detail.put("nomSalle", salle.getNomSalle());
        detail.put("date", date);

        double revenuTotal = 0;
        long totalBillets = 0;
        long totalEnfants = 0;

        List<Map<String, Object>> seancesDetail = new java.util.ArrayList<>();

        for (Seance seance : seances) {
            Map<String, Object> seanceDetail = obtenirDetailRevenuSeance(seance.getIdSeance());
            seancesDetail.add(seanceDetail);

            revenuTotal += (double) seanceDetail.get("revenuTotal");
            totalBillets += (long) seanceDetail.get("nombreBillets");
            totalEnfants += (long) seanceDetail.get("nombreEnfants");
        }

        detail.put("seances", seancesDetail);
        detail.put("revenuTotal", revenuTotal);
        detail.put("totalBillets", totalBillets);
        detail.put("totalEnfants", totalEnfants);

        return detail;
    }
}
