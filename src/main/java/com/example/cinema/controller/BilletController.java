package com.example.cinema.controller;

import java.util.List;
import java.util.Map;
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
import com.example.cinema.model.TypeBillet;
import com.example.cinema.service.BilletService;
import com.example.cinema.service.ClientService;
import com.example.cinema.service.PlaceService;
import com.example.cinema.service.SeanceService;
import com.example.cinema.service.TypeBilletService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/billets")
public class BilletController {

    private final BilletService billetService;
    private final SeanceService seanceService;
    private final ClientService clientService;
    private final PlaceService placeService;
    private final TypeBilletService typeBilletService;

    public BilletController(BilletService billetService,
                            SeanceService seanceService,
                            ClientService clientService,
                            PlaceService placeService,
                            TypeBilletService typeBilletService) {
        this.billetService = billetService;
        this.seanceService = seanceService;
        this.clientService = clientService;
        this.placeService = placeService;
        this.typeBilletService = typeBilletService;
    }

    // 1️⃣ Formulaire pour réserver billet
    @GetMapping("/reserver/{idSeance}")
    public String formReserver(@PathVariable Long idSeance, Model model) {

        Seance seance = seanceService.findById(idSeance);

        // Récupérer toutes les places de la salle
        List<Place> toutesPlaces = seance.getSalle().getPlaces();

        // Récupérer les billets déjà réservés pour cette séance
        List<Billet> billetsSeance = billetService.findBySeance(seance);
        List<Long> placesReserveeIds = billetsSeance.stream()
                .map(b -> b.getPlace().getIdPlace())
                .collect(Collectors.toList());

        // Filtrer les places disponibles
        List<Place> placesDisponibles = toutesPlaces.stream()
                .filter(p -> !placesReserveeIds.contains(p.getIdPlace()))
                .collect(Collectors.toList());

        // Ajouter les types de billets (Adulte, Enfant)
        List<TypeBillet> typesBillets = typeBilletService.findAll();

        model.addAttribute("seance", seance);
        model.addAttribute("placesDisponibles", placesDisponibles);
        model.addAttribute("nombrePlacesDisponibles", placesDisponibles.size());
        model.addAttribute("typesBillets", typesBillets);
        return "billets/reserver";
    }

