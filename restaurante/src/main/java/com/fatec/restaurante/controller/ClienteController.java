package com.fatec.restaurante.controller;

import com.fatec.restaurante.model.Cliente;
import com.fatec.restaurante.service.ClienteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * SOLID - SRP: Responsável apenas pelo fluxo HTTP de Cliente.
 * SOLID - DIP: Depende da abstração ClienteService.
 */
@Controller
@RequestMapping("/clientes")
@RequiredArgsConstructor
public class ClienteController {

    private final ClienteService clienteService;

    @GetMapping
    public String listar(@RequestParam(required = false) String nome, Model model) {
        List<Cliente> clientes = (nome != null && !nome.isBlank())
                ? clienteService.buscarPorNome(nome)
                : clienteService.listarTodos();
        model.addAttribute("clientes", clientes);
        model.addAttribute("busca", nome);
        return "cliente/lista";
    }

    @GetMapping("/novo")
    public String formularioNovo(Model model) {
        model.addAttribute("cliente", new Cliente());
        model.addAttribute("modo", "novo");
        return "cliente/formulario";
    }

    @PostMapping("/novo")
    public String salvar(@Valid @ModelAttribute("cliente") Cliente cliente,
                         BindingResult result,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("modo", "novo");
            return "cliente/formulario";
        }
        try {
            clienteService.salvar(cliente);
            redirectAttributes.addFlashAttribute("mensagem", "Cliente cadastrado com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (IllegalArgumentException e) {
            // CPF já cadastrado
            result.rejectValue("cpf", "cpf.duplicado", e.getMessage());
            model.addAttribute("modo", "novo");
            return "cliente/formulario";
        }
        return "redirect:/clientes";
    }

    @GetMapping("/{cpf}")
    public String detalhe(@PathVariable String cpf, Model model) {
        model.addAttribute("cliente", clienteService.buscarPorCpf(cpf));
        return "cliente/detalhe";
    }

    @GetMapping("/{cpf}/editar")
    public String formularioEditar(@PathVariable String cpf, Model model) {
        model.addAttribute("cliente", clienteService.buscarPorCpf(cpf));
        model.addAttribute("modo", "editar");
        return "cliente/formulario";
    }

    @PostMapping("/{cpf}/editar")
    public String atualizar(@PathVariable String cpf,
                            @Valid @ModelAttribute("cliente") Cliente atualizado,
                            BindingResult result,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("modo", "editar");
            return "cliente/formulario";
        }
        try {
            clienteService.atualizar(cpf, atualizado);
            redirectAttributes.addFlashAttribute("mensagem", "Cliente atualizado com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/clientes";
    }

    @PostMapping("/{cpf}/excluir")
    public String excluir(@PathVariable String cpf, RedirectAttributes redirectAttributes) {
        try {
            clienteService.excluir(cpf);
            redirectAttributes.addFlashAttribute("mensagem", "Cliente excluído com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/clientes";
    }
}