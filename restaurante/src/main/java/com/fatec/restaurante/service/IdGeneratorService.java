package com.fatec.restaurante.service;

import org.springframework.stereotype.Service;

import java.util.Random;

/**
 * SOLID - SRP: Responsável apenas por gerar identificadores únicos.
 * SOLID - OCP: Novos formatos de ID podem ser adicionados sem modificar os existentes.
 */
@Service
public class IdGeneratorService {

    private static final Random RANDOM = new Random();

    public String gerarIdPrato() {
        return "P" + String.format("%05d", RANDOM.nextInt(99999) + 1);
    }

    public String gerarIdIngrediente() {
        return "I" + String.format("%05d", RANDOM.nextInt(99999) + 1);
    }

    public String gerarIdPedido() {
        return "D" + String.format("%05d", RANDOM.nextInt(99999) + 1);
    }
}