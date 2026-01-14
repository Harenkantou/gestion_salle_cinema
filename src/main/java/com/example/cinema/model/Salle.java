package com.example.cinema.model;


import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "salle")
public class Salle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idSalle;

    @Column(nullable = false, length = 50)
    private String nomSalle;

    @Column(nullable = false)
    private Integer capacite;

    @OneToMany(mappedBy = "salle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Place> places;

    public List<Place> getPlaces() {
        return places;
    }
    public void setPlaces(List<Place> places) {
        this.places = places;
    }
    @Column(nullable = false)
    private Boolean statut = true; // true = dispo, false = indisponible

    private LocalDateTime createdAt = LocalDateTime.now();

    // ----- Getters / Setters -----
    public Long getIdSalle() { return idSalle; }
    public void setIdSalle(Long idSalle) { this.idSalle = idSalle; }

    public String getNomSalle() { return nomSalle; }
    public void setNomSalle(String nomSalle) { this.nomSalle = nomSalle; }

    public Integer getCapacite() { return capacite; }
    public void setCapacite(Integer capacite) { this.capacite = capacite; }

    public Boolean getStatut() { return statut; }
    public void setStatut(Boolean statut) { this.statut = statut; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    
}