    // 2️⃣ Traitement du formulaire (MULTIPLE PLACES avec type billet)
    @PostMapping("/reserver/{idSeance}")
    public String reserver(@PathVariable Long idSeance,
                           @RequestParam(value = "idPlaces", required = false) Long[] idPlaces,
                           @RequestParam(value = "typesBillets", required = false) Long[] typesBillets,
                           HttpSession session,
                           Model model) {

        Client client = (Client) session.getAttribute("clientConnecte");
        if (client == null) {
            return "redirect:/login";
        }

        if (idPlaces == null || idPlaces.length == 0) {
            model.addAttribute("error", "Veuillez sélectionner au moins une place !");
            return "redirect:/billets/reserver/" + idSeance;
        }

        Seance seance = seanceService.findById(idSeance);
        int compteur = 0;

        for (int i = 0; i < idPlaces.length; i++) {
            Long idPlace = idPlaces[i];
            Place place = placeService.findById(idPlace);

            // Vérifier si la place est toujours disponible
            if (billetService.isPlaceReserved(seance, place)) {
                model.addAttribute("error", "La place " + place.getRangee() + place.getNumero() + " est déjà réservée !");
                return "redirect:/billets/reserver/" + idSeance;
            }

            // Récupérer le type de billet sélectionné (Adulte ou Enfant)
            Long idTypeBillet = (typesBillets != null && i < typesBillets.length) 
                    ? typesBillets[i] 
                    : typeBilletService.getTypeBilletAdulte().getIdTypeBillet();
            
            TypeBillet typeBillet = typeBilletService.findById(idTypeBillet);

            // Créer le billet avec calcul automatique du prix
            Billet billet = billetService.creerBillet(client, seance, place, typeBillet);
            compteur++;
        }

        model.addAttribute("success", compteur + " billet(s) réservé(s) avec succès !");
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

    // Afficher les réservations du client connecté
    @GetMapping("/mes-reservations")
    public String mesReservations(HttpSession session, Model model) {
        Client client = (Client) session.getAttribute("clientConnecte");
        if (client == null) {
            return "redirect:/login";
        }
        
        List<Billet> billets = billetService.findByClient(client);
        model.addAttribute("billets", billets);
        model.addAttribute("client", client);
        return "billets/mes-reservations";
    }

    // Annuler une réservation
    @PostMapping("/annuler/{idBillet}")
    public String annulerReservation(@PathVariable Long idBillet, 
                                     HttpSession session,
                                     Model model) {
        Client client = (Client) session.getAttribute("clientConnecte");
        if (client == null) {
            return "redirect:/login";
        }

        Billet billet = billetService.findById(idBillet);
        
        // Vérifier que le billet appartient au client connecté
        if (!billet.getClient().getIdClient().equals(client.getIdClient())) {
            model.addAttribute("error", "Vous ne pouvez pas annuler ce billet!");
            return "redirect:/billets/mes-reservations";
        }

        billetService.deleteById(idBillet);
        model.addAttribute("success", "Réservation annulée avec succès!");
        return "redirect:/billets/mes-reservations";
    }

    // ADMIN: Afficher toutes les réservations
    @GetMapping("/toutes-reservations")
    public String toutesReservations(Model model) {
        List<Billet> tousLesBillets = billetService.findAll();
        model.addAttribute("billets", tousLesBillets);
        model.addAttribute("totalBillets", tousLesBillets.size());
        
        // Calculer le total des revenus
        double totalRevenu = tousLesBillets.stream()
                .mapToDouble(Billet::getPrix)
                .sum();
        model.addAttribute("totalRevenu", totalRevenu);
        
        return "billets/toutes-reservations";
    }

    // RAPPORT FINANCIER: Chiffre d'affaires détaillé avec enfants
    @GetMapping("/rapport-financier")
    public String rapportFinancier(Model model) {
        List<Billet> tousLesBillets = billetService.findAll();
        
        // Total général
        double totalRevenu = tousLesBillets.stream()
                .mapToDouble(Billet::getPrix)
                .sum();
        
        // Compter les billets adultes et enfants
        long totalAdultes = tousLesBillets.stream()
                .filter(b -> b.getTypeBillet() != null && !b.getTypeBillet().getIsEnfant())
                .count();
        
        long totalEnfants = tousLesBillets.stream()
                .filter(b -> b.getTypeBillet() != null && b.getTypeBillet().getIsEnfant())
                .count();
        
        // Total revenu adultes
        double revenuAdultes = tousLesBillets.stream()
                .filter(b -> b.getTypeBillet() != null && !b.getTypeBillet().getIsEnfant())
                .mapToDouble(Billet::getPrix)
                .sum();
        
        // Total revenu enfants
        double revenuEnfants = tousLesBillets.stream()
                .filter(b -> b.getTypeBillet() != null && b.getTypeBillet().getIsEnfant())
                .mapToDouble(Billet::getPrix)
                .sum();
        
        // Grouper par film
        Map<String, Double> revenueParFilm = tousLesBillets.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                        b -> b.getSeance().getFilm().getTitre(),
                        java.util.stream.Collectors.summingDouble(Billet::getPrix)
                ));
        
        // Grouper par salle
        Map<String, Double> revenueParSalle = tousLesBillets.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                        b -> b.getSeance().getSalle().getNomSalle(),
                        java.util.stream.Collectors.summingDouble(Billet::getPrix)
                ));
        
        // Grouper par date
        Map<String, Double> revenueParDate = tousLesBillets.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                        b -> b.getSeance().getDateSeance().toString(),
                        java.util.stream.Collectors.summingDouble(Billet::getPrix)
                ));
        
        model.addAttribute("totalRevenu", totalRevenu);
        model.addAttribute("totalBillets", tousLesBillets.size());
        model.addAttribute("totalAdultes", totalAdultes);
        model.addAttribute("totalEnfants", totalEnfants);
        model.addAttribute("revenuAdultes", revenuAdultes);
        model.addAttribute("revenuEnfants", revenuEnfants);
        model.addAttribute("revenueParFilm", revenueParFilm);
        model.addAttribute("revenueParSalle", revenueParSalle);
        model.addAttribute("revenueParDate", revenueParDate);
        
        return "billets/rapport-financier";
    }
}
