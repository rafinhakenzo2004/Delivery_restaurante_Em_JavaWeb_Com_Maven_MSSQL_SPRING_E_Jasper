<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t"   tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ingredientes de ${prato.nome} - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <style>
        /* ── Autocomplete ingrediente ── */
        .autocomplete-wrapper { position: relative; }
        .autocomplete-list {
            position: absolute; top: 100%; left: 0; right: 0; z-index: 1000;
            background: #fff; border: 1px solid #ced4da; border-top: none;
            border-radius: 0 0 6px 6px; max-height: 200px; overflow-y: auto;
            box-shadow: 0 4px 12px rgba(0,0,0,.1);
        }
        .autocomplete-list .ac-item {
            padding: 7px 12px; cursor: pointer; font-size: .88rem;
        }
        .autocomplete-list .ac-item:hover,
        .autocomplete-list .ac-item.active { background: #f0f4ff; }
        .autocomplete-list .ac-empty {
            padding: 8px 12px; color: #6c757d; font-size: .85rem;
        }
    </style>
</head>
<body>

<t:navbar paginaAtiva="pratos"/>

<div class="container mt-4">
    <t:alerta/>

    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/pratos">Pratos</a>
            </li>
            <li class="breadcrumb-item active">Ingredientes de ${prato.nome}</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-0">
                <i class="bi bi-basket me-2 text-success"></i>${prato.nome}
            </h2>
            <small class="text-muted">
                <span class="badge bg-secondary">${prato.tipo.nomeTipo}</span>
                &nbsp;${prato.porcao} &mdash;
                R$ <fmt:formatNumber value="${prato.valor}" type="number"
                                     minFractionDigits="2" maxFractionDigits="2"/>
            </small>
        </div>
        <a href="${pageContext.request.contextPath}/pratos" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Voltar
        </a>
    </div>

    <div class="row g-4">

        <%-- Lista de ingredientes associados --%>
        <div class="col-md-7">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-success text-white fw-bold">
                    <i class="bi bi-list-check me-2"></i>Ingredientes do Prato
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">Ingrediente</th>
                                    <th>Qtd.</th>
                                    <th class="text-center">Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty pratoIngredientes}">
                                        <tr>
                                            <td colspan="3" class="text-center text-muted py-4">
                                                Nenhum ingrediente associado.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="pi" items="${pratoIngredientes}">
                                            <tr>
                                                <td class="fw-semibold ps-3">
                                                    ${pi.ingrediente.nome}
                                                    <br>
                                                    <small class="text-muted">
                                                        ${pi.ingrediente.apresentacao}
                                                    </small>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/pratos/${prato.idPrato}/ingredientes/${pi.ingrediente.idIngrediente}/atualizar"
                                                          method="post"
                                                          class="d-flex gap-1 align-items-center">
                                                        <input type="number" name="quantidade"
                                                               value="${pi.quantidade}"
                                                               class="form-control form-control-sm"
                                                               style="width:70px" min="1">
                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-success"
                                                                title="Salvar quantidade">
                                                            <i class="bi bi-check"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                                <td class="text-center">
                                                    <form action="${pageContext.request.contextPath}/pratos/${prato.idPrato}/ingredientes/${pi.ingrediente.idIngrediente}/remover"
                                                          method="post" class="d-inline"
                                                          onsubmit="return confirm('Remover ingrediente do prato?')">
                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-danger"
                                                                title="Remover">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%-- Formulário para adicionar ingrediente com busca --%>
        <div class="col-md-5">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-danger text-white fw-bold">
                    <i class="bi bi-plus-circle me-2"></i>Adicionar Ingrediente
                </div>
                <div class="card-body p-3">
                    <form action="${pageContext.request.contextPath}/pratos/${prato.idPrato}/ingredientes/adicionar"
                          method="post" id="formAdicionar">

                        <input type="hidden" name="idIngrediente" id="idIngredienteHidden">

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Ingrediente *</label>

                            <div class="autocomplete-wrapper">
                                <input type="text" id="buscaIngrediente" class="form-control form-control-sm"
                                       placeholder="Digite para buscar..." autocomplete="off">
                                <div class="autocomplete-list" id="listaIngredientes" style="display:none"></div>
                            </div>

                            <div id="ingredienteSelecionado" style="display:none" class="mt-1">
                                <span class="badge bg-success py-1 px-2" id="badgeIngrediente"></span>
                                <button type="button" class="btn btn-sm btn-link text-danger p-0 ms-1"
                                        id="btnLimparIng">
                                    <i class="bi bi-x-circle"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="quantidade" class="form-label fw-semibold small">
                                Quantidade *
                            </label>
                            <input type="number" name="quantidade" id="quantidade"
                                   class="form-control form-control-sm"
                                   min="1" value="1" required>
                        </div>

                        <button type="submit" class="btn btn-danger btn-sm w-100">
                            <i class="bi bi-plus me-1"></i>Adicionar
                        </button>
                    </form>

                    <%-- Dados dos ingredientes disponíveis em JSON --%>
                    <script id="dadosIngredientes" type="application/json">
                    [
                        <c:forEach var="ing" items="${ingredientesDisponiveis}" varStatus="st">
                        {"id":"${ing.idIngrediente}","nome":"<c:out value='${ing.nome}'/>"}${!st.last ? ',' : ''}
                        </c:forEach>
                    ]
                    </script>
                </div>
            </div>
        </div>
    </div>
