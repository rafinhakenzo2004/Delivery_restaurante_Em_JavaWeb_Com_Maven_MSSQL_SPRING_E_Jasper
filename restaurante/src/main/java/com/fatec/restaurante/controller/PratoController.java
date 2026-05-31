package com.fatec.restaurante.controller;

import com.fatec.restaurante.model.Prato;
import com.fatec.restaurante.model.TipoPrato;
import com.fatec.restaurante.service.IngredienteService;
import com.fatec.restaurante.service.PratoService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * SOLID - SRP: Responsável apenas pelo fluxo HTTP de Prato.
 * SOLID - DIP: Depende das abstrações PratoService e IngredienteService.
 */
@Controller
@RequestMapping("/pratos")
@RequiredArgsConstructor
public class PratoController {

    private final PratoService pratoService;
    private final IngredienteService ingredienteService;
    private final DataSource dataSource;

    @GetMapping
    public String listar(@RequestParam(required = false) String tipo, Model model) {
        List<Prato> pratos = (tipo != null && !tipo.isBlank())
                ? pratoService.buscarPorTipo(tipo)
                : pratoService.listarTodos();
        model.addAttribute("pratos", pratos);
        model.addAttribute("tipos", pratoService.listarTipos());
        model.addAttribute("tipoSelecionado", tipo);
        return "prato/lista";
    }

    @GetMapping("/com-ingredientes")
    public String listarComIngredientesUDF(@RequestParam(required = false) String tipo, Model model) {
        List<Object[]> pratos = pratoService.listarPratosUDF();

        if (tipo != null && !tipo.isBlank()) {
            pratos = pratos.stream()
                    .filter(row -> row[4] != null && row[4].toString().equalsIgnoreCase(tipo.trim()))
                    .toList();
        }

        model.addAttribute("pratos", pratos);
        model.addAttribute("tipos", pratoService.listarTipos());
        model.addAttribute("tipoSelecionado", tipo);
        return "prato/lista-ingredientes";
    }

    @GetMapping("/relatorio-tipo")
    public void gerarPdfPorTipo(@RequestParam("tipo") String tipo, HttpServletResponse response) {
        try {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=relatorio_pratos_" + tipo + ".pdf");

            Map<String, Object> params = new HashMap<>();
            params.put("tipo_prato", tipo);

            try (Connection conn = dataSource.getConnection()) {
                InputStream stream = getClass().getResourceAsStream("/reports/ListaDePratosPorTipo.jasper");

                if (stream == null) {
                    throw new RuntimeException("Arquivo Jasper não encontrado em /reports/");
                }

                JasperPrint jasperPrint = JasperFillManager.fillReport(stream, params, conn);
                JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao gerar o relatório PDF: " + e.getMessage());
        }
    }

    @GetMapping("/novo")
    public String formularioNovo(Model model) {
        model.addAttribute("prato", new Prato());
        model.addAttribute("modo", "novo");
        model.addAttribute("tipos", pratoService.listarTodosTiposObjetos());
        return "prato/formulario";
    }

    @PostMapping("/novo")
    public String salvar(@Valid @ModelAttribute("prato") Prato prato,
                         BindingResult result,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("modo", "novo");
            model.addAttribute("tipos", pratoService.listarTodosTiposObjetos());
            return "prato/formulario";
        }
        try {
            pratoService.salvar(prato);
            redirectAttributes.addFlashAttribute("mensagem", "Prato cadastrado com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro ao cadastrar prato: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/pratos";
    }

    @GetMapping("/{id}")
    public String detalhe(@PathVariable("id") String idPrato, Model model) {
        model.addAttribute("prato", pratoService.buscarPorId(idPrato));
        return "prato/detalhe";
    }

    @GetMapping("/{id}/editar")
    public String formularioEditar(@PathVariable("id") String idPrato, Model model) {
        model.addAttribute("prato", pratoService.buscarPorId(idPrato));
        model.addAttribute("modo", "editar");
        model.addAttribute("tipos", pratoService.listarTodosTiposObjetos());
        return "prato/formulario";
    }

    @PostMapping("/{id}/editar")
    public String atualizar(@PathVariable("id") String idPrato,
                            @Valid @ModelAttribute("prato") Prato pratoAtualizado,
                            BindingResult result,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("modo", "editar");
            model.addAttribute("tipos", pratoService.listarTodosTiposObjetos());
            return "prato/formulario";
        }
        try {
            pratoService.atualizar(idPrato, pratoAtualizado);
            redirectAttributes.addFlashAttribute("mensagem", "Prato atualizado com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro ao atualizar prato: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/pratos";
    }

    @PostMapping("/{id}/excluir")
    public String excluir(@PathVariable("id") String idPrato, RedirectAttributes redirectAttributes) {
        try {
            pratoService.excluir(idPrato);
            redirectAttributes.addFlashAttribute("mensagem", "Prato excluído com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro ao excluir prato: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/pratos";
    }

    /**
     * Endpoint chamado via fetch (AJAX) pelo modal do formulário de prato.
     * Retorna o TipoPrato criado como JSON para que o select seja atualizado
     * dinamicamente sem recarregar a página nem interferir no form principal.
     *
     * SOLID - SRP: Responsável apenas por receber a requisição e delegar ao service.
     */
    @PostMapping("/tipos/novo")
    @ResponseBody
    public ResponseEntity<TipoPrato> salvarNovoTipo(@RequestParam("nomeTipo") String nomeTipo) {
        try {
            TipoPrato salvo = pratoService.salvarTipo(nomeTipo);
            return ResponseEntity.ok(salvo);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }
}