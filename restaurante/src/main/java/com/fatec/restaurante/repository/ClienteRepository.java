package com.fatec.restaurante.repository;

import com.fatec.restaurante.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * SOLID - DIP: Camadas superiores dependem desta abstração.
 * SOLID - ISP: Expõe apenas os métodos relevantes ao domínio Cliente.
 */
@Repository
public interface ClienteRepository extends JpaRepository<Cliente, String> {

    Optional<Cliente> findByCpf(String cpf);

    List<Cliente> findByNomeContainingIgnoreCase(String nome);
}