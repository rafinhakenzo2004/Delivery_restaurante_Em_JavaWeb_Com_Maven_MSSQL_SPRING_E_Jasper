package com.fatec.restaurante.service;

import com.fatec.restaurante.model.Cliente;
import com.fatec.restaurante.repository.ClienteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

/**
 * SOLID - SRP: Responsável apenas pelas regras de negócio de Cliente.
 * SOLID - DIP: Depende da abstração ClienteRepository.
 */
@Service
@RequiredArgsConstructor
public class ClienteService {

    private final ClienteRepository clienteRepository;

    @Transactional(readOnly = true)
    public List<Cliente> listarTodos() {
        return clienteRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Cliente buscarPorCpf(String cpf) {
        return clienteRepository.findById(cpf)
                .orElseThrow(() -> new NoSuchElementException("Cliente não encontrado: CPF " + cpf));
    }

    @Transactional(readOnly = true)
    public List<Cliente> buscarPorNome(String nome) {
        return clienteRepository.findByNomeContainingIgnoreCase(nome);
    }

    @Transactional
    public Cliente salvar(Cliente cliente) {
        if (clienteRepository.existsById(cliente.getCpf())) {
            throw new IllegalArgumentException("Já existe um cliente cadastrado com o CPF: " + cliente.getCpf());
        }
        return clienteRepository.save(cliente);
    }

    @Transactional
    public Cliente atualizar(String cpf, Cliente atualizado) {
        Cliente existente = buscarPorCpf(cpf);
        existente.setNome(atualizado.getNome());
        existente.setTelefone(atualizado.getTelefone());
        existente.setLogradouro(atualizado.getLogradouro());
        existente.setNumero(atualizado.getNumero());
        existente.setCep(atualizado.getCep());
        existente.setReferenciaEntrega(atualizado.getReferenciaEntrega());
        return clienteRepository.save(existente);
    }

    @Transactional
    public void excluir(String cpf) {
        if (!clienteRepository.existsById(cpf)) {
            throw new NoSuchElementException("Cliente não encontrado: CPF " + cpf);
        }
        clienteRepository.deleteById(cpf);
    }

    @Transactional(readOnly = true)
    public boolean existe(String cpf) {
        return clienteRepository.existsById(cpf);
    }
}