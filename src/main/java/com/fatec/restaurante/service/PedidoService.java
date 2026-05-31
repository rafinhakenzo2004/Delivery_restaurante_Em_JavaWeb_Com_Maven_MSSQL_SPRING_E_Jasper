package com.fatec.restaurante.service;

import com.fatec.restaurante.model.*;
import com.fatec.restaurante.repository.PedidoRepository;
import com.fatec.restaurante.repository.PratoPedidoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

/**
 * SOLID - SRP: Responsável apenas pelas regras de negócio de Pedido.
 * SOLID - DIP: Depende das abstrações PedidoRepository, PratoPedidoRepository e PratoService.
 */
@Service
@RequiredArgsConstructor
public class PedidoService {

    private final PedidoRepository pedidoRepository;
    private final PratoPedidoRepository pratoPedidoRepository;
    private final PratoService pratoService;
    private final ClienteService clienteService;
    private final IdGeneratorService idGeneratorService;

    @Transactional(readOnly = true)
    public List<Pedido> listarTodos() {
        return pedidoRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Pedido buscarPorId(String idPedido) {
        return pedidoRepository.findByIdComDetalhes(idPedido)
                .orElseThrow(() -> new NoSuchElementException("Pedido não encontrado: " + idPedido));
    }

    @Transactional(readOnly = true)
    public List<Pedido> buscarPorCliente(String cpf) {
        return pedidoRepository.findByClienteCpf(cpf);
    }

    @Transactional(readOnly = true)
    public Pedido buscarPedidoAtualDoCliente(String cpf) {
        return pedidoRepository.findTopByClienteCpfOrderByDataRealizacaoDesc(cpf)
                .orElseThrow(() -> new NoSuchElementException("Nenhum pedido encontrado para o CPF: " + cpf));
    }

    @Transactional(readOnly = true)
    public List<Pedido> buscarPorData(LocalDate data) {
        return pedidoRepository.findByDataRealizacaoComDetalhes(data);
    }

    @Transactional
    public Pedido criarPedido(String cpfCliente, Map<String, Integer> itensPedido) {
        Cliente cliente = clienteService.buscarPorCpf(cpfCliente);

        String idPedido;
        do {
            idPedido = idGeneratorService.gerarIdPedido();
        } while (pedidoRepository.existsById(idPedido));

        BigDecimal valorTotal = BigDecimal.ZERO;
        for (Map.Entry<String, Integer> item : itensPedido.entrySet()) {
            Prato prato = pratoService.buscarPorId(item.getKey());
            valorTotal = valorTotal.add(prato.getValor().multiply(BigDecimal.valueOf(item.getValue())));
        }

        Pedido pedido = Pedido.builder()
                .idPedido(idPedido)
                .cliente(cliente)
                .dataRealizacao(LocalDate.now())
                .valorTotal(valorTotal)
                .build();

        pedidoRepository.save(pedido);

        for (Map.Entry<String, Integer> item : itensPedido.entrySet()) {
            Prato prato = pratoService.buscarPorId(item.getKey());
            PratoPedido pratoPedido = PratoPedido.builder()
                    .id(new PratoPedidoId(prato.getIdPrato(), idPedido))
                    .prato(prato)
                    .pedido(pedido)
                    .quantidade(item.getValue())
                    .build();
            pratoPedidoRepository.save(pratoPedido);
        }

        return pedidoRepository.findByIdComDetalhes(idPedido).orElseThrow();
    }

    @Transactional
    public Pedido atualizar(String idPedido, Pedido atualizado) {
        Pedido existente = buscarPorId(idPedido);
        existente.setDataRealizacao(atualizado.getDataRealizacao());
        existente.setValorTotal(atualizado.getValorTotal());
        return pedidoRepository.save(existente);
    }

    @Transactional
    public void excluir(String idPedido) {
        if (!pedidoRepository.existsById(idPedido)) {
            throw new NoSuchElementException("Pedido não encontrado: " + idPedido);
        }
        pratoPedidoRepository.deleteByPedidoIdPedido(idPedido);
        pedidoRepository.deleteById(idPedido);
    }
}