package com.example.cinema.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "type_billet")
public class TypeBillet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idTypeBillet;

    @Column(nullable = false, length = 50, unique = true)
    private String libelle;

    @Column(nullable = false ,name="isenfant")
    private Boolean isEnfant = false;

    // Constructors
    public TypeBillet() {}

    public TypeBillet(String libelle, Boolean isEnfant) {
        this.libelle = libelle;
        this.isEnfant = isEnfant;
    }

    // Getters & Setters
    public Long getIdTypeBillet() {
        return idTypeBillet;
    }

    public void setIdTypeBillet(Long idTypeBillet) {
        this.idTypeBillet = idTypeBillet;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Boolean getIsEnfant() {
        return isEnfant;
    }

    public void setIsEnfant(Boolean isEnfant) {
        this.isEnfant = isEnfant;
    }
}
