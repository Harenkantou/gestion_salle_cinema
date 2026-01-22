package com.example.cinema.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.cinema.model.TypePlace;

@Repository
public interface TypePlaceRepository extends JpaRepository<TypePlace, Long> {
    Optional<TypePlace> findByLibelle(String libelle);
}
