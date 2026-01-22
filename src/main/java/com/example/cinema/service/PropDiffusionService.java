package com.example.cinema.service;

import com.example.cinema.model.PropDiffusion;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public interface PropDiffusionService {
    List<PropDiffusion> findAll();
    Optional<PropDiffusion> findById(Long id);
    PropDiffusion save(PropDiffusion propDiffusion);
    void deleteById(Long id);
    Optional<PropDiffusion> findByNom(String nom);
}