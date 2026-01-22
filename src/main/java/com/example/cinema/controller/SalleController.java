package com.example.cinema.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.cinema.model.Salle;
import com.example.cinema.service.SalleService;

@Controller
@RequestMapping("/salles")
public class SalleController {

    private final SalleService salleService;

    public SalleController(SalleService salleService) {
        this.salleService = salleService;
    }

    // Afficher la liste des salles
    @GetMapping("/list")
    public String listSalles(Model model) {
        List<Salle> salles = salleService.findAll();
        model.addAttribute("salles", salles);
        return "salles/list";
    }

    // Afficher les détails d'une salle avec le revenu maximum
    @GetMapping("/{idSalle}")
    public String detailSalle(@PathVariable Long idSalle, Model model) {
        Salle salle = salleService.findById(idSalle);
        Map<String, Object> detailRevenu = salleService.obtenirDetailRevenu(idSalle);
        
        model.addAttribute("salle", salle);
        model.addAttribute("detailRevenu", detailRevenu);
        return "salles/detail";
    }
}
