// src/main/java/com/example/cinema/repository/DiffusionSeanceRepository.java
package com.example.cinema.repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.example.cinema.model.DiffusionSeance;

@Repository
public interface DiffusionSeanceRepository extends JpaRepository<DiffusionSeance, Long> {
    @Query("SELECT COALESCE(SUM(ds.prix), 0) FROM DiffusionSeance ds WHERE ds.dateDiffusion BETWEEN :debut AND :fin")
    BigDecimal sumPrixByDateDiffusionBetween(@Param("debut") LocalDate debut, @Param("fin") LocalDate fin);
}