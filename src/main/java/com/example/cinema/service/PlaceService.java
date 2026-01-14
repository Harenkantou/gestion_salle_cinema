package com.example.cinema.service;

import org.springframework.stereotype.Service;
import com.example.cinema.model.Place;
import com.example.cinema.repository.PlaceRepository;

import java.util.List;

@Service
public class PlaceService {

    private final PlaceRepository placeRepository;

    public PlaceService(PlaceRepository placeRepository) {
        this.placeRepository = placeRepository;
    }

    public List<Place> findAll() {
        return placeRepository.findAll();
    }

    public Place save(Place place) {
        return placeRepository.save(place);
    }

    public Place findById(Long id) {
        return placeRepository.findById(id).orElseThrow(() -> new RuntimeException("Place non trouvée"));
    }

    public void deleteById(Long id) {
        placeRepository.deleteById(id);
    }
}
