package com.example.cinema.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entité pour gérer les paiements des sociétés de diffusion
 */
@Entity
@Table(name = "paiement_societe")
public class PaiementSociete {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_paiement")
    private Integer idPaiement;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_prop_diffusion", nullable = false)
    private PropDiffusion propDiffusion;
    
    @Column(name = "montant", nullable = false)
    private Double montant;
    
    @Column(name = "date_paiement", nullable = false)
    private LocalDate datePaiement;
    
    @Column(name = "description")
    private String description;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    // Constructeurs
    public PaiementSociete() {
        this.createdAt = LocalDateTime.now();
    }
    
    public PaiementSociete(PropDiffusion propDiffusion, Double montant, LocalDate datePaiement, String description) {
        this.propDiffusion = propDiffusion;
        this.montant = montant;
        this.datePaiement = datePaiement;
        this.description = description;
        this.createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Integer getIdPaiement() {
        return idPaiement;
    }
    
    public void setIdPaiement(Integer idPaiement) {
        this.idPaiement = idPaiement;
    }
    
    public PropDiffusion getPropDiffusion() {
        return propDiffusion;
    }
    
    public void setPropDiffusion(PropDiffusion propDiffusion) {
        this.propDiffusion = propDiffusion;
    }
    
    public Double getMontant() {
        return montant;
    }
    
    public void setMontant(Double montant) {
        this.montant = montant;
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
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