</div>

<t:footer/>

<script>
/* ================================================================
   AUTOCOMPLETE DE INGREDIENTE
   ================================================================ */
var ingredientes   = JSON.parse(document.getElementById('dadosIngredientes').textContent);
var inputBusca     = document.getElementById('buscaIngrediente');
var lista          = document.getElementById('listaIngredientes');
var inputHidden    = document.getElementById('idIngredienteHidden');
var divSelecionado = document.getElementById('ingredienteSelecionado');
var badge          = document.getElementById('badgeIngrediente');

inputBusca.addEventListener('input', function () {
    var termo = this.value.trim().toLowerCase();
    lista.innerHTML = '';

    if (termo.length === 0) { lista.style.display = 'none'; return; }

    var filtrados = ingredientes.filter(function (i) {
        return i.nome.toLowerCase().includes(termo);
    });

    if (filtrados.length === 0) {
        lista.innerHTML = '<div class="ac-empty">Nenhum ingrediente encontrado.</div>';
        lista.style.display = 'block';
        return;
    }

    filtrados.forEach(function (ing) {
        var item = document.createElement('div');
        item.className = 'ac-item';
        item.textContent = ing.nome;
        item.addEventListener('click', function () {
            selecionarIngrediente(ing);
        });
        lista.appendChild(item);
    });
    lista.style.display = 'block';
});

function selecionarIngrediente(ing) {
    inputHidden.value        = ing.id;
    inputBusca.value         = ing.nome;
    inputBusca.style.display = 'none';
    lista.style.display      = 'none';
    badge.textContent        = ing.nome;
    divSelecionado.style.display = 'block';
}

document.getElementById('btnLimparIng').addEventListener('click', function () {
    inputHidden.value            = '';
    inputBusca.value             = '';
    inputBusca.style.display     = '';
    divSelecionado.style.display = 'none';
    inputBusca.focus();
});

/* Fecha ao clicar fora */
document.addEventListener('click', function (e) {
    if (!inputBusca.contains(e.target) && !lista.contains(e.target)) {
        lista.style.display = 'none';
    }
});

/* Validação antes de submeter */
document.getElementById('formAdicionar').addEventListener('submit', function (e) {
    if (!inputHidden.value) {
        e.preventDefault();
        inputBusca.classList.add('is-invalid');
        inputBusca.style.display = '';
        inputBusca.focus();
        alert('Selecione um ingrediente da lista antes de adicionar.');
    }
});
</script>
</body>
</html>
