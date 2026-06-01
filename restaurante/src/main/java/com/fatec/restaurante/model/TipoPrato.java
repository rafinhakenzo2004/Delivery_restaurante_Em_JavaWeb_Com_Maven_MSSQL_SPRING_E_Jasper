package com.fatec.restaurante.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

@Entity
@Table(name = "tb_tipo_prato")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "idTipo")
@ToString
public class TipoPrato {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tipo")
    private Integer idTipo;

    @NotBlank(message = "O nome do tipo é obrigatório")
    @Size(max = 50, message = "O tipo deve ter no máximo 50 caracteres")
    @Column(name = "nome_tipo", length = 50, nullable = false, unique = true)
    private String nomeTipo;
}