package com.example.cinema.model;



import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

@Entity
@Table(name = "seance",
       uniqueConstraints = {@UniqueConstraint(columnNames = {"id_salle", "date_seance", "heure_debut"})})
public class Seance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idSeance;

    @ManyToOne
    @JoinColumn(name = "id_film", nullable = false)
    private Film film;

    @ManyToOne
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;

    @Column(name = "date_seance", nullable = false)
    private LocalDate dateSeance;

    @Column(name = "heure_debut", nullable = false)
    private LocalTime heureDebut;

    @Column(nullable = false)
    private Double prix;

    @Column(nullable = false)
    private Boolean statut = true; // true = programmé, false = annulé

    private LocalDateTime createdAt = LocalDateTime.now();

    // Getters / Setters
    public Long getIdSeance() { return idSeance; }
    public void setIdSeance(Long idSeance) { this.idSeance = idSeance; }

    public Film getFilm() { return film; }
    public void setFilm(Film film) { this.film = film; }

    public Salle getSalle() { return salle; }
    public void setSalle(Salle salle) { this.salle = salle; }

    public LocalDate getDateSeance() { return dateSeance; }
    public void setDateSeance(LocalDate dateSeance) { this.dateSeance = dateSeance; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public Double getPrix() { return prix; }
    public void setPrix(Double prix) { this.prix = prix; }

    public Boolean getStatut() { return statut; }
    public void setStatut(Boolean statut) { this.statut = statut; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
