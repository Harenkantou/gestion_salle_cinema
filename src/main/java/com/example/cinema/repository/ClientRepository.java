package com.example.cinema.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.cinema.model.Client;
import java.util.*;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {

   Optional<Client> findByEmail(String email);
}
