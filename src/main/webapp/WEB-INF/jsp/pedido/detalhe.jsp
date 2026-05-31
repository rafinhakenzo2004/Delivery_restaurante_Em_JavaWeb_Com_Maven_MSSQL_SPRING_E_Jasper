<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t"   tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedido ${pedido.idPedido} - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="pedidos"/>

<div class="container mt-4" style="max-width: 760px;">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/pedidos">Pedidos</a>
            </li>
            <li class="breadcrumb-item active">Pedido ${pedido.idPedido}</li>
        </ol>
    </nav>

    <%-- Cabeçalho do recibo com valor total em destaque --%>
    <div class="recibo-header text-center mb-0">
        <h3 class="fw-bold mb-1">
            <i class="bi bi-receipt me-2"></i>Recibo do Pedido
        </h3>
        <p class="mb-0 opacity-75">Código: <strong>${pedido.idPedido}</strong></p>
        <div class="mt-3 py-3 px-4 d-inline-block bg-white bg-opacity-25 rounded-3">
            <p class="mb-0 small opacity-90">VALOR TOTAL</p>
            <h2 class="fw-bold mb-0">
                R$ <fmt:formatNumber value="${pedido.valorTotal}"
                                     type="number"
                                     minFractionDigits="2"
                                     maxFractionDigits="2"/>
            </h2>
        </div>
    </div>

    <%-- Corpo do recibo --%>
    <div class="recibo-body mb-4">

        <%-- Dados do cliente --%>
        <div class="row mb-4">
            <div class="col-md-6">
                <p class="text-muted small fw-bold mb-1">CLIENTE</p>
                <p class="fw-semibold mb-0">${pedido.cliente.nome}</p>
                <p class="text-muted small mb-0">CPF: ${pedido.cliente.cpf}</p>
                <p class="text-muted small mb-0">Tel: ${pedido.cliente.telefone}</p>
            </div>
            <div class="col-md-6">
                <p class="text-muted small fw-bold mb-1">ENTREGA</p>
                <p class="mb-0 small">
                    ${pedido.cliente.logradouro}, ${pedido.cliente.numero}
                </p>
                <p class="mb-0 small">CEP: ${pedido.cliente.cep}</p>
                <p class="mb-0 small text-muted">
                    Ref: ${pedido.cliente.referenciaEntrega}
                </p>
            </div>
        </div>

        <hr>

        <p class="text-muted small fw-bold mb-2">
            DATA: ${pedido.dataRealizacao}
        </p>

        <%-- Itens do pedido --%>
        <p class="text-muted small fw-bold mb-2">ITENS</p>
        <div class="table-responsive">
            <table class="table table-sm align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Prato</th>
                        <th>Porção</th>
                        <th class="text-center">Qtd.</th>
                        <th class="text-end">Unit.</th>
                        <th class="text-end">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty pedido.pratoPedidos}">
                            <tr>
                                <td colspan="5" class="text-center text-muted">
                                    Nenhum prato neste pedido.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${pedido.pratoPedidos}">
                                <c:set var="sub" value="${item.prato.valor * item.quantidade}"/>
                                <tr>
                                    <td class="fw-semibold">${item.prato.nome}</td>
                                    <td>
                                        <span class="badge bg-secondary">${item.prato.porcao}</span>
                                    </td>
                                    <td class="text-center">${item.quantidade}</td>
                                    <td class="text-end">
                                        R$ <fmt:formatNumber value="${item.prato.valor}"
                                                             type="number"
                                                             minFractionDigits="2"
                                                             maxFractionDigits="2"/>
                                    </td>
                                    <td class="text-end fw-bold text-success">
                                        R$ <fmt:formatNumber value="${sub}"
                                                             type="number"
                                                             minFractionDigits="2"
                                                             maxFractionDigits="2"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
                <tfoot>
                    <tr class="table-warning">
                        <td colspan="4" class="text-end fw-bold">TOTAL:</td>
                        <td class="text-end fw-bold fs-6 text-success">
                            R$ <fmt:formatNumber value="${pedido.valorTotal}"
                                                 type="number"
                                                 minFractionDigits="2"
                                                 maxFractionDigits="2"/>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>

    <%-- Rodapé de Ações --%>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Voltar
        </a>
        
        <form action="${pageContext.request.contextPath}/pedidos/${pedido.idPedido}/excluir"
              method="post" class="d-inline"
              onsubmit="return confirm('Confirma a exclusão do pedido?')">
            <button type="submit" class="btn btn-outline-danger">
                <i class="bi bi-trash me-1"></i>Excluir Pedido
            </button>
        </form>

        <%-- NOVO BOTÃO: Emite o PDF do Recibo --%>
        <a href="${pageContext.request.contextPath}/pedidos/relatorio?id=${pedido.idPedido}" 
           target="_blank" 
           class="btn btn-danger">
            <i class="bi bi-file-earmark-pdf me-1"></i>Gerar PDF
        </a>
    </div>
</div>

<t:footer/>
</body>
</html>
