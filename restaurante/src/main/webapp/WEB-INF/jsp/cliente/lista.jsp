<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clientes - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="clientes"/>

<div class="container mt-4">
    <t:alerta/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold"><i class="bi bi-people me-2 text-primary"></i>Clientes</h2>
        <a href="${pageContext.request.contextPath}/clientes/novo" class="btn btn-primary">
            <i class="bi bi-person-plus me-1"></i>Novo Cliente
        </a>
    </div>

    <form action="${pageContext.request.contextPath}/clientes" method="get" class="row g-2 mb-4">
        <div class="col-md-4">
            <input type="text" name="nome" class="form-control"
                   placeholder="Buscar por nome..." value="${busca}">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-outline-primary">
                <i class="bi bi-search me-1"></i>Buscar
            </button>
            <a href="${pageContext.request.contextPath}/clientes"
               class="btn btn-outline-secondary ms-1">Limpar</a>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-primary">
                <tr>
                    <th>CPF</th>
                    <th>Nome</th>
                    <th>Telefone</th>
                    <th>Endereço</th>
                    <th class="text-center">Ações</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty clientes}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">
                                Nenhum cliente cadastrado.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="cliente" items="${clientes}">
                            <tr>
                                <td><code>${cliente.cpf}</code></td>
                                <td class="fw-semibold">${cliente.nome}</td>
                                <td>${cliente.telefone}</td>
                                <td>
                                    <small class="text-muted">
                                        ${cliente.logradouro}, ${cliente.numero}
                                        &mdash; CEP ${cliente.cep}
                                    </small>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/pedidos/novo"
                                       class="btn btn-sm btn-outline-warning me-1" title="Novo Pedido">
                                        <i class="bi bi-cart-plus"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/clientes/${cliente.cpf}/editar"
                                       class="btn btn-sm btn-outline-primary me-1" title="Editar">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/clientes/${cliente.cpf}/excluir"
                                          method="post" class="d-inline"
                                          onsubmit="return confirm('Confirma a exclusão do cliente?')">
                                        <button type="submit" class="btn btn-sm btn-outline-danger"
                                                title="Excluir">
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
