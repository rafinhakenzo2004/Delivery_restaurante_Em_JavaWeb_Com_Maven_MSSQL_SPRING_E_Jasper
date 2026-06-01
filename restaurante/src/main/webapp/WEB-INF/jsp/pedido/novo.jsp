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
    <style>
        /* ── Autocomplete cliente ── */
        .autocomplete-wrapper { position: relative; }
        .autocomplete-list {
            position: absolute; top: 100%; left: 0; right: 0; z-index: 1000;
            background: #fff; border: 1px solid #ced4da; border-top: none;
            border-radius: 0 0 6px 6px; max-height: 220px; overflow-y: auto;
            box-shadow: 0 4px 12px rgba(0,0,0,.1);
        }
        .autocomplete-list .ac-item {
            padding: 8px 14px; cursor: pointer; font-size: .9rem;
        }
        .autocomplete-list .ac-item:hover,
        .autocomplete-list .ac-item.active { background: #f0f4ff; }
        .autocomplete-list .ac-empty {
            padding: 8px 14px; color: #6c757d; font-size: .85rem;
        }
    </style>
</head>
<body>

<t:navbar paginaAtiva="pedidos"/>

<div class="container mt-4">
    <t:alerta/>

    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/pedidos">Pedidos</a></li>
            <li class="breadcrumb-item active">Novo Pedido</li>
        </ol>
    </nav>

    <h2 class="fw-bold mb-4">
        <i class="bi bi-cart-plus me-2 text-warning"></i>Novo Pedido
    </h2>

    <form action="${pageContext.request.contextPath}/pedidos/novo" method="post" id="formPedido">

        <%-- ── Seleção do Cliente com busca por nome ── --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-primary text-white fw-bold">
                <i class="bi bi-person me-2"></i>Cliente
            </div>
            <div class="card-body">
                <%-- Campo oculto que guarda o CPF selecionado e é enviado no submit --%>
                <input type="hidden" name="cpfCliente" id="cpfCliente">

                <label for="buscaCliente" class="form-label fw-semibold">
                    Selecione o Cliente *
                </label>

                <div class="autocomplete-wrapper">
                    <input type="text" id="buscaCliente" class="form-control"
                           placeholder="Digite o nome ou CPF do cliente..."
                           autocomplete="off" required>
                    <div class="autocomplete-list" id="listaClientes" style="display:none"></div>
                </div>

                <div id="clienteSelecionado" class="mt-2" style="display:none">
                    <span class="badge bg-primary py-2 px-3" id="badgeCliente"></span>
                    <button type="button" class="btn btn-sm btn-link text-danger p-0 ms-2"
                            id="btnLimparCliente">
                        <i class="bi bi-x-circle"></i> Alterar
                    </button>
                </div>

                <div class="mt-2">
                    <small class="text-muted">
                        Cliente não cadastrado?
                        <a href="${pageContext.request.contextPath}/clientes/novo">Cadastrar agora</a>
                    </small>
                </div>

                <%-- Dados dos clientes em JSON para busca client-side --%>
                <script id="dadosClientes" type="application/json">
                [
                    <c:forEach var="c" items="${clientes}" varStatus="st">
                    {"cpf":"${c.cpf}","nome":"<c:out value='${c.nome}'/>","label":"<c:out value='${c.nome}'/> (${c.cpf})"}${!st.last ? ',' : ''}
                    </c:forEach>
                ]
                </script>
            </div>
        </div>

        <%-- ── Seleção de Pratos ── --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-danger text-white fw-bold">
                <i class="bi bi-journal-text me-2"></i>Selecione os Pratos
            </div>
            <div class="card-body">
                <%-- Filtro por tipo — client-side --%>
                <div class="row g-2 mb-3">
                    <div class="col-md-4">
                        <label for="filtraTipo" class="form-label fw-semibold small">
                            <i class="bi bi-funnel me-1"></i>Tipo do Prato
                        </label>
                        <select id="filtraTipo" class="form-select form-select-sm">
                            <option value="">Todos os tipos</option>
                            <c:forEach var="prato" items="${pratos}">
                                <option value="${prato.tipo.nomeTipo}">${prato.tipo.nomeTipo}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="button" id="btnLimparFiltro"
                                class="btn btn-outline-secondary btn-sm w-100">Limpar</button>
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
                                <th style="width:130px">Quantidade</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="prato" items="${pratos}">
                                <tr data-tipo="${prato.tipo.nomeTipo}">
                                    <td class="fw-semibold ps-3">${prato.nome}</td>
                                    <td>
                                        <span class="badge bg-secondary">
                                            <c:out value="${prato.tipo.nomeTipo}"/>
                                        </span>
                                    </td>
                                    <td>${prato.porcao}</td>
                                    <td class="text-success fw-bold" data-valor="${prato.valor}">
                                        R$ <fmt:formatNumber value="${prato.valor}" type="number"
                                                             minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                    <td>
                                        <%--
                                            CORREÇÃO problema 2:
                                            O input NUNCA é removido do DOM — apenas a linha fica
                                            oculta via CSS. Assim o valor digitado é preservado
                                            mesmo ao trocar de filtro.
                                        --%>
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
            <button type="submit" class="btn btn-warning btn-lg" id="btnFinalizar">
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
/* ================================================================
   1. AUTOCOMPLETE DE CLIENTE
   ================================================================ */
var clientes   = JSON.parse(document.getElementById('dadosClientes').textContent);
var inputBusca = document.getElementById('buscaCliente');
var lista      = document.getElementById('listaClientes');
var inputCpf   = document.getElementById('cpfCliente');
var divBadge   = document.getElementById('clienteSelecionado');
var badge      = document.getElementById('badgeCliente');

inputBusca.addEventListener('input', function () {
    var termo = this.value.trim().toLowerCase();
    lista.innerHTML = '';

    if (termo.length < 2) { lista.style.display = 'none'; return; }

    var filtrados = clientes.filter(function (c) {
        return c.nome.toLowerCase().includes(termo) || c.cpf.includes(termo);
    });

    if (filtrados.length === 0) {
        lista.innerHTML = '<div class="ac-empty">Nenhum cliente encontrado.</div>';
        lista.style.display = 'block';
        return;
    }

    filtrados.forEach(function (c) {
        var item = document.createElement('div');
        item.className = 'ac-item';
        item.textContent = c.label;
        item.addEventListener('click', function () {
            selecionarCliente(c);
        });
        lista.appendChild(item);
    });
    lista.style.display = 'block';
});

function selecionarCliente(c) {
    inputCpf.value   = c.cpf;
    inputBusca.value = c.label;
    inputBusca.style.display = 'none';
    lista.style.display      = 'none';
    badge.textContent        = c.label;
    divBadge.style.display   = 'block';
}

document.getElementById('btnLimparCliente').addEventListener('click', function () {
    inputCpf.value           = '';
    inputBusca.value         = '';
    inputBusca.style.display = '';
    divBadge.style.display   = 'none';
    inputBusca.focus();
});

/* Fecha lista ao clicar fora */
document.addEventListener('click', function (e) {
    if (!inputBusca.contains(e.target) && !lista.contains(e.target)) {
        lista.style.display = 'none';
    }
});

/* Validação: garante que um cliente foi selecionado antes de submeter */
document.getElementById('formPedido').addEventListener('submit', function (e) {
    if (!inputCpf.value) {
        e.preventDefault();
        inputBusca.classList.add('is-invalid');
        inputBusca.style.display = '';
        inputBusca.focus();
        alert('Selecione um cliente da lista antes de finalizar o pedido.');
    }
});

/* ================================================================
   2. FILTRO POR TIPO — não apaga quantidade ao trocar de categoria
   ================================================================ */
var selectFiltro = document.getElementById('filtraTipo');

/* Remove duplicatas do select de filtro */
(function () {
    var vistas = {};
    selectFiltro.querySelectorAll('option').forEach(function (opt) {
        if (!opt.value) return;
        if (vistas[opt.value]) opt.remove();
        else vistas[opt.value] = true;
    });
})();

selectFiltro.addEventListener('change', filtrar);
document.getElementById('btnLimparFiltro').addEventListener('click', function () {
    selectFiltro.value = ''; filtrar();
});

function filtrar() {
    var tipo = selectFiltro.value.toLowerCase();
    document.querySelectorAll('#tabelaPratos tbody tr').forEach(function (tr) {
        if (!tipo || tr.dataset.tipo.toLowerCase() === tipo) {
            tr.style.display = '';
        } else {
            /*
             * CORREÇÃO problema 2:
             * Apenas OCULTA a linha — NÃO zera a quantidade.
             * O input continua no DOM com o valor digitado e é
             * enviado normalmente no submit, mas não aparece no total
             * enquanto o filtro está ativo (UX apenas visual).
             * Para o cálculo do total, contamos TODOS os inputs,
             * sejam visíveis ou não — o usuário vê o total real.
             */
            tr.style.display = 'none';
        }
    });
    calcularTotal();
}

/* ================================================================
   3. CÁLCULO DE SUBTOTAIS E TOTAL (conta todos os inputs, visíveis ou não)
   ================================================================ */
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
