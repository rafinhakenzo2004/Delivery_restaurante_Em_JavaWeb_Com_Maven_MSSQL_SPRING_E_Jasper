<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t"   tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Novo Pedido - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="pedidos"/>

<div class="container mt-4">
    <t:alerta/>

    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/pedidos">Pedidos</a>
            </li>
            <li class="breadcrumb-item active">Novo Pedido</li>
        </ol>
    </nav>

    <h2 class="fw-bold mb-4">
        <i class="bi bi-cart-plus me-2 text-warning"></i>Novo Pedido
    </h2>

    <form action="${pageContext.request.contextPath}/pedidos/novo" method="post" id="formPedido">

        <%-- Seleção do Cliente --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-primary text-white fw-bold">
                <i class="bi bi-person me-2"></i>Cliente
            </div>
            <div class="card-body">
                <label for="cpfCliente" class="form-label fw-semibold">
                    Selecione o Cliente *
                </label>
                <select name="cpfCliente" id="cpfCliente" class="form-select" required>
                    <option value="">-- Selecione um cliente cadastrado --</option>
                    <c:forEach var="c" items="${clientes}">
                        <option value="${c.cpf}">
                            ${c.nome} (CPF: ${c.cpf})
                        </option>
                    </c:forEach>
                </select>
                <div class="mt-2">
                    <small class="text-muted">
                        Cliente não cadastrado?
                        <a href="${pageContext.request.contextPath}/clientes/novo">Cadastrar agora</a>
                    </small>
                </div>
            </div>
        </div>

        <%-- Seleção de Pratos --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-danger text-white fw-bold">
                <i class="bi bi-journal-text me-2"></i>Selecione os Pratos
            </div>
            <div class="card-body">

                <%-- Filtro por tipo — client-side, não recarrega a página --%>
                <div class="row g-2 mb-3">
                    <div class="col-md-4">
                        <label for="filtraTipo" class="form-label fw-semibold small">
                            <i class="bi bi-funnel me-1"></i>Tipo do Prato
                        </label>
                        <select id="filtraTipo" class="form-select form-select-sm">
                            <option value="">Todos os tipos</option>
                            <%-- Monta opções únicas a partir dos pratos já no model --%>
                            <c:forEach var="prato" items="${pratos}">
                                <option value="${prato.tipo.nomeTipo}">
                                    ${prato.tipo.nomeTipo}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="button" id="btnLimparFiltro"
                                class="btn btn-outline-secondary btn-sm w-100">
                            Limpar
                        </button>
                    </div>
                </div>

            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table align-middle mb-0" id="tabelaPratos">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">Nome</th>
                                <th>Tipo</th>
                                <th>Porção</th>
                                <th>Valor Unit.</th>
                                <th style="width: 130px;">Quantidade</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="prato" items="${pratos}">
                                <%-- data-tipo usado pelo filtro JS --%>
                                <tr data-tipo="${prato.tipo.nomeTipo}">
                                    <td class="fw-semibold ps-3">${prato.nome}</td>
                                    <td>
                                        <span class="badge bg-secondary">
                                            <c:out value="${prato.tipo.nomeTipo}"/>
                                        </span>
                                    </td>
                                    <td>${prato.porcao}</td>
                                    <td class="text-success fw-bold"
                                        data-valor="${prato.valor}">
                                        R$ <fmt:formatNumber value="${prato.valor}"
                                                             type="number"
                                                             minFractionDigits="2"
                                                             maxFractionDigits="2"/>
                                    </td>
                                    <td>
                                        <input type="number"
                                               name="qty_${prato.idPrato}"
                                               class="form-control form-control-sm qty-input"
                                               min="0" value="0"
                                               data-valor="${prato.valor}">
                                    </td>
                                    <td class="subtotal fw-bold text-success">R$ 0,00</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr class="table-warning">
                                <td colspan="5" class="text-end fw-bold pe-3">TOTAL DO PEDIDO:</td>
                                <td id="valorTotal" class="fw-bold fs-5 text-success">R$ 0,00</td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="d-flex gap-2 mb-5">
            <button type="submit" class="btn btn-warning btn-lg">
                <i class="bi bi-check-circle me-2"></i>Finalizar Pedido
            </button>
            <a href="${pageContext.request.contextPath}/pedidos"
               class="btn btn-outline-secondary btn-lg">
                <i class="bi bi-x-circle me-1"></i>Cancelar
            </a>
        </div>
    </form>
</div>

<t:footer/>

<script>
    var selectFiltro = document.getElementById('filtraTipo');

    (function deduplicar() {
        var vistas = {};
        var opts   = selectFiltro.querySelectorAll('option');
        opts.forEach(function (opt) {
            if (opt.value === '') return;
            if (vistas[opt.value]) {
                opt.remove();
            } else {
                vistas[opt.value] = true;
            }
        });
    })();

    selectFiltro.addEventListener('change', filtrar);

    document.getElementById('btnLimparFiltro').addEventListener('click', function () {
        selectFiltro.value = '';
        filtrar();
    });

    function filtrar() {
        var tipoSelecionado = selectFiltro.value.toLowerCase();
        document.querySelectorAll('#tabelaPratos tbody tr').forEach(function (tr) {
            if (!tipoSelecionado || tr.dataset.tipo.toLowerCase() === tipoSelecionado) {
                tr.style.display = '';
            } else {
                tr.style.display = 'none';
                var input = tr.querySelector('.qty-input');
                if (input) { input.value = 0; }
            }
        });
        calcularTotal();
    }

    document.querySelectorAll('.qty-input').forEach(function (input) {
        input.addEventListener('input', calcularTotal);
    });

    function calcularTotal() {
        var total = 0;
        document.querySelectorAll('.qty-input').forEach(function (input) {
            var valor = parseFloat(input.dataset.valor) || 0;
            var qty   = parseInt(input.value)           || 0;
            var sub   = valor * qty;
            total    += sub;
            var row   = input.closest('tr');
            row.querySelector('.subtotal').textContent =
                'R$ ' + sub.toFixed(2).replace('.', ',');
        });
        document.getElementById('valorTotal').textContent =
            'R$ ' + total.toFixed(2).replace('.', ',');
    }
</script>
</body>
</html>
