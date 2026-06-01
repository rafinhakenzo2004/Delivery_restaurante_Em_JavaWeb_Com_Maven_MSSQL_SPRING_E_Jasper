package com.fatec.restaurante.repository;

import com.fatec.restaurante.model.Ingrediente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * SOLID - DIP: As camadas superiores dependem desta abstração.
 * SOLID - ISP: Expõe apenas os métodos relevantes ao domínio Ingrediente.
 */
@Repository
public interface IngredienteRepository extends JpaRepository<Ingrediente, String> {

    List<Ingrediente> findByNomeContainingIgnoreCase(String nome);

    boolean existsByNomeIgnoreCase(String nome);
}