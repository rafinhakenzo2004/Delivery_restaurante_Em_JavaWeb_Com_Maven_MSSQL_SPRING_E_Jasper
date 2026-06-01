package com.fatec.restaurante.repository;

import com.fatec.restaurante.model.TipoPrato;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * SOLID - DIP: Camadas superiores dependem desta abstração.
 * SOLID - ISP: Expõe apenas métodos relevantes ao domínio TipoPrato.
 */
@Repository
public interface TipoPratoRepository extends JpaRepository<TipoPrato, Integer> {

    boolean existsByNomeTipoIgnoreCase(String nomeTipo);
}