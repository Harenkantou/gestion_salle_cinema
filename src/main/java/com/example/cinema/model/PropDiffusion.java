package com.example.cinema.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "prop_diffusion")
public class PropDiffusion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 50)
    private String nom;

    // Relation OneToMany avec DiffusionSeance (optionnel mais utile)
    @OneToMany(mappedBy = "propDiffusion", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<DiffusionSeance> diffusionSeances = new ArrayList<>();

    // Constructeurs
    public PropDiffusion() {}

    public PropDiffusion(String nom) {
        this.nom = nom;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public List<DiffusionSeance> getDiffusionSeances() {
        return diffusionSeances;
    }

    public void setDiffusionSeances(List<DiffusionSeance> diffusionSeances) {
        this.diffusionSeances = diffusionSeances;
    }
}