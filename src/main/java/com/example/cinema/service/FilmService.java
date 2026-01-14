package com.example.cinema.service;


import org.springframework.stereotype.Service;
import com.example.cinema.model.Film;
import com.example.cinema.repository.FilmRepository;
import java.util.List;
import java.util.Optional;

@Service
public class FilmService {

    private final FilmRepository filmRepository;

    public FilmService(FilmRepository filmRepository) {
        this.filmRepository = filmRepository;
    }

    public List<Film> findAll() {
        return filmRepository.findAll();
    }

    public Optional<Film> findById(Long id) {
        return filmRepository.findById(id);
    }

    public Film save(Film film) {
        return filmRepository.save(film);
    }

    public void deleteById(Long id) {
        filmRepository.deleteById(id);
    }
}
