package com.fatec.restaurante.repository;

import com.fatec.restaurante.model.PratoIngrediente;
import com.fatec.restaurante.model.PratoIngredienteId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

 //SOLID - DIP: Camadas superiores dependem desta abstração.
@Repository
public interface PratoIngredienteRepository extends JpaRepository<PratoIngrediente, PratoIngredienteId> {

    List<PratoIngrediente> findByPratoIdPrato(String idPrato);

    void deleteByPratoIdPrato(String idPrato);
}