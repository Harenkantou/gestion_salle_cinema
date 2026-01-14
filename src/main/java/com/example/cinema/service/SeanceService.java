package com.example.cinema.service;


import java.util.List;

import org.springframework.stereotype.Service;

import com.example.cinema.model.Seance;
import com.example.cinema.repository.SeanceRepository;

@Service
public class SeanceService {

    private final SeanceRepository seanceRepository;

    public SeanceService(SeanceRepository seanceRepository) {
        this.seanceRepository = seanceRepository;
    }

    public List<Seance> findAll() {
        return seanceRepository.findAll();
    }

    public Seance save(Seance seance) {
        // Règle métier : pas deux séances dans la même salle à la même date/heure
        seanceRepository.findBySalleAndDateSeanceAndHeureDebut(
                seance.getSalle(),
                seance.getDateSeance(),
                seance.getHeureDebut()
        ).ifPresent(s -> {
            throw new RuntimeException("Une séance existe déjà dans cette salle à cette date et heure.");
        });

        // Règle mineure : film doit être actif
        if (!"ACTIF".equals(seance.getFilm().getStatut())) {
            throw new RuntimeException("Impossible de programmer une séance pour un film inactif.");
        }

        // Règle mineure : salle doit être disponible
        if (!seance.getSalle().getStatut()) {
            throw new RuntimeException("Impossible de programmer une séance dans une salle indisponible.");
        }

        // Règle mineure : prix > 0
        if (seance.getPrix() <= 0) {
            throw new RuntimeException("Le prix de la séance doit être supérieur à 0.");
        }

        return seanceRepository.save(seance);
    }

    public Seance findById(Long id) {
        return seanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Séance non trouvée"));
    }

    public void deleteById(Long id) {
        seanceRepository.deleteById(id);
    }
}
