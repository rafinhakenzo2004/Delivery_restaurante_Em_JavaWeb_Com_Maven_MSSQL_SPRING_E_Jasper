package com.fatec.restaurante.controller;

import com.fatec.restaurante.service.IngredienteService;
import com.fatec.restaurante.service.PratoIngredienteService;
import com.fatec.restaurante.service.PratoService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * SOLID - SRP: Responsável apenas pelo fluxo de associação Prato-Ingrediente.
 * SOLID - DIP: Depende das abstrações dos services.
 */
@Controller
@RequestMapping("/pratos/{idPrato}/ingredientes")
@RequiredArgsConstructor
public class PratoIngredienteController {

    private final PratoIngredienteService pratoIngredienteService;
    private final PratoService pratoService;
    private final IngredienteService ingredienteService;

    @GetMapping
    public String listar(@PathVariable String idPrato, Model model) {
        model.addAttribute("prato", pratoService.buscarPorId(idPrato));
        model.addAttribute("pratoIngredientes", pratoIngredienteService.listarPorPrato(idPrato));
        model.addAttribute("ingredientesDisponiveis", ingredienteService.listarTodos());
        return "pratoingrediente/lista";
    }

    @PostMapping("/adicionar")
    public String adicionar(@PathVariable String idPrato,
                            @RequestParam String idIngrediente,
                            @RequestParam Integer quantidade,
                            RedirectAttributes redirectAttributes) {
        try {
            pratoIngredienteService.associar(idPrato, idIngrediente, quantidade);
            redirectAttributes.addFlashAttribute("mensagem", "Ingrediente adicionado com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/pratos/" + idPrato + "/ingredientes";
    }

    @PostMapping("/{idIngrediente}/atualizar")
    public String atualizar(@PathVariable String idPrato,
                            @PathVariable String idIngrediente,
                            @RequestParam Integer quantidade,
                            RedirectAttributes redirectAttributes) {
        try {
            pratoIngredienteService.atualizarQuantidade(idPrato, idIngrediente, quantidade);
            redirectAttributes.addFlashAttribute("mensagem", "Quantidade atualizada com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/pratos/" + idPrato + "/ingredientes";
    }

    @PostMapping("/{idIngrediente}/remover")
    public String remover(@PathVariable String idPrato,
                          @PathVariable String idIngrediente,
                          RedirectAttributes redirectAttributes) {
        try {
            pratoIngredienteService.remover(idPrato, idIngrediente);
            redirectAttributes.addFlashAttribute("mensagem", "Ingrediente removido com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/pratos/" + idPrato + "/ingredientes";
    }
}