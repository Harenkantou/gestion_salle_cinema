package com.example.cinema.controller;

import java.time.LocalTime;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.example.cinema.model.Seance;
import com.example.cinema.model.Film;
import com.example.cinema.model.Salle;
import com.example.cinema.service.SeanceService;
import com.example.cinema.service.FilmService;
import com.example.cinema.service.SalleService;
import com.example.cinema.service.GenreService; 


@Controller
@RequestMapping("/seances")
public class SeanceController {

    private final SeanceService seanceService;
    private final FilmService filmService;
    private final SalleService salleService;
    private final GenreService genreService;

    public SeanceController(SeanceService seanceService,
                            FilmService filmService,
                            SalleService salleService,
                            GenreService genreService) {
        this.seanceService = seanceService;
        this.filmService = filmService;
        this.salleService = salleService;
        this.genreService = genreService;
    }

    // Liste des séances
    @GetMapping
    public String listSeances(Model model) {
        model.addAttribute("seances", seanceService.findAll());
        return "seances/list";
    }

@GetMapping("/liste-seances")
public String listSeances(
        @RequestParam(value = "genre", required = false) String genre,
        @RequestParam(value = "dateSeance", required = false) String dateSeance, // not used currently
        @RequestParam(value = "heure", required = false) String heureStr, // ex: "14:30"
        @RequestParam(value = "comparaison", required = false) String comparaison, // "avant"/"apres"
        @RequestParam(value = "salle", required = false) Long idSalle,
        @RequestParam(value = "prixMax", required = false) Double prixMax,
        Model model) {

    List<Seance> seances = seanceService.findAll();

    // Filtre par genre
    if (genre != null && !genre.isEmpty()) {
        seances = seances.stream()
                .filter(s -> s.getFilm().getGenre() != null &&
                             s.getFilm().getGenre().getNomGenre().equalsIgnoreCase(genre))
                .toList();
    }

    if (dateSeance != null && !dateSeance.isEmpty()) {
        try {
            LocalDate date = LocalDate.parse(dateSeance);
            seances = seances.stream()
                    .filter(s -> s.getDateSeance() != null && s.getDateSeance().equals(date))
                    .toList();
        } catch (DateTimeParseException e) {
            // Invalid date format received — ignore this filter
        }
    }

    if (heureStr != null && !heureStr.isEmpty() &&
        comparaison != null && !comparaison.isEmpty()) {

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
}
