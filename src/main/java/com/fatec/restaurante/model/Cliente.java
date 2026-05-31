package com.fatec.restaurante.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

//SOLID - SRP: Responsável apenas por representar o domínio Cliente.
@Entity
@Table(name = "Cliente")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "cpf")
@ToString(exclude = "pedidos")
public class Cliente {

    @Id
    @Column(name = "cpf", length = 11, nullable = false)
    @NotBlank(message = "CPF é obrigatório")
    @Size(min = 11, max = 11, message = "CPF deve ter exatamente 11 dígitos")
    @Pattern(regexp = "\\d{11}", message = "CPF deve conter apenas números")
    private String cpf;

    @NotBlank(message = "Nome é obrigatório")
    @Size(max = 100, message = "Nome deve ter no máximo 100 caracteres")
    @Column(name = "nome", length = 100, nullable = false)
    private String nome;

    @NotBlank(message = "Telefone é obrigatório")
    @Size(max = 14, message = "Telefone deve ter no máximo 14 caracteres")
    @Column(name = "telefone", length = 14, nullable = false)
    private String telefone;

    @NotBlank(message = "Logradouro é obrigatório")
    @Size(max = 100, message = "Logradouro deve ter no máximo 100 caracteres")
    @Column(name = "logradouro", length = 100, nullable = false)
    private String logradouro;

    @NotNull(message = "Número é obrigatório")
    @Positive(message = "Número deve ser positivo")
    @Column(name = "numero", nullable = false)
    private Integer numero;

    @NotBlank(message = "CEP é obrigatório")
    @Size(max = 14, message = "CEP deve ter no máximo 14 caracteres")
    @Column(name = "cep", length = 14, nullable = false)
    private String cep;

    @NotBlank(message = "Referência de entrega é obrigatória")
    @Size(max = 50, message = "Referência deve ter no máximo 50 caracteres")
    @Column(name = "referenciaEntrega", length = 50, nullable = false)
    private String referenciaEntrega;

    @OneToMany(mappedBy = "cliente", cascade = CascadeType.ALL)
    private List<Pedido> pedidos = new ArrayList<>();
}