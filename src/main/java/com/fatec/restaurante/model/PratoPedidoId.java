package com.fatec.restaurante.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;

//SOLID - SRP: Responsável apenas por representar a chave composta.

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class PratoPedidoId implements Serializable {

    @Column(name = "idPrato", length = 6)
    private String idPrato;

    @Column(name = "idPedido", length = 6)
    private String idPedido;
}