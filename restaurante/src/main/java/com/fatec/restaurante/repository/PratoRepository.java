package com.fatec.restaurante.repository;
 
import com.fatec.restaurante.model.Prato;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
 
import java.util.List;
 
/**
 * SOLID - ISP (Interface Segregation Principle):
 * Cada repositório expõe apenas os métodos relevantes ao seu domínio.
 *
 * SOLID - DIP (Dependency Inversion Principle):
 * As camadas superiores dependem desta abstração (interface), não de implementações concretas.
 */
@Repository
public interface PratoRepository extends JpaRepository<Prato, String> {
 
    List<Prato> findByTipoNomeTipoIgnoreCase(String tipo);
 
    List<Prato> findByNomeContainingIgnoreCase(String nome);
 
    List<Prato> findByPorcao(String porcao);
 
    @Query(value = "SELECT nome_tipo FROM tb_tipo_prato ORDER BY nome_tipo ASC", nativeQuery = true)
    List<String> findDistinctTipos();
 
    @Modifying
    @Transactional
    @Query(value = "INSERT INTO tb_tipo_prato (nome_tipo) VALUES (:nomeTipo)", nativeQuery = true)
    void salvarNovoTipo(@Param("nomeTipo") String nomeTipo);
 
    @Query(value = "SELECT * FROM dbo.fnListarPratoIngrediente()", nativeQuery = true)
    List<Object[]> listarPratosComIngredientesUDF();
 
    @Query("SELECT DISTINCT p FROM Prato p LEFT JOIN FETCH p.pratoIngredientes pi LEFT JOIN FETCH pi.ingrediente")
    List<Prato> findAllComIngredientes();
 
    @Query("SELECT DISTINCT p FROM Prato p LEFT JOIN FETCH p.pratoIngredientes pi LEFT JOIN FETCH pi.ingrediente WHERE p.tipo.nomeTipo = :tipo")
    List<Prato> findByTipoComIngredientes(@Param("tipo") String tipo);
    
    @Query("SELECT t FROM TipoPrato t ORDER BY t.nomeTipo ASC")
    List<com.fatec.restaurante.model.TipoPrato> findAllTiposObjetos();
}