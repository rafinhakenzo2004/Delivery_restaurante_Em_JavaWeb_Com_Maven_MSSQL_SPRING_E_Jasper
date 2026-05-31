<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Busca por Cliente - Restaurante Delivery</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

	<t:navbar paginaAtiva="pedidos" />

	<div class="container mt-4" style="max-width: 600px;">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb">
				<li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/pedidos">Pedidos</a></li>
				<li class="breadcrumb-item active">Buscar por Cliente</li>
			</ol>
		</nav>

		<c:if test="${not empty erro}">
			<div class="alert alert-warning">
				<i class="bi bi-exclamation-triangle me-2"></i>${erro}
			</div>
		</c:if>

		<div class="card border-0 shadow-sm">
			<div class="card-header bg-warning text-dark fw-bold">
				<i class="bi bi-person-search me-2"></i>Consultar Pedido Atual do Cliente
			</div>
			<div class="card-body p-4">
				<form action="${pageContext.request.contextPath}/pedidos/buscar-por-cpf" method="get">
					<div class="mb-3">
						<label for="cpf" class="form-label fw-semibold">Selecione o Cliente</label> 
						<select name="cpf" id="cpf" class="form-select" required>
							<option value="" disabled selected>Escolha um cliente da lista...</option>
							<c:forEach var="cliente" items="${clientes}">
								<option value="${cliente.cpf}">${cliente.nome} - (CPF: ${cliente.cpf})</option>
							</c:forEach>
						</select>
					</div>
					<button type="submit" class="btn btn-secondary">
						<i class="bi bi-search me-1"></i>Buscar Pedido
					</button>
				</form>
			</div>
		</div>
	</div>

	<t:footer />
</body>
</html>