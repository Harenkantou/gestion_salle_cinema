package com.example.cinema.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.cinema.model.TypeBillet;
import com.example.cinema.repository.TypeBilletRepository;

@Service
public class TypeBilletService {

    private final TypeBilletRepository typeBilletRepository;

    public TypeBilletService(TypeBilletRepository typeBilletRepository) {
        this.typeBilletRepository = typeBilletRepository;
    }

    public List<TypeBillet> findAll() {
        return typeBilletRepository.findAll();
    }

    public TypeBillet findById(Long id) {
        return typeBilletRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Type de billet non trouvé"));
    }

    public TypeBillet findByLibelle(String libelle) {
        return typeBilletRepository.findByLibelle(libelle)
                .orElseThrow(() -> new RuntimeException("Type de billet '" + libelle + "' non trouvé"));
    }

    public TypeBillet save(TypeBillet typeBillet) {
        return typeBilletRepository.save(typeBillet);
    }

    public void deleteById(Long id) {
        typeBilletRepository.deleteById(id);
    }

    /**
     * Obtient le type de billet enfant
     */
    public TypeBillet getTypeBilletEnfant() {
        return findByLibelle("Enfant");
    }

    /**
     * Obtient le type de billet adulte
     */
    public TypeBillet getTypeBilletAdulte() {
        return findByLibelle("Adulte");
    }
}
