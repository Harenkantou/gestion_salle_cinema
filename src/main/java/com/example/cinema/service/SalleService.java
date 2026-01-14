package com.example.cinema.service;


import org.springframework.stereotype.Service;
import com.example.cinema.model.Salle;
import com.example.cinema.repository.SalleRepository;
import java.util.List;

@Service
public class SalleService {

    private final SalleRepository salleRepository;

    public SalleService(SalleRepository salleRepository) {
        this.salleRepository = salleRepository;
    }

    public List<Salle> findAll() {
        return salleRepository.findAll();
    }

    public Salle findById(Long id) {
        return salleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Salle non trouvée"));
    }

    public Salle save(Salle salle) {
        return salleRepository.save(salle);
    }

    public void deleteById(Long id) {
        salleRepository.deleteById(id);
    }
}
