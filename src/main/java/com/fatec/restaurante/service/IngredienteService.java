package com.fatec.restaurante.service;

import com.fatec.restaurante.model.Ingrediente;
import com.fatec.restaurante.repository.IngredienteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

/**
 * SOLID - SRP: Responsável apenas pelas regras de negócio de Ingrediente.
 * SOLID - DIP: Depende da abstração IngredienteRepository.
 */
@Service
@RequiredArgsConstructor
public class IngredienteService {

    private final IngredienteRepository ingredienteRepository;
    private final IdGeneratorService idGeneratorService;

    @Transactional(readOnly = true)
    public List<Ingrediente> listarTodos() {
        return ingredienteRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Ingrediente buscarPorId(String idIngrediente) {
        return ingredienteRepository.findById(idIngrediente)
                .orElseThrow(() -> new NoSuchElementException("Ingrediente não encontrado: " + idIngrediente));
    }

    @Transactional(readOnly = true)
    public List<Ingrediente> buscarPorNome(String nome) {
        return ingredienteRepository.findByNomeContainingIgnoreCase(nome);
    }

    @Transactional
    public Ingrediente salvar(Ingrediente ingrediente) {
        if (ingrediente.getIdIngrediente() == null || ingrediente.getIdIngrediente().isBlank()) {
            String novoId;
            do {
                novoId = idGeneratorService.gerarIdIngrediente();
            } while (ingredienteRepository.existsById(novoId));
            ingrediente.setIdIngrediente(novoId);
        }
        return ingredienteRepository.save(ingrediente);
    }

    @Transactional
    public Ingrediente atualizar(String idIngrediente, Ingrediente atualizado) {
        Ingrediente existente = buscarPorId(idIngrediente);
        existente.setNome(atualizado.getNome());
        existente.setApresentacao(atualizado.getApresentacao());
        return ingredienteRepository.save(existente);
    }

    @Transactional
    public void excluir(String idIngrediente) {
        if (!ingredienteRepository.existsById(idIngrediente)) {
            throw new NoSuchElementException("Ingrediente não encontrado: " + idIngrediente);
        }
        ingredienteRepository.deleteById(idIngrediente);
    }
}