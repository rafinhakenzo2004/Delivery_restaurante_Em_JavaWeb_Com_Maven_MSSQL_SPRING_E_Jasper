<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t"   tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedidos - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="pedidos"/>

<div class="container mt-4">
    <t:alerta/>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold"><i class="bi bi-cart me-2 text-warning"></i>Pedidos</h2>
        <div>
            <a href="${pageContext.request.contextPath}/pedidos/busca-cliente"
               class="btn btn-outline-secondary me-2">
                <i class="bi bi-person-search me-1"></i>Por Cliente
            </a>
            <a href="${pageContext.request.contextPath}/pedidos/busca-data"
               class="btn btn-outline-secondary me-2">
                <i class="bi bi-calendar me-1"></i>Por Data
            </a>
            <a href="${pageContext.request.contextPath}/pedidos/novo" class="btn btn-warning">
                <i class="bi bi-plus-circle me-1"></i>Novo Pedido
            </a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-warning">
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Data</th>
                    <th>Valor Total</th>
                    <th class="text-center">Ações</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty pedidos}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">
                                Nenhum pedido cadastrado.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="pedido" items="${pedidos}">
                            <tr>
                                <td><code>${pedido.idPedido}</code></td>
                                <td class="fw-semibold">${pedido.cliente.nome}</td>
                                <td>
                                    ${pedido.dataRealizacao}
                                </td>
                                <td class="fw-bold text-success">
                                    R$ <fmt:formatNumber value="${pedido.valorTotal}"
                                                         type="number"
                                                         minFractionDigits="2"
                                                         maxFractionDigits="2"/>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/pedidos/${pedido.idPedido}"
                                       class="btn btn-sm btn-outline-info me-1" title="Detalhes">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/pedidos/${pedido.idPedido}/excluir"
                                          method="post" class="d-inline"
                                          onsubmit="return confirm('Confirma a exclusão do pedido?')">
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
