package com.example.cinema.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.cinema.model.PaiementSociete;
import com.example.cinema.model.PropDiffusion;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaiementSocieteRepository extends JpaRepository<PaiementSociete, Integer> {
    
    /**
     * Récupère tous les paiements pour une société
     */
    List<PaiementSociete> findByPropDiffusion(PropDiffusion propDiffusion);
    
    /**
     * Récupère tous les paiements pour une société (recherche par nom)
     */
    @Query("SELECT ps FROM PaiementSociete ps JOIN ps.propDiffusion pd WHERE pd.nom = :nomSociete ORDER BY ps.datePaiement DESC")
    List<PaiementSociete> findPaiementsBySocieteNom(@Param("nomSociete") String nomSociete);
    
    /**
     * Récupère le total des paiements pour une société
     */
    @Query("SELECT COALESCE(SUM(ps.montant), 0) FROM PaiementSociete ps WHERE ps.propDiffusion = :propDiffusion")
    Double getTotalPaiementsBySociete(@Param("propDiffusion") PropDiffusion propDiffusion);
    
    /**
     * Récupère le total des diffusions (revenu) pour une société
     */
    @Query("SELECT COALESCE(SUM(ds.prix), 0) FROM DiffusionSeance ds WHERE ds.propDiffusion = :propDiffusion")
    Double getTotalDiffusionsBySociete(@Param("propDiffusion") PropDiffusion propDiffusion);
}
