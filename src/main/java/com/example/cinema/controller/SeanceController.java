package com.example.cinema.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.cinema.model.Seance;
import com.example.cinema.service.FilmService;
import com.example.cinema.service.GenreService;
import com.example.cinema.service.SalleService;
import com.example.cinema.service.SeanceService;
import com.example.cinema.service.BilletService;
import com.example.cinema.service.DiffusionSeanceService;

import java.time.ZoneId;

@Controller
@RequestMapping("/seances")
public class SeanceController {

    private final SeanceService seanceService;
    private final FilmService filmService;
    private final SalleService salleService;
    private final GenreService genreService;
    private final BilletService billetService;
    private final DiffusionSeanceService diffusionSeanceService;

    public SeanceController(SeanceService seanceService,
                            FilmService filmService,
                            SalleService salleService,
                            GenreService genreService,
                            BilletService billetService,
                            DiffusionSeanceService diffusionSeanceService) {
        this.seanceService = seanceService;
        this.filmService = filmService;
        this.salleService = salleService;
        this.genreService = genreService;
        this.billetService = billetService;
        this.diffusionSeanceService = diffusionSeanceService;
    }

    // Liste des séances
    @GetMapping
    public String listSeances(Model model) {
        model.addAttribute("seances", seanceService.findAll());
        return "seances/list";
    }

    @GetMapping("/liste-seances")
    public String listSeances(
            @RequestParam(value = "nomFilm", required = false) String nomFilm,
            @RequestParam(value = "genre", required = false) String genre,
            @RequestParam(value = "dateSeance", required = false) String dateSeance,
            @RequestParam(value = "heure", required = false) String heureStr,
            @RequestParam(value = "comparaison", required = false) String comparaison,
            @RequestParam(value = "salle", required = false) Long idSalle,
            @RequestParam(value = "prixMax", required = false) Double prixMax,
            Model model) {

        List<Seance> seances = seanceService.findAll();

        // Filtre par nom du film
        if (nomFilm != null && !nomFilm.trim().isEmpty()) {
            seances = seances.stream()
                    .filter(s -> s.getFilm().getTitre().toLowerCase().contains(nomFilm.toLowerCase()))
                    .toList();
        }

        // Filtre par genre
        if (genre != null && !genre.trim().isEmpty()) {
            seances = seances.stream()
                    .filter(s -> s.getFilm().getGenre() != null &&
                                 s.getFilm().getGenre().getNomGenre().equalsIgnoreCase(genre))
                    .toList();
        }

        // Filtre par date
        if (dateSeance != null && !dateSeance.trim().isEmpty()) {
            try {
                LocalDate date = LocalDate.parse(dateSeance);
                seances = seances.stream()
                        .filter(s -> s.getDateSeance() != null && s.getDateSeance().equals(date))
                        .toList();
            } catch (DateTimeParseException e) {
                // Invalid date format received — ignore this filter
            }
        }

        // Filtre par heure
        if (heureStr != null && !heureStr.trim().isEmpty() &&
            comparaison != null && !comparaison.trim().isEmpty()) {

            try {
                LocalTime heureSelectionnee = LocalTime.parse(heureStr);

                switch (comparaison.toLowerCase()) {
                    case "avant":
                        seances = seances.stream()
                                .filter(s -> s.getHeureDebut().isBefore(heureSelectionnee))
                                .toList();
                        break;
                    case "apres":
                        seances = seances.stream()
                                .filter(s -> s.getHeureDebut().isAfter(heureSelectionnee))
                                .toList();
                        break;
                    case "exactement":
                        seances = seances.stream()
                                .filter(s -> s.getHeureDebut().equals(heureSelectionnee))
                                .toList();
                        break;
                }
            } catch (DateTimeParseException e) {
                // Invalid time format — ignore this filter
            }
        }

        // Filtre par salle
        if (idSalle != null) {
            seances = seances.stream()
                    .filter(s -> s.getSalle().getIdSalle().equals(idSalle))
                    .toList();
        }

        // Filtre par prix max
        if (prixMax != null) {
            seances = seances.stream()
                    .filter(s -> s.getPrix() <= prixMax)
                    .toList();
        }

        model.addAttribute("seances", seances);
        model.addAttribute("genres", genreService.findAll());
        model.addAttribute("salles", salleService.findAll());

        return "seances/list-seances";
    }

    // Formulaire création
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("seance", new Seance());
        model.addAttribute("films", filmService.findAll());
        model.addAttribute("salles", salleService.findAll());
        return "seances/form";
    }

    // Sauvegarder séance
    @PostMapping("/save")
    public String saveSeance(@ModelAttribute Seance seance) {
        seanceService.save(seance);
        return "redirect:/seances";
    }

    // Formulaire édition
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        model.addAttribute("seance", seanceService.findById(id));
        model.addAttribute("films", filmService.findAll());
        model.addAttribute("salles", salleService.findAll());
        return "seances/form";
    }

    // Supprimer séance
    @GetMapping("/delete/{id}")
    public String deleteSeance(@PathVariable Long id) {
        seanceService.deleteById(id);
        return "redirect:/seances";
    }

    // get seance by id
    @GetMapping("/fiche/{idSeance}") 
    public String ficheSeance(@PathVariable Long idSeance, Model model) {
        Seance seance = seanceService.findById(idSeance);
        model.addAttribute("seance", seance);
        return "/seances/fiche";
    }

    // Chiffre d'affaires basé sur les diffusions planifiées
    @GetMapping("/chiffre-affaires")
    public String afficherChiffreAffaires(
            @RequestParam(value = "dateDebut", required = false) String dateDebutStr,
            @RequestParam(value = "dateFin", required = false) String dateFinStr,
            Model model) {

        LocalDate dateDebut = null;
        LocalDate dateFin = null;
        BigDecimal chiffreAffaires = BigDecimal.ZERO;

        if (dateDebutStr != null && !dateDebutStr.trim().isEmpty() &&
            dateFinStr != null && !dateFinStr.trim().isEmpty()) {
            try {
                dateDebut = LocalDate.parse(dateDebutStr);
                dateFin = LocalDate.parse(dateFinStr);
                // ✅ Utilise le service des diffusions (pas des billets)
                chiffreAffaires = diffusionSeanceService.calculerChiffreAffairesDiffusions(dateDebut, dateFin);
            } catch (Exception e) {
                model.addAttribute("errorMessage", "Dates invalides.");
            }
        }

        if (dateDebut == null) {
            dateDebut = LocalDate.now().withDayOfMonth(1);
        }
        if (dateFin == null) {
            dateFin = LocalDate.now();
        }

        // Conversion en java.util.Date pour JSTL <fmt:formatDate>
        Date dateDebutUtil = Date.from(dateDebut.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date dateFinUtil = Date.from(dateFin.atStartOfDay(ZoneId.systemDefault()).toInstant());

        model.addAttribute("dateDebut", dateDebutUtil);
        model.addAttribute("dateFin", dateFinUtil);
        model.addAttribute("chiffreAffaires", chiffreAffaires);

        return "seances/chiffre-affaires";
    }
}