<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t"   tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedidos de ${data} - Restaurante Delivery</title>
    <link class="html-embed" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link class="html-embed" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link class="html-embed" rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="pedidos"/>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0">
            <i class="bi bi-calendar-check me-2 text-secondary"></i>
            Pedidos de <span class="text-danger">${data}</span>
        </h2>
        <div>
            <a href="${pageContext.request.contextPath}/pedidos/relatorio-por-data?data=${data}"
               target="_blank"
               class="btn btn-danger me-2">
                <i class="bi bi-file-earmark-pdf me-1"></i>Gerar PDF
            </a>
            <a href="${pageContext.request.contextPath}/pedidos/busca-data"
               class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Nova Busca
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty pedidos}">
            <div class="alert alert-info">
                <i class="bi bi-info-circle me-2"></i>
                Nenhum pedido encontrado para a data informada.
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="pedido" items="${pedidos}">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center
                                bg-light border-bottom">
                        <span>
                            <strong>Pedido:</strong> <code>${pedido.idPedido}</code>
                            &nbsp;&mdash;&nbsp;
                            <strong>Cliente:</strong> ${pedido.cliente.nome}
                            <small class="text-muted">(CPF: ${pedido.cliente.cpf})</small>
                        </span>
                        <span class="fw-bold text-success fs-6">
                            Total: R$
                            <fmt:formatNumber value="${pedido.valorTotal}"
                                             type="number"
                                             minFractionDigits="2"
                                             maxFractionDigits="2"/>
                        </span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-sm align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3">Prato</th>
                                        <th>Tipo</th>
                                        <th>Porção</th>
                                        <th>Ingredientes</th>
                                        <th class="text-center">Qtd.</th>
                                        <th class="text-end pe-3">Valor Unit.</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${pedido.pratoPedidos}">
                                        <tr>
                                            <td class="fw-semibold ps-3">${item.prato.nome}</td>
                                            <td>
                                                <span class="badge bg-secondary">
                                                    ${item.prato.tipo}
                                                </span>
                                            </td>
                                            <td>${item.prato.porcao}</td>
                                            <td>
                                                <small class="text-muted">
                                                    <c:forEach var="pi"
                                                               items="${item.prato.pratoIngredientes}"
                                                               varStatus="st">
                                                        ${pi.ingrediente.nome}<c:if test="${!st.last}">, </c:if>
                                                    </c:forEach>
                                                </small>
                                            </td>
                                            <td class="text-center">${item.quantidade}</td>
                                            <td class="text-end pe-3 text-success fw-bold">
                                                R$ <fmt:formatNumber value="${item.prato.valor}"
                                                                     type="number"
                                                                     minFractionDigits="2"
                                                                     maxFractionDigits="2"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<t:footer/>
</body>
</html>