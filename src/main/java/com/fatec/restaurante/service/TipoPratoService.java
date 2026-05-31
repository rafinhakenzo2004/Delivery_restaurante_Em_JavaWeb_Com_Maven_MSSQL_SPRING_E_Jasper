package com.fatec.restaurante.service;

import com.fatec.restaurante.model.TipoPrato;
import com.fatec.restaurante.repository.TipoPratoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

/**
 * SOLID - SRP: Responsável apenas pelas regras de negócio de TipoPrato.
 * SOLID - DIP: Depende da abstração TipoPratoRepository.
 */
@Service
@RequiredArgsConstructor
public class TipoPratoService {

    private final TipoPratoRepository tipoPratoRepository;

    @Transactional(readOnly = true)
    public List<TipoPrato> listarTodos() {
        return tipoPratoRepository.findAll();
    }

    @Transactional(readOnly = true)
    public TipoPrato buscarPorId(Integer id) {
        return tipoPratoRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Tipo não encontrado: " + id));
    }

    @Transactional
    public TipoPrato salvar(TipoPrato tipo) {
        if (tipoPratoRepository.existsByNomeTipoIgnoreCase(tipo.getNomeTipo())) {
            throw new IllegalArgumentException("Já existe um tipo com o nome: " + tipo.getNomeTipo());
        }
        return tipoPratoRepository.save(tipo);
    }

    @Transactional
    public void excluir(Integer id) {
        if (!tipoPratoRepository.existsById(id)) {
            throw new NoSuchElementException("Tipo não encontrado: " + id);
        }
        tipoPratoRepository.deleteById(id);
    }
}