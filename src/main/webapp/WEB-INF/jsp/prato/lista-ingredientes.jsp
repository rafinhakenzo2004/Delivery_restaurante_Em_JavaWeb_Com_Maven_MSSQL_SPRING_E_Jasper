<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t"   tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cardápio com Ingredientes - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="ingredientes"/>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="fw-bold"><i class="bi bi-list-ul me-2 text-danger"></i>Cardápio com Ingredientes</h2>
        
        <div class="d-flex align-items-end gap-3">
            <form action="${pageContext.request.contextPath}/pratos/com-ingredientes" method="GET" class="d-flex align-items-end gap-2">
                <div style="min-width: 180px;">
                    <label for="tipo" class="form-label small fw-bold mb-1 text-dark">Tipo do Prato</label>
                    <select name="tipo" id="tipo" class="form-select">
                        <option value="">Todos os tipos</option>
                        <c:forEach var="t" items="${tipos}">
                            <option value="${t}" ${t == tipoSelecionado ? 'selected' : ''}>${t}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn btn-outline-danger">
                    <i class="bi bi-funnel me-1"></i>Filtrar
                </button>
            </form>

            <a href="${pageContext.request.contextPath}/pratos" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Voltar
            </a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-danger">
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Tipo</th>
                    <th>Porção</th>
                    <th>Valor</th>
                    <th>Ingredientes</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty pratos}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">
                                Nenhum prato encontrado para este tipo.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="row" items="${pratos}">
                            <tr>
                                <td><code>${row[0]}</code></td>
                                <td class="fw-semibold">${row[1]}</td>
                                <td><span class="badge bg-secondary">${row[4]}</span></td>
                                <td>${row[2]}</td>
                                <td class="text-success fw-bold">
                                    R$ <fmt:formatNumber value="${row[3]}" type="number"
                                                         minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td>
                                    <small class="text-muted">${row[5]}</small>
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

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>