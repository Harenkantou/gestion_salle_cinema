package com.example.cinema.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "billet")
public class Billet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idBillet;

    @Column(nullable = false)
    private LocalDateTime dateAchat = LocalDateTime.now();

    @ManyToOne
    @JoinColumn(name = "id_client", nullable = false)
    private Client client;

    @ManyToOne
    @JoinColumn(name = "id_seance", nullable = false)
    private Seance seance;

    @Column(nullable = false)
    private Integer idStatutBillet; // 1 = réservé, 2 = payé, etc.

    @Column(nullable = false)
    private Double prix;

     @ManyToOne
    @JoinColumn(name = "id_place", nullable = false)
    private Place place;

    public Place getPlace() {
        return place;
    }
     public void setPlace(Place place) {
         this.place = place;
     }
    // Getters & Setters
    public Long getIdBillet() { return idBillet; }
    public void setIdBillet(Long idBillet) { this.idBillet = idBillet; }

    public LocalDateTime getDateAchat() { return dateAchat; }
    public void setDateAchat(LocalDateTime dateAchat) { this.dateAchat = dateAchat; }

    public Client getClient() { return client; }
    public void setClient(Client client) { this.client = client; }

    public Seance getSeance() { return seance; }
    public void setSeance(Seance seance) { this.seance = seance; }

    public Integer getIdStatutBillet() { return idStatutBillet; }
    public void setIdStatutBillet(Integer idStatutBillet) { this.idStatutBillet = idStatutBillet; }

    public Double getPrix() { return prix; }
    public void setPrix(Double prix) { this.prix = prix; }
}
