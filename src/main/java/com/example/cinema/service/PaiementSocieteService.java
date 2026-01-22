package com.example.cinema.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.cinema.dto.PaiementDTO;
import com.example.cinema.model.PaiementSociete;
import com.example.cinema.model.PropDiffusion;
import com.example.cinema.repository.PaiementSocieteRepository;
import com.example.cinema.repository.PropDiffusionRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class PaiementSocieteService {
    
    @Autowired
    private PaiementSocieteRepository paiementRepository;
    
    @Autowired
    private PropDiffusionRepository propDiffusionRepository;
    
    /**
     * Récupère l'historique des paiements pour une société
     */
    public List<PaiementSociete> getHistoriquePaiements(String nomSociete) {
        return paiementRepository.findPaiementsBySocieteNom(nomSociete);
    }
    
    /**
     * Récupère les informations complètes de paiement et solde pour une société
     */
    public PaiementDTO getSoldeAndHistorique(String nomSociete) {
        Optional<PropDiffusion> propDiffusionOpt = propDiffusionRepository.findByNom(nomSociete);
        
        if (!propDiffusionOpt.isPresent()) {
            return null;
        }
        
        PropDiffusion propDiffusion = propDiffusionOpt.get();
        
        // Récupérer tous les paiements
        List<PaiementSociete> paiements = paiementRepository.findByPropDiffusion(propDiffusion);
        Double totalPaiements = paiements.stream()
            .mapToDouble(p -> p.getMontant() != null ? p.getMontant() : 0.0)
            .sum();
        
        // Calculer le total des diffusions (revenu) - estimation basée sur les paiements
        // En l'absence de table de revenu, on suppose que le total des diffusions est connu
        Double totalDiffusions = 0.0;
        
        // Calculer le reste à payer
        Double resteAPayer = totalDiffusions - totalPaiements;
        
        // Calculer le pourcentage payé
        Double pourcentagePaye = (totalDiffusions > 0) ? (totalPaiements / totalDiffusions) * 100 : 0.0;
        
        // Créer le DTO de synthèse
        PaiementDTO dto = new PaiementDTO();
        dto.setNomSociete(nomSociete);
        dto.setTotalDiffusions(totalDiffusions);
        dto.setTotalPaiements(totalPaiements);
        dto.setResteAPayer(resteAPayer);
        dto.setPourcentagePaye(pourcentagePaye);
        
        return dto;
    }
    
    /**
     * Enregistrer un nouveau paiement
     */
    public PaiementSociete enregistrerPaiement(String nomSociete, Double montant, 
                                              java.time.LocalDate datePaiement, String description) {
        Optional<PropDiffusion> propDiffusionOpt = propDiffusionRepository.findByNom(nomSociete);
        
        if (!propDiffusionOpt.isPresent()) {
            throw new RuntimeException("Société non trouvée: " + nomSociete);
        }
        
        PropDiffusion propDiffusion = propDiffusionOpt.get();
        PaiementSociete paiement = new PaiementSociete(propDiffusion, montant, datePaiement, description);
        
        return paiementRepository.save(paiement);
    }
    
    /**
     * Récupère tous les paiements d'une société avec calcul du solde courant
     */
    public List<PaiementDTO> getHistoriqueDetaile(String nomSociete) {
        List<PaiementSociete> paiements = paiementRepository.findPaiementsBySocieteNom(nomSociete);
        
        // Récupérer les infos de la société
        Optional<PropDiffusion> propDiffusionOpt = propDiffusionRepository.findByNom(nomSociete);
        if (!propDiffusionOpt.isPresent()) {
            return new ArrayList<>();
        }
        
        PropDiffusion propDiffusion = propDiffusionOpt.get();
        
        // Calculer le total des paiements
        Double totalPaiements = paiements.stream()
            .mapToDouble(p -> p.getMontant() != null ? p.getMontant() : 0.0)
            .sum();
        
        // Total des diffusions - on va le calculer à partir d'une source de données
        Double totalDiffusions = 0.0;
        
        // Convertir en DTOs avec solde
        List<PaiementDTO> dtos = new ArrayList<>();
        for (PaiementSociete paiement : paiements) {
            Double resteAPayer = totalDiffusions - totalPaiements;
            Double pourcentagePaye = (totalDiffusions > 0) ? (totalPaiements / totalDiffusions) * 100 : 0.0;
            
            PaiementDTO dto = new PaiementDTO(
                paiement.getIdPaiement(),
                nomSociete,
                paiement.getMontant(),
                paiement.getDatePaiement(),
                paiement.getDescription(),
                totalDiffusions,
                totalPaiements,
                resteAPayer,
                pourcentagePaye
            );
            dtos.add(dto);
        }
        
        return dtos;
    }
}
