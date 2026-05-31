<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ingredientes - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="ingredientes"/>

<div class="container mt-4">
    <t:alerta/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold"><i class="bi bi-basket me-2 text-success"></i>Ingredientes</h2>
        <a href="${pageContext.request.contextPath}/ingredientes/novo" class="btn btn-success">
            <i class="bi bi-plus-circle me-1"></i>Novo Ingrediente
        </a>
    </div>

    <form action="${pageContext.request.contextPath}/ingredientes" method="get" class="row g-2 mb-4">
        <div class="col-md-4">
            <input type="text" name="nome" class="form-control"
                   placeholder="Buscar por nome..." value="${busca}">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-outline-success">
                <i class="bi bi-search me-1"></i>Buscar
            </button>
            <a href="${pageContext.request.contextPath}/ingredientes"
               class="btn btn-outline-secondary ms-1">Limpar</a>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-success">
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Apresentação</th>
                    <th class="text-center">Ações</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty ingredientes}">
                        <tr>
                            <td colspan="4" class="text-center text-muted py-4">
                                Nenhum ingrediente cadastrado.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="ing" items="${ingredientes}">
                            <tr>
                                <td><code>${ing.idIngrediente}</code></td>
                                <td class="fw-semibold">${ing.nome}</td>
                                <td class="text-muted">${ing.apresentacao}</td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/ingredientes/${ing.idIngrediente}/editar"
                                       class="btn btn-sm btn-outline-primary me-1" title="Editar">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/ingredientes/${ing.idIngrediente}/excluir"
                                          method="post" class="d-inline"
                                          onsubmit="return confirm('Confirma a exclusão do ingrediente?')">
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
