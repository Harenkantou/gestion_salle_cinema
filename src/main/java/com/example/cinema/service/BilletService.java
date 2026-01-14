package com.example.cinema.service;

import org.springframework.stereotype.Service;
import com.example.cinema.model.Billet;
import com.example.cinema.model.Client;
import com.example.cinema.repository.BilletRepository;

import java.util.List;

@Service
public class BilletService {

    private final BilletRepository billetRepository;

    public BilletService(BilletRepository billetRepository) {
        this.billetRepository = billetRepository;
    }

    public List<Billet> findAll() {
        return billetRepository.findAll();
    }

    public Billet save(Billet billet) {
        return billetRepository.save(billet);
    }

    public Billet findById(Long id) {
        return billetRepository.findById(id).orElseThrow(() -> new RuntimeException("Billet non trouvé"));
    }

    public void deleteById(Long id) {
        billetRepository.deleteById(id);
    }

    public List<Billet> findByClient(Client client) {
        return billetRepository.findByClient(client);
    }
}
