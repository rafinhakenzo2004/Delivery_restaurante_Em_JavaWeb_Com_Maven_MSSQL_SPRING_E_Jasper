package com.fatec.restaurante.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

//SOLID - SRP: Responsável apenas por representar o domínio Pedido.

@Entity
@Table(name = "Pedido")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "idPedido")
@ToString(exclude = {"cliente", "pratoPedidos"})
public class Pedido {

    @Id
    @Column(name = "idPedido", length = 6, nullable = false)
    private String idPedido;

    @NotNull(message = "Cliente é obrigatório")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ClienteCpf", nullable = false)
    private Cliente cliente;

    @NotNull(message = "Data de realização é obrigatória")
    @Column(name = "dataRealizacao", nullable = false)
    private LocalDate dataRealizacao;

    @NotNull(message = "Valor total é obrigatório")
    @DecimalMin(value = "0.00", message = "Valor total não pode ser negativo")
    @Digits(integer = 8, fraction = 2)
    @Column(name = "valorTotal", nullable = false, precision = 10, scale = 2)
    private BigDecimal valorTotal;

    @OneToMany(mappedBy = "pedido", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<PratoPedido> pratoPedidos = new HashSet<>();
}