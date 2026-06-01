package com.fatec.restaurante.service;

import com.fatec.restaurante.model.Ingrediente;
import com.fatec.restaurante.model.Prato;
import com.fatec.restaurante.model.PratoIngrediente;
import com.fatec.restaurante.model.PratoIngredienteId;
import com.fatec.restaurante.repository.PratoIngredienteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

/**
 * SOLID - SRP: Responsável pelas regras de associação entre Prato e Ingrediente.
 * SOLID - DIP: Depende de abstrações de repositório e outros serviços.
 */
@Service
@RequiredArgsConstructor
public class PratoIngredienteService {

    private final PratoIngredienteRepository pratoIngredienteRepository;
    private final PratoService pratoService;
    private final IngredienteService ingredienteService;

    @Transactional(readOnly = true)
    public List<PratoIngrediente> listarPorPrato(String idPrato) {
        return pratoIngredienteRepository.findByPratoIdPrato(idPrato);
    }

    @Transactional
    public PratoIngrediente associar(String idPrato, String idIngrediente, Integer quantidade) {
        Prato prato = pratoService.buscarPorId(idPrato);
        Ingrediente ingrediente = ingredienteService.buscarPorId(idIngrediente);

        PratoIngredienteId id = new PratoIngredienteId(idPrato, idIngrediente);
        if (pratoIngredienteRepository.existsById(id)) {
            throw new IllegalArgumentException("Ingrediente já associado a este prato.");
        }

        PratoIngrediente pi = PratoIngrediente.builder()
                .id(id)
                .prato(prato)
                .ingrediente(ingrediente)
                .quantidade(quantidade)
                .build();

        return pratoIngredienteRepository.save(pi);
    }

    @Transactional
    public PratoIngrediente atualizarQuantidade(String idPrato, String idIngrediente, Integer quantidade) {
        PratoIngredienteId id = new PratoIngredienteId(idPrato, idIngrediente);
        PratoIngrediente pi = pratoIngredienteRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Associação não encontrada."));
        pi.setQuantidade(quantidade);
        return pratoIngredienteRepository.save(pi);
    }

    @Transactional
    public void remover(String idPrato, String idIngrediente) {
        PratoIngredienteId id = new PratoIngredienteId(idPrato, idIngrediente);
        if (!pratoIngredienteRepository.existsById(id)) {
            throw new NoSuchElementException("Associação não encontrada.");
        }
        pratoIngredienteRepository.deleteById(id);
    }
}