package com.example.cinema.controller;

import java.time.LocalDate;
import java.util.Map;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.cinema.dto.RevenuDTO;
import com.example.cinema.service.RevenuService;

@RestController
@RequestMapping("/api/revenu")
public class RevenuController {

    private final RevenuService revenuService;

    public RevenuController(RevenuService revenuService) {
        this.revenuService = revenuService;
    }

    /**
     * Calcule le chiffre d'affaires réel généré par une séance
     * GET /api/revenu/seance/{idSeance}
     */
    @GetMapping("/seance/{idSeance}")
    public ResponseEntity<RevenuDTO> calculerRevenuSeance(@PathVariable Long idSeance) {
        try {
            Double revenu = revenuService.calculerRevenuSeance(idSeance);
            Map<String, Object> detail = revenuService.obtenirDetailRevenuSeance(idSeance);
            return ResponseEntity.ok(new RevenuDTO(revenu, detail));
        } catch (Exception e) {
            return ResponseEntity.ok(new RevenuDTO(e.getMessage()));
        }
    }

    /**
     * Calcule le chiffre d'affaires d'une salle pour une date donnée
     * GET /api/revenu/salle/{idSalle}/date/{date}
     */
    @GetMapping("/salle/{idSalle}/date/{date}")
    public ResponseEntity<RevenuDTO> calculerRevenuSalleParDate(
            @PathVariable Long idSalle,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            Double revenu = revenuService.calculerRevenuSalleParDate(idSalle, date);
            Map<String, Object> detail = revenuService.obtenirDetailRevenuSalleParDate(idSalle, date);
            return ResponseEntity.ok(new RevenuDTO(revenu, detail));
        } catch (Exception e) {
            return ResponseEntity.ok(new RevenuDTO(e.getMessage()));
        }
    }

    /**
     * Calcule le chiffre d'affaires d'une salle sur une période
     * GET /api/revenu/salle/{idSalle}/periode?dateDebut=2026-01-10&dateFin=2026-01-15
     */
    @GetMapping("/salle/{idSalle}/periode")
    public ResponseEntity<RevenuDTO> calculerRevenuSallePeriode(
            @PathVariable Long idSalle,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin) {
        try {
            Double revenu = revenuService.calculerRevenuSallePeriode(idSalle, dateDebut, dateFin);
            return ResponseEntity.ok(new RevenuDTO(revenu, null));
        } catch (Exception e) {
            return ResponseEntity.ok(new RevenuDTO(e.getMessage()));
        }
    }

    /**
     * Calcule le prix d'un billet selon le type de place et le type de billet
     * GET /api/revenu/prix?typePlaceLibelle=Standard&isEnfant=true
     */
    @GetMapping("/prix")
    public ResponseEntity<Map<String, Object>> calculerPrix(
            @RequestParam String typePlaceLibelle,
            @RequestParam Boolean isEnfant) {
        try {
            Double prix = revenuService.calculerPrixBillet(typePlaceLibelle, isEnfant);
            return ResponseEntity.ok(Map.of(
                    "typePlaceLibelle", typePlaceLibelle,
                    "isEnfant", isEnfant,
                    "prix", prix
            ));
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of("error", e.getMessage()));
        }
    }
}
