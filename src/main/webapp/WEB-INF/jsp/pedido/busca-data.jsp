<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedidos por Data - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="pedidos"/>

<div class="container mt-4" style="max-width: 500px;">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/pedidos">Pedidos</a>
            </li>
            <li class="breadcrumb-item active">Por Data</li>
        </ol>
    </nav>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-secondary text-white fw-bold">
            <i class="bi bi-calendar me-2"></i>Consultar Pedidos por Data
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/pedidos/por-data" method="get">
                <div class="mb-3">
                    <label for="data" class="form-label fw-semibold">Selecione a Data</label>
                    <input type="date" name="data" id="data" class="form-control"
                           value="${dataAtual}" required>
                </div>
                <button type="submit" class="btn btn-secondary">
                    <i class="bi bi-search me-1"></i>Buscar Pedidos
                </button>
            </form>
        </div>
    </div>
</div>

<t:footer/>
</body>
</html>
