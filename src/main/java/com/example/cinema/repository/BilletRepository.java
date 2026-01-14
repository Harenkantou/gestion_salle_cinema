package com.example.cinema.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.cinema.model.Billet;
import com.example.cinema.model.Client;
import java.util.List;

@Repository
public interface BilletRepository extends JpaRepository<Billet, Long> {
    
    List<Billet> findByClient(Client client);
}
