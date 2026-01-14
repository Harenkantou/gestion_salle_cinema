package com.example.cinema.model;

import jakarta.persistence.*;

@Entity
@Table(name = "place",
       uniqueConstraints = @UniqueConstraint(columnNames = {"id_salle", "rangee", "numero"}))
public class Place {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idPlace;

    @Column(nullable = false, length = 5)
    private String rangee;

    @Column(nullable = false)
    private Integer numero;

    @ManyToOne
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;

    // Getters & Setters
    public Long getIdPlace() { return idPlace; }
    public void setIdPlace(Long idPlace) { this.idPlace = idPlace; }

    public String getRangee() { return rangee; }
    public void setRangee(String rangee) { this.rangee = rangee; }

    public Integer getNumero() { return numero; }
    public void setNumero(Integer numero) { this.numero = numero; }

    public Salle getSalle() { return salle; }
    public void setSalle(Salle salle) { this.salle = salle; }
}
