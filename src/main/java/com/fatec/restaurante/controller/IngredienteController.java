package com.fatec.restaurante.controller;

import com.fatec.restaurante.model.Ingrediente;
import com.fatec.restaurante.service.IngredienteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * SOLID - SRP: Responsável apenas pelo fluxo HTTP de Ingrediente.
 * SOLID - DIP: Depende da abstração IngredienteService.
 */
@Controller
@RequestMapping("/ingredientes")
@RequiredArgsConstructor
public class IngredienteController {

    private final IngredienteService ingredienteService;

    @GetMapping
    public String listar(@RequestParam(required = false) String nome, Model model) {
        List<Ingrediente> ingredientes = (nome != null && !nome.isBlank())
                ? ingredienteService.buscarPorNome(nome)
                : ingredienteService.listarTodos();
        model.addAttribute("ingredientes", ingredientes);
        model.addAttribute("busca", nome);
        return "ingrediente/lista";
    }

    @GetMapping("/novo")
    public String formularioNovo(Model model) {
        model.addAttribute("ingrediente", new Ingrediente());
        model.addAttribute("modo", "novo");
        return "ingrediente/formulario";
    }

    @PostMapping("/novo")
    public String salvar(@Valid @ModelAttribute("ingrediente") Ingrediente ingrediente,
                         BindingResult result,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("modo", "novo");
            return "ingrediente/formulario";
        }
        try {
            ingredienteService.salvar(ingrediente);
            redirectAttributes.addFlashAttribute("mensagem", "Ingrediente cadastrado com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/ingredientes";
    }

    @GetMapping("/{id}")
    public String detalhe(@PathVariable("id") String idIngrediente, Model model) {
        model.addAttribute("ingrediente", ingredienteService.buscarPorId(idIngrediente));
        return "ingrediente/detalhe";
    }

    @GetMapping("/{id}/editar")
    public String formularioEditar(@PathVariable("id") String idIngrediente, Model model) {
        model.addAttribute("ingrediente", ingredienteService.buscarPorId(idIngrediente));
        model.addAttribute("modo", "editar");
        return "ingrediente/formulario";
    }

    @PostMapping("/{id}/editar")
    public String atualizar(@PathVariable("id") String idIngrediente,
                            @Valid @ModelAttribute("ingrediente") Ingrediente atualizado,
                            BindingResult result,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("modo", "editar");
            return "ingrediente/formulario";
        }
        try {
            ingredienteService.atualizar(idIngrediente, atualizado);
            redirectAttributes.addFlashAttribute("mensagem", "Ingrediente atualizado com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/ingredientes";
    }

    @PostMapping("/{id}/excluir")
    public String excluir(@PathVariable("id") String idIngrediente, RedirectAttributes redirectAttributes) {
        try {
            ingredienteService.excluir(idIngrediente);
            redirectAttributes.addFlashAttribute("mensagem", "Ingrediente excluído com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/ingredientes";
    }
}