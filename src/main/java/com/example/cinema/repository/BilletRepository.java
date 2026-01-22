package com.example.cinema.repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.cinema.model.Billet;
import com.example.cinema.model.Client;
import com.example.cinema.model.Place;
import com.example.cinema.model.Seance;

@Repository
public interface BilletRepository extends JpaRepository<Billet, Long> {
    
    List<Billet> findByClient(Client client);
    
    List<Billet> findBySeance(Seance seance);
    
    Optional<Billet> findBySeanceAndPlace(Seance seance, Place place);

     @Query("SELECT COALESCE(SUM(b.prix), 0) FROM Billet b WHERE b.dateAchat BETWEEN :debut AND :fin")
    BigDecimal sumPrixByDateAchatBetween(@Param("debut") LocalDateTime debut, @Param("fin") LocalDateTime fin);
}

