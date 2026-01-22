package com.example.cinema.dto;

import java.time.LocalDate;

/**
 * DTO pour l'affichage des paiements des sociétés
 */
public class PaiementDTO {
    
    private Integer idPaiement;
    private String nomSociete;
    private Double montantPaye;
    private LocalDate datePaiement;
    private String description;
    
    // Champs calculés
    private Double totalDiffusions;
    private Double totalPaiements;
    private Double resteAPayer;
    private Double pourcentagePaye;
    
    // Constructeur par défaut
    public PaiementDTO() {}
    
    // Constructeur avec infos de paiement
    public PaiementDTO(Integer idPaiement, String nomSociete, Double montantPaye, 
                       LocalDate datePaiement, String description) {
        this.idPaiement = idPaiement;
        this.nomSociete = nomSociete;
        this.montantPaye = montantPaye;
        this.datePaiement = datePaiement;
        this.description = description;
    }
    
    // Constructeur complet avec solde
    public PaiementDTO(Integer idPaiement, String nomSociete, Double montantPaye, 
                       LocalDate datePaiement, String description, 
                       Double totalDiffusions, Double totalPaiements, Double resteAPayer, Double pourcentagePaye) {
        this.idPaiement = idPaiement;
        this.nomSociete = nomSociete;
        this.montantPaye = montantPaye;
        this.datePaiement = datePaiement;
        this.description = description;
        this.totalDiffusions = totalDiffusions;
        this.totalPaiements = totalPaiements;
        this.resteAPayer = resteAPayer;
        this.pourcentagePaye = pourcentagePaye;
    }
    
    // Getters and Setters
    public Integer getIdPaiement() {
        return idPaiement;
    }
    
    public void setIdPaiement(Integer idPaiement) {
        this.idPaiement = idPaiement;
    }
    
    public String getNomSociete() {
        return nomSociete;
    }
    
    public void setNomSociete(String nomSociete) {
        this.nomSociete = nomSociete;
    }
    
    public Double getMontantPaye() {
        return montantPaye;
    }
    
    public void setMontantPaye(Double montantPaye) {
        this.montantPaye = montantPaye;
    }
    
    public LocalDate getDatePaiement() {
        return datePaiement;
    }
    
    public void setDatePaiement(LocalDate datePaiement) {
        this.datePaiement = datePaiement;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Double getTotalDiffusions() {
        return totalDiffusions;
    }
    
    public void setTotalDiffusions(Double totalDiffusions) {
        this.totalDiffusions = totalDiffusions;
    }
    
    public Double getTotalPaiements() {
        return totalPaiements;
    }
    
    public void setTotalPaiements(Double totalPaiements) {
        this.totalPaiements = totalPaiements;
    }
    
    public Double getResteAPayer() {
        return resteAPayer;
    }
    
    public void setResteAPayer(Double resteAPayer) {
        this.resteAPayer = resteAPayer;
    }
    
    public Double getPourcentagePaye() {
        return pourcentagePaye;
    }
    
    public void setPourcentagePaye(Double pourcentagePaye) {
        this.pourcentagePaye = pourcentagePaye;
    }
}
