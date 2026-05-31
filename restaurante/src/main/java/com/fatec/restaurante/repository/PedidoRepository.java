package com.fatec.restaurante.repository;

import com.fatec.restaurante.model.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * SOLID - DIP: Camadas superiores dependem desta abstração.
 * SOLID - ISP: Expõe apenas os métodos relevantes ao domínio Pedido.
 */
@Repository
public interface PedidoRepository extends JpaRepository<Pedido, String> {

    List<Pedido> findByClienteCpf(String cpf);

    Optional<Pedido> findTopByClienteCpfOrderByDataRealizacaoDesc(String cpf);

    @Query("""
        SELECT DISTINCT p FROM Pedido p
        LEFT JOIN FETCH p.cliente
        LEFT JOIN FETCH p.pratoPedidos pp
        LEFT JOIN FETCH pp.prato prato
        LEFT JOIN FETCH prato.pratoIngredientes pi
        LEFT JOIN FETCH pi.ingrediente
        WHERE p.dataRealizacao = :data
    """)
    List<Pedido> findByDataRealizacaoComDetalhes(@Param("data") LocalDate data);

    @Query("""
        SELECT DISTINCT p FROM Pedido p
        LEFT JOIN FETCH p.cliente
        LEFT JOIN FETCH p.pratoPedidos pp
        LEFT JOIN FETCH pp.prato
        WHERE p.idPedido = :idPedido
    """)
    Optional<Pedido> findByIdComDetalhes(@Param("idPedido") String idPedido);
}