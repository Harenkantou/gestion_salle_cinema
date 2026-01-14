package com.example.cinema.controller;

import com.example.cinema.model.Client;
import com.example.cinema.service.ClientService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {

    private final ClientService clientService;

    public AuthController(ClientService clientService) {
        this.clientService = clientService;
    }

    // Afficher formulaire login
    @GetMapping("/login")
    public String showLogin() {
        return "auth/login";
    }

    // Traitement login
    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String motdepasse,
                        HttpSession session,
                        Model model) {
        try {
            Client client = clientService.login(email, motdepasse);
            session.setAttribute("clientConnecte", client);
            return "redirect:/seances/liste-seances";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "auth/login";
        }
    }

    // Déconnexion
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
