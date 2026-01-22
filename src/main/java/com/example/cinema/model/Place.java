package com.example.cinema.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

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

    @ManyToOne
    @JoinColumn(name = "id_type_place", nullable = false)
    private TypePlace typePlace;

    // Getters & Setters
    public Long getIdPlace() { return idPlace; }
    public void setIdPlace(Long idPlace) { this.idPlace = idPlace; }

    public String getRangee() { return rangee; }
    public void setRangee(String rangee) { this.rangee = rangee; }

    public Integer getNumero() { return numero; }
    public void setNumero(Integer numero) { this.numero = numero; }

    public Salle getSalle() { return salle; }
    public void setSalle(Salle salle) { this.salle = salle; }

    public TypePlace getTypePlace() { return typePlace; }
    public void setTypePlace(TypePlace typePlace) { this.typePlace = typePlace; }
}
