package com.fatec.restaurante.service;

import com.fatec.restaurante.model.Prato;
import com.fatec.restaurante.model.TipoPrato;
import com.fatec.restaurante.repository.PratoRepository;
import com.fatec.restaurante.repository.TipoPratoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

/**
 * SOLID - SRP: Responsável apenas pelas regras de negócio de Prato.
 * SOLID - DIP: Depende das abstrações PratoRepository e TipoPratoRepository.
 * SOLID - OCP: Novas regras podem ser adicionadas sem alterar o contrato existente.
 */
@Service
@RequiredArgsConstructor
public class PratoService {

    private final PratoRepository pratoRepository;
    private final TipoPratoRepository tipoPratoRepository;
    private final IdGeneratorService idGeneratorService;

    @Transactional(readOnly = true)
    public List<Prato> listarTodos() {
        return pratoRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Prato buscarPorId(String idPrato) {
        return pratoRepository.findById(idPrato)
                .orElseThrow(() -> new NoSuchElementException("Prato não encontrado: " + idPrato));
    }

    @Transactional(readOnly = true)
    public List<Prato> buscarPorTipo(String tipo) {
        return pratoRepository.findByTipoNomeTipoIgnoreCase(tipo);
    }

    @Transactional(readOnly = true)
    public List<String> listarTipos() {
        return pratoRepository.findDistinctTipos();
    }

    /**
     * Salva um novo tipo de prato.
     * Retorna o objeto TipoPrato salvo para que o controller possa devolvê-lo
     * como JSON ao fetch do modal.
     *
     * Lança IllegalArgumentException se já existir um tipo com o mesmo nome.
     */
    @Transactional
    public TipoPrato salvarTipo(String nomeTipo) {
        if (nomeTipo == null || nomeTipo.isBlank()) {
            throw new IllegalArgumentException("O nome do tipo não pode ser vazio.");
        }
        String nome = nomeTipo.trim();
        if (tipoPratoRepository.existsByNomeTipoIgnoreCase(nome)) {
            throw new IllegalArgumentException("Já existe um tipo com o nome: " + nome);
        }
        TipoPrato novo = TipoPrato.builder().nomeTipo(nome).build();
        return tipoPratoRepository.save(novo);
    }

    @Transactional(readOnly = true)
    public List<Prato> listarComIngredientes() {
        return pratoRepository.findAllComIngredientes();
    }

    @Transactional(readOnly = true)
    public List<Object[]> listarPratosUDF() {
        return pratoRepository.listarPratosComIngredientesUDF();
    }

    @Transactional(readOnly = true)
    public List<Prato> buscarPorTipoComIngredientes(String tipo) {
        return pratoRepository.findByTipoComIngredientes(tipo);
    }

    @Transactional
    public Prato salvar(Prato prato) {
        if (prato.getIdPrato() == null || prato.getIdPrato().isBlank()) {
            String novoId;
            do {
                novoId = idGeneratorService.gerarIdPrato();
            } while (pratoRepository.existsById(novoId));
            prato.setIdPrato(novoId);
        }
        return pratoRepository.save(prato);
    }

    @Transactional
    public Prato atualizar(String idPrato, Prato pratoAtualizado) {
        Prato existente = buscarPorId(idPrato);
        existente.setNome(pratoAtualizado.getNome());
        existente.setPorcao(pratoAtualizado.getPorcao());
        existente.setValor(pratoAtualizado.getValor());
        existente.setTipo(pratoAtualizado.getTipo());
        return pratoRepository.save(existente);
    }

    @Transactional
    public void excluir(String idPrato) {
        if (!pratoRepository.existsById(idPrato)) {
            throw new NoSuchElementException("Prato não encontrado: " + idPrato);
        }
        pratoRepository.deleteById(idPrato);
    }

    @Transactional(readOnly = true)
    public boolean existe(String idPrato) {
        return pratoRepository.existsById(idPrato);
    }

    @Transactional(readOnly = true)
    public Optional<Prato> buscarOptional(String idPrato) {
        return pratoRepository.findById(idPrato);
    }

    @Transactional(readOnly = true)
    public List<TipoPrato> listarTodosTiposObjetos() {
        return tipoPratoRepository.findAll();
    }
}