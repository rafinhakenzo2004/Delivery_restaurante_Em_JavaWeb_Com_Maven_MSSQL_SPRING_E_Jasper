package com.fatec.restaurante.model;

import lombok.*;
 
import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
 
//SOLID - SRP: Responsável apenas por representar o domínio Ingrediente.

@Entity
@Table(name = "Ingrediente")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "idIngrediente")
@ToString(exclude = "pratoIngredientes")
public class Ingrediente {
 
    @Id
    @Column(name = "idIngrediente", length = 6, nullable = false)
    private String idIngrediente;
 
    @NotBlank(message = "Nome é obrigatório")
    @Size(max = 100, message = "Nome deve ter no máximo 100 caracteres")
    @Column(name = "nome", length = 100, nullable = false)
    private String nome;
 
    @NotBlank(message = "Apresentação é obrigatória")
    @Size(max = 200, message = "Apresentação deve ter no máximo 200 caracteres")
    @Column(name = "apresentacao", length = 200, nullable = false)
    private String apresentacao;
 
    @OneToMany(mappedBy = "ingrediente", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<PratoIngrediente> pratoIngredientes = new HashSet<>();
}