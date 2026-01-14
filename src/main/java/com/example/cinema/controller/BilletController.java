package com.example.cinema.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.cinema.model.Billet;
import com.example.cinema.model.Client;
import com.example.cinema.model.Place;
import com.example.cinema.model.Seance;
import com.example.cinema.service.BilletService;
import com.example.cinema.service.ClientService;
import com.example.cinema.service.PlaceService;
import com.example.cinema.service.SeanceService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/billets")
public class BilletController {

    private final BilletService billetService;
    private final SeanceService seanceService;
    private final ClientService clientService;
    private final PlaceService placeService;

    public BilletController(BilletService billetService,
                            SeanceService seanceService,
                            ClientService clientService,
                            PlaceService placeService) {
        this.billetService = billetService;
        this.seanceService = seanceService;
        this.clientService = clientService;
        this.placeService = placeService;
    }

    // 1️⃣ Formulaire pour réserver billet
    @GetMapping("/reserver/{idSeance}")
    public String formReserver(@PathVariable Long idSeance, Model model) {

        Seance seance = seanceService.findById(idSeance);

        // Récupérer toutes les places de la salle
        List<Place> toutesPlaces = seance.getSalle().getPlaces();

        // Filtrer les places déjà réservées pour cette séance
        List<Place> placesDisponibles = toutesPlaces.stream()
                .filter(p -> billetService.findAll().stream()
                        .noneMatch(b -> b.getSeance().getIdSeance().equals(idSeance)
                                && b.getPlace().getIdPlace().equals(p.getIdPlace()))
                ).collect(Collectors.toList());

        model.addAttribute("seance", seance);
        model.addAttribute("placesDisponibles", placesDisponibles);
        return "billets/reserver";
    }

    // 2️⃣ Traitement du formulaire
    @PostMapping("/reserver/{idSeance}")
    public String reserver(@PathVariable Long idSeance,
                           @RequestParam Long idPlace,
                           HttpSession session,
                           Model model) {

        Client client = (Client) session.getAttribute("clientConnecte");
        if (client == null) {
            return "redirect:/login";
        }

        Seance seance = seanceService.findById(idSeance);
        Place place = placeService.findById(idPlace);

        // Vérifier si la place est toujours disponible
        boolean dejaReserve = billetService.findAll().stream()
                .anyMatch(b -> b.getSeance().getIdSeance().equals(idSeance)
                        && b.getPlace().getIdPlace().equals(idPlace));

        if (dejaReserve) {
            model.addAttribute("error", "Cette place est déjà réservée !");
            return "redirect:/billets/reserver/" + idSeance;
        }

        Billet billet = new Billet();
        billet.setClient(client);
        billet.setSeance(seance);
        billet.setPlace(place);
        billet.setIdStatutBillet(1); // 1 = réservé
        billet.setPrix(seance.getPrix());
        billetService.save(billet);

        model.addAttribute("success", "Billet réservé avec succès !");
        return "redirect:/seances/fiche/" + idSeance;
    }

    @GetMapping("/list")
    public String showList(Model model) {
        model.addAttribute("clients", clientService.findAll());
        return "billets/list";
    }

    // Afficher la liste des billets par client 
    @PostMapping("/list")
    public String listBillets(@RequestParam Long idClient, Model model) {
        Client client = clientService.findById(idClient).orElseThrow();
        model.addAttribute("clients", clientService.findAll());
        model.addAttribute("billets", billetService.findByClient(client));
        
        return "billets/list"; // /WEB-INF/views/billets/list.jsp
    }
}
