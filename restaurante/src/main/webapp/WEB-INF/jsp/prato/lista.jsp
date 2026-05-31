<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t"   tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pratos - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="pratos"/>

<div class="container mt-4">
    <t:alerta/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold"><i class="bi bi-journal-text me-2 text-danger"></i>Pratos</h2>
        <div>
            <a href="${pageContext.request.contextPath}/pratos/com-ingredientes"
               class="btn btn-outline-secondary me-2">
                <i class="bi bi-list-ul me-1"></i>Ver com Ingredientes
            </a>
            <a href="${pageContext.request.contextPath}/pratos/novo" class="btn btn-danger">
                <i class="bi bi-plus-circle me-1"></i>Novo Prato
            </a>
        </div>
    </div>

    <%-- Filtro por tipo com a Validação do PDF --%>
    <form action="${pageContext.request.contextPath}/pratos" method="get" class="row g-2 mb-4 align-items-end">
        <div class="col-md-4">
            <label for="tipo" class="form-label fw-semibold text-dark" style="font-size: 0.9rem;">Tipo do Prato</label>
            <select name="tipo" id="tipo" class="form-select">
                <option value="">Todos os tipos</option>
                <c:forEach var="t" items="${tipos}">
                    <%-- Como 'tipos' vem como List<String> do findDistinctTipos(), a comparação direta funciona --%>
                    <option value="${t}" ${t == tipoSelecionado ? 'selected' : ''}>${t}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-auto d-flex align-items-center gap-1">
            <button type="submit" class="btn btn-outline-danger">
                <i class="bi bi-funnel me-1"></i>Filtrar
            </button>
            <a href="${pageContext.request.contextPath}/pratos" class="btn btn-outline-secondary ms-1">Limpar</a>
            
            <div class="position-relative ms-2">
                <c:if test="${empty tipoSelecionado}">
                    <span class="text-danger fw-semibold position-absolute" 
                          style="bottom: 100%; left: 0; white-space: nowrap; font-size: 0.8rem; margin-bottom: 6px;">
                        Selecione o tipo do prato na consulta
                    </span>
                </c:if>
                
                <button type="submit" 
                        formaction="${pageContext.request.contextPath}/pratos/relatorio-tipo" 
                        formtarget="_blank" 
                        class="btn btn-danger"
                        ${empty tipoSelecionado ? 'disabled' : ''}>
                    <i class="bi bi-file-earmark-pdf me-1"></i>Gerar PDF por Tipo
                </button>
            </div>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-danger">
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Tipo</th>
                    <th>Porção</th>
                    <th>Valor</th>
                    <th class="text-center">Ações</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty pratos}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">
                                Nenhum prato cadastrado.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="prato" items="${pratos}">
                            <tr>
                                <td><code>${prato.idPrato}</code></td>
                                <td class="fw-semibold">${prato.nome}</td>
                                <td>
                                    <%-- CORREÇÃO: Acessando o texto do tipo através do relacionamento mapeado --%>
                                    <span class="badge bg-secondary">
                                        <c:out value="${prato.tipo.nomeTipo}"/>
                                    </span>
                                </td>
                                <td>${prato.porcao}</td>
                                <td class="text-success fw-bold">
                                    R$ <fmt:formatNumber value="${prato.valor}" type="number"
                                                         minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/pratos/${prato.idPrato}/ingredientes"
                                       class="btn btn-sm btn-outline-success me-1" title="Ingredientes">
                                        <i class="bi bi-basket"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/pratos/${prato.idPrato}/editar"
                                       class="btn btn-sm btn-outline-primary me-1" title="Editar">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/pratos/${prato.idPrato}/excluir"
                                          method="post" class="d-inline"
                                          onsubmit="return confirm('Confirma a exclusão do prato?')">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Excluir">
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

<t:footer/>
</body>
</html>