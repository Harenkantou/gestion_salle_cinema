package com.example.cinema.repository;

import com.example.cinema.model.PropDiffusion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PropDiffusionRepository extends JpaRepository<PropDiffusion, Long> {
    Optional<PropDiffusion> findByNom(String nom);
}