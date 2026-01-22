package com.example.cinema.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.cinema.model.Billet;
import com.example.cinema.model.Client;
import com.example.cinema.model.Place;
import com.example.cinema.model.Seance;
import com.example.cinema.model.TypeBillet;
import com.example.cinema.repository.BilletRepository;

@Service
public class BilletService {

    private final BilletRepository billetRepository;
    private final TypeBilletService typeBilletService;

    public BilletService(BilletRepository billetRepository, TypeBilletService typeBilletService) {
        this.billetRepository = billetRepository; // ✅ Correction ici
        this.typeBilletService = typeBilletService;
    }

    public List<Billet> findAll() {
        return billetRepository.findAll();
    }

    public Billet save(Billet billet) {
        return billetRepository.save(billet);
    }

    public Billet findById(Long id) {
        return billetRepository.findById(id).orElseThrow(() -> new RuntimeException("Billet non trouvé"));
    }

    public void deleteById(Long id) {
        billetRepository.deleteById(id);
    }

    public List<Billet> findByClient(Client client) {
        return billetRepository.findByClient(client);
    }

    public List<Billet> findBySeance(Seance seance) {
        return billetRepository.findBySeance(seance);
    }

    public boolean isPlaceReserved(Seance seance, Place place) {
        return billetRepository.findBySeanceAndPlace(seance, place).isPresent();
    }

    public Billet creerBillet(Client client, Seance seance, Place place, TypeBillet typeBillet) {
        if (isPlaceReserved(seance, place)) {
            throw new RuntimeException("Cette place est déjà réservée pour cette séance");
        }

        Double prix = calculerPrixBillet(place.getTypePlace().getLibelle(), typeBillet.getIsEnfant());

        Billet billet = new Billet();
        billet.setClient(client);
        billet.setSeance(seance);
        billet.setPlace(place);
        billet.setTypeBillet(typeBillet);
        billet.setPrix(prix);
        billet.setIdStatutBillet(1);

        return save(billet);
    }

    public Billet creerBilletAdulte(Client client, Seance seance, Place place) {
        TypeBillet typeAdulte = typeBilletService.getTypeBilletAdulte();
        return creerBillet(client, seance, place, typeAdulte);
    }

    public Billet creerBilletEnfant(Client client, Seance seance, Place place) {
        TypeBillet typeEnfant = typeBilletService.getTypeBilletEnfant();
        return creerBillet(client, seance, place, typeEnfant);
    }

    public Double calculerPrixBillet(String typePlaceLibelle, Boolean isEnfant) {
        if ("Standard".equalsIgnoreCase(typePlaceLibelle)) {
            return isEnfant ? 40000.0 : 80000.0;
        } else if ("Premium".equalsIgnoreCase(typePlaceLibelle)) {
            return isEnfant ? 70000.0 : 140000.0;
        } else if ("VIP".equalsIgnoreCase(typePlaceLibelle)) {
            return isEnfant ? 90000.0 : 180000.0;
        } else if ("PMR".equalsIgnoreCase(typePlaceLibelle)) {
            return isEnfant ? 10000.0 : 20000.0;
        }
        return 20000.0;
    }

    // ✅ MÉTHODE AJOUTÉE SANS @Override
    public BigDecimal calculerChiffreAffairesEntreDates(LocalDate dateDebut, LocalDate dateFin) {
        return billetRepository.sumPrixByDateAchatBetween(
            dateDebut.atStartOfDay(),
            dateFin.plusDays(1).atStartOfDay()
        );
    }
}