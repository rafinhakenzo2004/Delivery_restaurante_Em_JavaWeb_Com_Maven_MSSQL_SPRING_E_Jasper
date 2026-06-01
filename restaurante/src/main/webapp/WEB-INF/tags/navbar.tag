<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="paginaAtiva" required="false" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-danger">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
            <i class="bi bi-egg-fried me-2"></i>Restaurante Delivery
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link ${paginaAtiva == 'pratos' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/pratos">
                        <i class="bi bi-journal-text me-1"></i>Pratos
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${paginaAtiva == 'ingredientes' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/ingredientes">
                        <i class="bi bi-basket me-1"></i>Ingredientes
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${paginaAtiva == 'clientes' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/clientes">
                        <i class="bi bi-people me-1"></i>Clientes
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${paginaAtiva == 'pedidos' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/pedidos">
                        <i class="bi bi-cart me-1"></i>Pedidos
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
