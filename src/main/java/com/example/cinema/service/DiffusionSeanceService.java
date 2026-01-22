// src/main/java/com/example/cinema/service/DiffusionSeanceService.java
package com.example.cinema.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import org.springframework.stereotype.Service;
import com.example.cinema.repository.DiffusionSeanceRepository;

@Service
public class DiffusionSeanceService {
    private final DiffusionSeanceRepository diffusionSeanceRepository;

    public DiffusionSeanceService(DiffusionSeanceRepository diffusionSeanceRepository) {
        this.diffusionSeanceRepository = diffusionSeanceRepository;
    }

    public BigDecimal calculerChiffreAffairesDiffusions(LocalDate dateDebut, LocalDate dateFin) {
        return diffusionSeanceRepository.sumPrixByDateDiffusionBetween(dateDebut, dateFin);
    }
}