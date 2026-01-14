package com.example.cinema.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.cinema.model.Salle;

@Repository
public interface SalleRepository extends JpaRepository<Salle, Long> {
}
