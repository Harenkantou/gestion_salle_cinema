package com.example.cinema.model;


import jakarta.persistence.*;

@Entity
@Table(name = "genre")
public class Genre {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idGenre;

    @Column(nullable = false, unique = true, length = 50)
    private String nomGenre;

    @Column(columnDefinition = "TEXT")
    private String description;

    // ----- Getters et Setters -----
    public Long getIdGenre() { return idGenre; }
    public void setIdGenre(Long idGenre) { this.idGenre = idGenre; }

    public String getNomGenre() { return nomGenre; }
    public void setNomGenre(String nomGenre) { this.nomGenre = nomGenre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
