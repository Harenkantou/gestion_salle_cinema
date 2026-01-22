package com.example.cinema.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.cinema.model.TypeBillet;

@Repository
public interface TypeBilletRepository extends JpaRepository<TypeBillet, Long> {
    Optional<TypeBillet> findByLibelle(String libelle);
}
