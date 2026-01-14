package com.example.cinema.service;


import org.springframework.stereotype.Service;
import com.example.cinema.model.Genre;
import com.example.cinema.repository.GenreRepository;
import java.util.List;

@Service
public class GenreService {

    private final GenreRepository genreRepository;

    public GenreService(GenreRepository genreRepository) {
        this.genreRepository = genreRepository;
    }

    public List<Genre> findAll() {
        return genreRepository.findAll();
    }
}
