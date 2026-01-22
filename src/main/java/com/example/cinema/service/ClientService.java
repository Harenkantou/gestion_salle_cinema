package com.example.cinema.service;


import org.springframework.stereotype.Service;
import com.example.cinema.model.Client;
import com.example.cinema.repository.ClientRepository;
import java.util.List;
import java.util.Optional;

@Service
public class ClientService {

    private final ClientRepository ClientRepository;

    public ClientService(ClientRepository ClientRepository) {
        this.ClientRepository = ClientRepository;
    }

    public List<Client> findAll() {
        return ClientRepository.findAll();
    }

    public Optional<Client> findById(Long id) {
        return ClientRepository.findById(id);
    }
    
public Client login(String email, String motdepasse) {
    Client client = ClientRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("Email incorrect"));

    if (!client.getMotdepasse().equals(motdepasse)) {
        throw new RuntimeException("Mot de passe incorrect");
    }

    return client;
}

}
