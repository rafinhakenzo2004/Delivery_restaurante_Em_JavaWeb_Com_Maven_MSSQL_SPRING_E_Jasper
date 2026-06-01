package com.fatec.restaurante.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

// SOLID - SRP: Responsável apenas por representar a associação Prato-Ingrediente.

@Entity
@Table(name = "PratoIngrediente")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "id")
public class PratoIngrediente {

    @EmbeddedId
    private PratoIngredienteId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idPrato")
    @JoinColumn(name = "idPrato")
    private Prato prato;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idIngrediente")
    @JoinColumn(name = "idIngrediente")
    private Ingrediente ingrediente;

    @NotNull(message = "Quantidade é obrigatória")
    @Positive(message = "Quantidade deve ser maior que zero")
    @Column(name = "quantidade", nullable = false)
    private Integer quantidade;
}