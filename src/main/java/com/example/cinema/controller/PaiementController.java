package com.example.cinema.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.cinema.dto.PaiementDTO;
import com.example.cinema.model.PaiementSociete;
import com.example.cinema.service.PaiementSocieteService;

import java.util.List;

@Controller
@RequestMapping("/paiements")
public class PaiementController {
    
    @Autowired
    private PaiementSocieteService paiementService;
    
    /**
     * Affiche le récapitulatif des paiements et le solde par société
     * GET /paiements/recap/{nomSociete}
     */
    @GetMapping("/recap/{nomSociete}")
    public String recapPaiements(@PathVariable String nomSociete, Model model) {
        PaiementDTO soldeInfo = paiementService.getSoldeAndHistorique(nomSociete);
        
        if (soldeInfo == null) {
            model.addAttribute("erreur", "Société non trouvée: " + nomSociete);
            return "paiements/recap";
        }
        
        // Récupérer l'historique détaillé
        List<PaiementDTO> historiqueDetaile = paiementService.getHistoriqueDetaile(nomSociete);
        
        model.addAttribute("nomSociete", nomSociete);
        model.addAttribute("soldeInfo", soldeInfo);
        model.addAttribute("historique", historiqueDetaile);
        
        return "paiements/recap";
    }
    
    /**
     * Affiche la liste de tous les paiements enregistrés
     * GET /paiements/liste
     */
    @GetMapping("/liste")
    public String listePaiements(Model model) {
        // Récupérer les historiques pour les deux sociétés
        PaiementDTO vanialaInfo = paiementService.getSoldeAndHistorique("Vaniala");
        PaiementDTO lewisInfo = paiementService.getSoldeAndHistorique("Lewis");
        
        List<PaiementDTO> historiquVaniala = paiementService.getHistoriqueDetaile("Vaniala");
        List<PaiementDTO> historiqueLewis = paiementService.getHistoriqueDetaile("Lewis");
        
        model.addAttribute("vanialaInfo", vanialaInfo);
        model.addAttribute("lewisInfo", lewisInfo);
        model.addAttribute("historiqueVaniala", historiquVaniala);
        model.addAttribute("historiqueLewis", historiqueLewis);
        
        return "paiements/liste";
    }
    
    /**
     * Affiche le détail des paiements pour Vaniala spécifiquement
     * GET /paiements/vaniala
     */
    @GetMapping("/vaniala")
    public String vanialaDetail(Model model) {
        return recapPaiements("Vaniala", model);
    }
}
