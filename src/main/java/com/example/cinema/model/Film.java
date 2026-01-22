package com.example.cinema.model;


import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "film")
public class Film {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idFilm;

    @Column(nullable = false, length = 150)
    private String titre;

    @Column(columnDefinition = "TEXT")
    private String descriptionFilm;

    @Column(nullable = false)
    private Integer dureeMinutes;

    @ManyToOne
    @JoinColumn(name = "id_genre")
    private Genre genre;

    private java.time.LocalDate dateSortie;

    @Column(length = 255)
    private String image;

    @Column(length = 20)
    private String statut = "ACTIF";

    private LocalDateTime createdAt = LocalDateTime.now();

    // ----- Getters et Setters -----
    public Long getIdFilm() { return idFilm; }
    public void setIdFilm(Long idFilm) { this.idFilm = idFilm; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDescriptionFilm() { return descriptionFilm; }
    public void setDescriptionFilm(String descriptionFilm) { this.descriptionFilm = descriptionFilm; }

    public Integer getDureeMinutes() { return dureeMinutes; }
    public void setDureeMinutes(Integer dureeMinutes) { this.dureeMinutes = dureeMinutes; }

    public com.example.cinema.model.Genre getGenre() { return genre; }
    public void setGenre(com.example.cinema.model.Genre genre) { this.genre = genre; }

    public java.time.LocalDate getDateSortie() { return dateSortie; }
    public void setDateSortie(java.time.LocalDate dateSortie) { this.dateSortie = dateSortie; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
