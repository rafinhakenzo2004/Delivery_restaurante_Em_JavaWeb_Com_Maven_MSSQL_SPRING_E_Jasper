package com.fatec.restaurante.model;
 
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
 
import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Set;
 
/**
 * SOLID - SRP: Esta classe é responsável apenas por representar o domínio Prato.
 * SOLID - OCP: A entidade pode ser estendida sem modificação via herança ou composição JPA.
 */
@Entity
@Table(name = "Prato")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "idPrato")
@ToString(exclude = {"pratoPedidos", "pratoIngrediente", "tipo"}) // Adicionado 'tipo' aqui
public class Prato {
 
    @Id
    @Column(name = "idPrato", length = 6, nullable = false)
    private String idPrato;
 
    @NotBlank(message = "Nome é obrigatório")
    @Size(max = 100, message = "Nome deve ter no máximo 100 caracteres")
    @Column(name = "nome", length = 100, nullable = false)
    private String nome;
 
    @NotBlank(message = "Porção é obrigatória")
    @Column(name = "porcao", length = 20, nullable = false)
    private String porcao;
 
    @NotNull(message = "Valor é obrigatório")
    @DecimalMin(value = "0.01", message = "Valor deve ser maior que zero")
    @Digits(integer = 8, fraction = 2, message = "Valor inválido")
    @Column(name = "valor", nullable = false, precision = 10, scale = 2)
    private BigDecimal valor;
 
    // MUDANÇA AQUI: De String para o relacionamento ManyToOne com a nova tabela
    @NotNull(message = "O tipo do prato é obrigatório")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_tipo", nullable = false)
    private TipoPrato tipo;
 
    @OneToMany(mappedBy = "prato", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<PratoPedido> pratoPedidos = new HashSet<>();
 
    @OneToMany(mappedBy = "prato", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<PratoIngrediente> pratoIngredientes = new HashSet<>();
}