package com.example.cinema.repository;



import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.cinema.model.Salle;
import com.example.cinema.model.Seance;

@Repository
public interface SeanceRepository extends JpaRepository<Seance, Long> {

    // Vérifier si une salle a déjà une séance à cette date et heure
    Optional<Seance> findBySalleAndDateSeanceAndHeureDebut(Salle salle, LocalDate date, LocalTime heure);
}
