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
                <span class="badge bg-secondary">${prato.tipo}</span>
                &nbsp;${prato.porcao} &mdash;
                R$ <fmt:formatNumber value="${prato.valor}"
                                     type="number"
                                     minFractionDigits="2"
                                     maxFractionDigits="2"/>
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
                                                    <%-- Formulário inline para atualizar quantidade --%>
                                                    <form action="${pageContext.request.contextPath}/pratos/${prato.idPrato}/ingredientes/${pi.ingrediente.idIngrediente}/atualizar"
                                                          method="post" class="d-flex gap-1 align-items-center">
                                                        <input type="number" name="quantidade"
                                                               value="${pi.quantidade}"
                                                               class="form-control form-control-sm"
                                                               style="width: 70px;" min="1">
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

        <%-- Formulário para adicionar ingrediente --%>
        <div class="col-md-5">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-danger text-white fw-bold">
                    <i class="bi bi-plus-circle me-2"></i>Adicionar Ingrediente
                </div>
                <div class="card-body p-3">
                    <form action="${pageContext.request.contextPath}/pratos/${prato.idPrato}/ingredientes/adicionar"
                          method="post">
                        <div class="mb-3">
                            <label for="idIngrediente" class="form-label fw-semibold small">
                                Ingrediente *
                            </label>
                            <select name="idIngrediente" id="idIngrediente"
                                    class="form-select form-select-sm" required>
                                <option value="">Selecione...</option>
                                <c:forEach var="ing" items="${ingredientesDisponiveis}">
                                    <option value="${ing.idIngrediente}">
                                        ${ing.nome}
                                    </option>
                                </c:forEach>
                            </select>
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
                </div>
            </div>
        </div>
    </div>
</div>

<t:footer/>
</body>
</html>
