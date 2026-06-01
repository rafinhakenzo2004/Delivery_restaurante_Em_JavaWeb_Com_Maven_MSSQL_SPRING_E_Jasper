<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar/>

<main class="container mt-5">
    <div class="text-center mb-5">
        <h1 class="display-4 fw-bold text-danger">
            <i class="bi bi-egg-fried"></i> Restaurante Delivery
        </h1>
        <p class="lead text-muted">Sistema de Gerenciamento de Pedidos &mdash; FATEC ZL</p>
    </div>

    <div class="row g-4 justify-content-center">
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/pratos" class="text-decoration-none">
                <div class="card border-0 shadow-sm h-100 card-hover text-center p-4">
                    <i class="bi bi-journal-text display-4 text-danger mb-3"></i>
                    <h5 class="fw-bold">Pratos</h5>
                    <p class="text-muted small mb-0">Gerencie o cardápio</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/ingredientes" class="text-decoration-none">
                <div class="card border-0 shadow-sm h-100 card-hover text-center p-4">
                    <i class="bi bi-basket display-4 text-success mb-3"></i>
                    <h5 class="fw-bold">Ingredientes</h5>
                    <p class="text-muted small mb-0">Controle os ingredientes</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/clientes" class="text-decoration-none">
                <div class="card border-0 shadow-sm h-100 card-hover text-center p-4">
                    <i class="bi bi-people display-4 text-primary mb-3"></i>
                    <h5 class="fw-bold">Clientes</h5>
                    <p class="text-muted small mb-0">Cadastro de clientes</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/pedidos" class="text-decoration-none">
                <div class="card border-0 shadow-sm h-100 card-hover text-center p-4">
                    <i class="bi bi-cart display-4 text-warning mb-3"></i>
                    <h5 class="fw-bold">Pedidos</h5>
                    <p class="text-muted small mb-0">Gerencie os pedidos</p>
                </div>
            </a>
        </div>
    </div>

    <div class="row g-3 mt-4 justify-content-center">
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/pedidos/novo" class="btn btn-danger btn-lg">
                <i class="bi bi-plus-circle me-2"></i>Novo Pedido
            </a>
        </div>
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/pratos/com-ingredientes" class="btn btn-outline-secondary btn-lg">
                <i class="bi bi-list-ul me-2"></i>Cardápio com Ingredientes
            </a>
        </div>
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/pedidos/busca-data" class="btn btn-outline-secondary btn-lg">
                <i class="bi bi-calendar me-2"></i>Pedidos por Data
            </a>
        </div>
    </div>
</main>

<t:footer/>
</body>
</html>
