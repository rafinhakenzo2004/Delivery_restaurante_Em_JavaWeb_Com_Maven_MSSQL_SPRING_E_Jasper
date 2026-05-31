package com.fatec.restaurante.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

//SOLID - SRP: Responsável apenas por representar a associação Prato-Pedido.

@Entity
@Table(name = "PratoPedido")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "id")
public class PratoPedido {

    @EmbeddedId
    private PratoPedidoId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idPrato")
    @JoinColumn(name = "idPrato")
    private Prato prato;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idPedido")
    @JoinColumn(name = "idPedido")
    private Pedido pedido;

    @NotNull(message = "Quantidade é obrigatória")
    @Positive(message = "Quantidade deve ser maior que zero")
    @Column(name = "quantidade", nullable = false)
    private Integer quantidade;
}