<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"       uri="jakarta.tags.core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"    uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="t"       tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${modo == 'novo' ? 'Novo Prato' : 'Editar Prato'} - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="pratos"/>

<div class="container mt-4" style="max-width: 620px;">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/pratos">Pratos</a>
            </li>
            <li class="breadcrumb-item active">
                ${modo == 'novo' ? 'Novo' : 'Editar'}
            </li>
        </ol>
    </nav>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-danger text-white">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-pencil me-2"></i>
                ${modo == 'novo' ? 'Cadastrar Prato' : 'Editar Prato'}
            </h5>
        </div>
        <div class="card-body p-4">
            <c:set var="action"
                   value="${modo == 'novo'
                       ? pageContext.request.contextPath.concat('/pratos/novo')
                       : pageContext.request.contextPath.concat('/pratos/').concat(prato.idPrato).concat('/editar')}"/>

            <form:form action="${action}" method="post" modelAttribute="prato">

                <c:if test="${modo == 'editar'}">
                    <form:hidden path="idPrato"/>
                </c:if>

                <div class="mb-3">
                    <label for="nome" class="form-label fw-semibold">Nome do Prato *</label>
                    <form:input path="nome" cssClass="form-control" id="nome"
                                placeholder="Ex: Frango Grelhado"/>
                    <form:errors path="nome" cssClass="text-danger small"/>
                </div>

                <div class="mb-3">
                    <label for="tipo" class="form-label fw-semibold">Tipo *</label>
                    <div class="input-group">
                        <form:select path="tipo.idTipo" cssClass="form-select" id="tipo">
                            <form:option value="">Selecione um tipo...</form:option>
                            <c:forEach items="${tipos}" var="tp">
                                <form:option value="${tp.idTipo}">${tp.nomeTipo}</form:option>
                            </c:forEach>
                        </form:select>
                        <%-- type="button" garante que este botão NÃO submete o form --%>
                        <button type="button" class="btn btn-outline-secondary"
                                data-bs-toggle="modal" data-bs-target="#modalNovoTipo">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                    </div>
                    <form:errors path="tipo.idTipo" cssClass="text-danger small"/>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="porcao" class="form-label fw-semibold">Porção *</label>
                        <form:select path="porcao" cssClass="form-select" id="porcao">
                            <form:option value="">Selecione...</form:option>
                            <form:option value="PEQUENO">Pequeno</form:option>
                            <form:option value="MEDIO">Médio</form:option>
                            <form:option value="GRANDE">Grande</form:option>
                        </form:select>
                        <form:errors path="porcao" cssClass="text-danger small"/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="valor" class="form-label fw-semibold">Valor (R$) *</label>
                        <form:input path="valor" cssClass="form-control" id="valor"
                                    type="number" step="0.01" placeholder="0.00"/>
                        <form:errors path="valor" cssClass="text-danger small"/>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-2">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-check-circle me-1"></i>Salvar
                    </button>
                    <a href="${pageContext.request.contextPath}/pratos" class="btn btn-outline-secondary">
                        <i class="bi bi-x-circle me-1"></i>Cancelar
                    </a>
                </div>

            </form:form>
        </div>
    </div>
</div>

<%--
    Modal FORA do form:form — evita o problema de <form> aninhado no HTML.
    Usa fetch para enviar ao backend e retornar JSON, sem disparar
    a validação do formulário principal.
--%>
<div class="modal fade" id="modalNovoTipo" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Novo Tipo de Prato</h5>
                <button type="button" class="btn-close"
                        data-bs-dismiss="modal" aria-label="Fechar"></button>
            </div>
            <div class="modal-body">
                <label class="form-label fw-semibold">Nome do Tipo *</label>
                <input type="text" id="novoNomeTipo" class="form-control"
                       placeholder="Ex: Sobremesas">
                <div id="erroTipo" class="text-danger small mt-1" style="display:none"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary"
                        data-bs-dismiss="modal">Fechar</button>
                <button type="button" class="btn btn-danger" id="btnSalvarTipo">
                    Cadastrar
                </button>
            </div>
        </div>
    </div>
</div>

<t:footer/>

<script>
document.getElementById('btnSalvarTipo').addEventListener('click', function () {
    var nomeTipo = document.getElementById('novoNomeTipo').value.trim();
    var erroDiv  = document.getElementById('erroTipo');

    if (!nomeTipo) {
        erroDiv.textContent  = 'Nome do tipo é obrigatório.';
        erroDiv.style.display = 'block';
        return;
    }
    erroDiv.style.display = 'none';

    fetch('${pageContext.request.contextPath}/pratos/tipos/novo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'nomeTipo=' + encodeURIComponent(nomeTipo)
    })
    .then(function (res) {
        if (!res.ok) throw new Error('Erro ' + res.status);
        return res.json();
    })
    .then(function (tipo) {
        var select = document.getElementById('tipo');
        var option = new Option(tipo.nomeTipo, tipo.idTipo, true, true);
        select.appendChild(option);

        document.getElementById('novoNomeTipo').value = '';
        bootstrap.Modal.getInstance(
            document.getElementById('modalNovoTipo')
        ).hide();
    })
    .catch(function () {
        erroDiv.textContent  = 'Erro ao cadastrar tipo. Verifique se ele já existe.';
        erroDiv.style.display = 'block';
    });
});
</script>
</body>
</html>
