package com.fatec.restaurante.repository;

import com.fatec.restaurante.model.PratoPedido;
import com.fatec.restaurante.model.PratoPedidoId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

//SOLID - DIP: Camadas superiores dependem desta abstração.
@Repository
public interface PratoPedidoRepository extends JpaRepository<PratoPedido, PratoPedidoId> {

    List<PratoPedido> findByPedidoIdPedido(String idPedido);

    void deleteByPedidoIdPedido(String idPedido);
}