package com.example.cinema.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "diffusion_seance")
public class DiffusionSeance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_prop_diffusion", nullable = false)
    private PropDiffusion propDiffusion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;

    @Column(nullable = false)
    private LocalDate dateDiffusion;

    @Column(nullable = false, precision = 8, scale = 2)
    private BigDecimal prix;

    // Constructeurs
    public DiffusionSeance() {}

    public DiffusionSeance(PropDiffusion propDiffusion, Seance seance, LocalDate dateDiffusion, BigDecimal prix) {
        this.propDiffusion = propDiffusion;
        this.seance = seance;
        this.dateDiffusion = dateDiffusion;
        this.prix = prix;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public PropDiffusion getPropDiffusion() {
        return propDiffusion;
    }

    public void setPropDiffusion(PropDiffusion propDiffusion) {
        this.propDiffusion = propDiffusion;
    }

    public Seance getSeance() {
        return seance;
    }

    public void setSeance(Seance seance) {
        this.seance = seance;
    }

    public LocalDate getDateDiffusion() {
        return dateDiffusion;
    }

    public void setDateDiffusion(LocalDate dateDiffusion) {
        this.dateDiffusion = dateDiffusion;
    }

    public BigDecimal getPrix() {
        return prix;
    }

    public void setPrix(BigDecimal prix) {
        this.prix = prix;
    }
}