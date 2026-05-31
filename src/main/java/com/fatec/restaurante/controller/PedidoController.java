package com.fatec.restaurante.controller;

import com.fatec.restaurante.model.Pedido;
import com.fatec.restaurante.service.ClienteService;
import com.fatec.restaurante.service.PedidoService;
import com.fatec.restaurante.service.PratoService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/pedidos")
@RequiredArgsConstructor
public class PedidoController {

    private final PedidoService pedidoService;
    private final PratoService pratoService;
    private final ClienteService clienteService;
    private final DataSource dataSource; 
    
    @GetMapping
    public String listar(Model model) {
        model.addAttribute("pedidos", pedidoService.listarTodos());
        return "pedido/lista";
    }

    @GetMapping("/novo")
    public String formularioNovo(Model model) {
        model.addAttribute("pratos", pratoService.listarTodos());
        model.addAttribute("clientes", clienteService.listarTodos());
        return "pedido/novo";
    }

    @PostMapping("/novo")
    public String criarPedido(@RequestParam String cpfCliente,
                              @RequestParam Map<String, String> params,
                              RedirectAttributes redirectAttributes) {
        Map<String, Integer> itensPedido = new HashMap<>();
        params.forEach((chave, valor) -> {
            if (chave.startsWith("qty_") && !valor.isBlank() && Integer.parseInt(valor) > 0) {
                String idPrato = chave.substring(4); // remove "qty_"
                itensPedido.put(idPrato, Integer.parseInt(valor));
            }
        });

        if (itensPedido.isEmpty()) {
            redirectAttributes.addFlashAttribute("mensagem", "Selecione ao menos um prato para o pedido.");
            redirectAttributes.addFlashAttribute("tipoMensagem", "warning");
            return "redirect:/pedidos/novo";
        }

        try {
            Pedido pedido = pedidoService.criarPedido(cpfCliente, itensPedido);
            redirectAttributes.addFlashAttribute("mensagem", "Pedido criado com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
            return "redirect:/pedidos/" + pedido.getIdPedido();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro ao criar pedido: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
            return "redirect:/pedidos/novo";
        }
    }

    @GetMapping("/busca-cliente")
    public String buscaCliente(Model model) {
        model.addAttribute("clientes", clienteService.listarTodos());
        return "pedido/busca-cliente";
    }

    @GetMapping("/busca-data")
    public String formularioBuscaData(Model model) {
        model.addAttribute("dataAtual", LocalDate.now());
        return "pedido/busca-data";
    }

    @GetMapping("/por-data")
    public String listarPorData(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate data,
                                Model model) {
        List<Pedido> pedidos = pedidoService.buscarPorData(data);
        model.addAttribute("pedidos", pedidos);
        model.addAttribute("data", data);
        return "pedido/lista-data";
    }

    @GetMapping("/buscar-por-cpf")
    public String pedidoAtualCliente(@RequestParam("cpf") String cpf, Model model) {
        try {
            Pedido pedido = pedidoService.buscarPedidoAtualDoCliente(cpf);
            model.addAttribute("pedido", pedido);
            return "pedido/detalhe";
        } catch (Exception e) {
            model.addAttribute("erro", e.getMessage());
            model.addAttribute("clientes", clienteService.listarTodos());
            return "pedido/busca-cliente";
        }
    }

    @GetMapping("/relatorio")
    public void gerarRelatorioPedidoEspecifico(@RequestParam("id") String idPedido, HttpServletResponse response) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("id_pedido", idPedido);

            InputStream jasperStream = this.getClass().getResourceAsStream("/reports/ReciboPedido.jasper");
            Connection conn = dataSource.getConnection();

            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperStream, params, conn);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=recibo_" + idPedido + ".pdf");

            OutputStream out = response.getOutputStream();
            JasperExportManager.exportReportToPdfStream(jasperPrint, out);

            conn.close();
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @GetMapping("/relatorio-por-data")
    public void gerarRelatorioPorData(@RequestParam("data") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate data, 
                                      HttpServletResponse response) {
        try {
            Map<String, Object> params = new HashMap<>();
            String dataFormatada = data.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            params.put("data", dataFormatada);

            InputStream jasperStream = this.getClass().getResourceAsStream("/reports/ListaDePratosEClientesDeDiaEspecifico.jasper");
            Connection conn = dataSource.getConnection();

            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperStream, params, conn);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=relatorio_pedidos_" + data + ".pdf");

            OutputStream out = response.getOutputStream();
            JasperExportManager.exportReportToPdfStream(jasperPrint, out);

            conn.close();
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @GetMapping("/{id:[a-zA-Z0-9]{6}}")
    public String detalhe(@PathVariable("id") String idPedido, Model model) {
        Pedido pedido = pedidoService.buscarPorId(idPedido);
        model.addAttribute("pedido", pedido);
        return "pedido/detalhe";
    }

    @GetMapping("/{id}/editar")
    public String formularioEditar(@PathVariable("id") String idPedido, Model model) {
        model.addAttribute("pedido", pedidoService.buscarPorId(idPedido));
        return "pedido/formulario-editar";
    }

    @PostMapping("/{id}/editar")
    public String atualizar(@PathVariable("id") String idPedido,
                            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataRealizacao,
                            RedirectAttributes redirectAttributes) {
        try {
            Pedido pedido = pedidoService.buscarPorId(idPedido);
            pedido.setDataRealizacao(dataRealizacao);
            pedidoService.atualizar(idPedido, pedido);
            redirectAttributes.addFlashAttribute("mensagem", "Pedido updated com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/pedidos/" + idPedido;
    }

    @PostMapping("/{id}/excluir")
    public String excluir(@PathVariable("id") String idPedido, RedirectAttributes redirectAttributes) {
        try {
            pedidoService.excluir(idPedido);
            redirectAttributes.addFlashAttribute("mensagem", "Pedido excluído com sucesso!");
            redirectAttributes.addFlashAttribute("tipoMensagem", "success");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("mensagem", "Erro: " + e.getMessage());
            redirectAttributes.addFlashAttribute("tipoMensagem", "danger");
        }
        return "redirect:/pedidos";
    }
}