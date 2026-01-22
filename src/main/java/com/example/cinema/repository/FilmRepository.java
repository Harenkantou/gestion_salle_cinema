package com.example.cinema.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.cinema.model.Film;

@Repository
public interface FilmRepository extends JpaRepository<Film, Long> {
  
}