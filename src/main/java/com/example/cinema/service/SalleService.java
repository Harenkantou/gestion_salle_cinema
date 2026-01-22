package com.example.cinema.service;


import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.cinema.model.Salle;
import com.example.cinema.repository.SalleRepository;

@Service
public class SalleService {

    private final SalleRepository salleRepository;

    public SalleService(SalleRepository salleRepository) {
        this.salleRepository = salleRepository;
    }

    public List<Salle> findAll() {
        return salleRepository.findAll();
    }

    public Salle findById(Long id) {
        return salleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Salle non trouvée"));
    }

    public Salle save(Salle salle) {
        return salleRepository.save(salle);
    }

    public void deleteById(Long id) {
        salleRepository.deleteById(id);
    }

    /**
     * Calcule le revenu maximum qu'une salle peut générer pour une diffusion
     * = somme des prix de toutes les places (premium + standard)
     */
    public Double calculerRevenuMaximum(Long idSalle) {
        Salle salle = findById(idSalle);
        
        return salle.getPlaces().stream()
                .mapToDouble(place -> place.getTypePlace().getPrix())
                .sum();
    }

    /**
     * Retourne le détail du revenu par type de place
     */
    public Map<String, Object> obtenirDetailRevenu(Long idSalle) {
        Salle salle = findById(idSalle);

        Map<String, Long> nombrePlacesParType = salle.getPlaces().stream()
                .collect(Collectors.groupingBy(
                        place -> place.getTypePlace().getLibelle(),
                        Collectors.counting()
                ));

        Map<String, Double> prixParType = salle.getPlaces().stream()
                .collect(Collectors.toMap(
                        place -> place.getTypePlace().getLibelle(),
                        place -> place.getTypePlace().getPrix(),
                        (prix1, prix2) -> prix1  // garder le premier prix si doublon
                ));

        Map<String, Double> revenuParType = nombrePlacesParType.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> entry.getValue() * prixParType.get(entry.getKey())
                ));

        Double revenuTotal = revenuParType.values().stream()
                .mapToDouble(Double::doubleValue)
                .sum();

        return Map.of(
                "salle", salle,
                "nombrePlacesParType", nombrePlacesParType,
                "prixParType", prixParType,
                "revenuParType", revenuParType,
                "revenuTotal", revenuTotal,
                "capaciteTotal", salle.getPlaces().size()
        );
    }
}
