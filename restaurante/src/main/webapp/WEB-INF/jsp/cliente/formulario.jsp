<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"    uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="t"    tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${modo == 'novo' ? 'Novo Cliente' : 'Editar Cliente'} - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="clientes"/>

<div class="container mt-4" style="max-width: 720px;">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            </li>
            <li class="breadcrumb-item active">
                ${modo == 'novo' ? 'Novo' : 'Editar'}
            </li>
        </ol>
    </nav>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-person me-2"></i>
                ${modo == 'novo' ? 'Cadastrar Cliente' : 'Editar Cliente'}
            </h5>
        </div>
        <div class="card-body p-4">
            <c:set var="action"
                   value="${modo == 'novo'
                       ? pageContext.request.contextPath.concat('/clientes/novo')
                       : pageContext.request.contextPath.concat('/clientes/').concat(cliente.cpf).concat('/editar')}"/>

            <form:form action="${action}" method="post" modelAttribute="cliente">

                <div class="row">
                    <div class="col-md-5 mb-3">
                        <label for="cpf" class="form-label fw-semibold">CPF *</label>
                        <form:input path="cpf" cssClass="form-control" id="cpf"
                                    placeholder="Apenas números (11 dígitos)"
                                    maxlength="11"
                                    readonly="${modo == 'editar'}"/>
                        <form:errors path="cpf" cssClass="text-danger small"/>
                    </div>
                    <div class="col-md-7 mb-3">
                        <label for="nome" class="form-label fw-semibold">Nome *</label>
                        <form:input path="nome" cssClass="form-control" id="nome"
                                    placeholder="Nome completo"/>
                        <form:errors path="nome" cssClass="text-danger small"/>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="telefone" class="form-label fw-semibold">Telefone *</label>
                    <form:input path="telefone" cssClass="form-control" id="telefone"
                                placeholder="(11) 99999-9999" maxlength="14"/>
                    <form:errors path="telefone" cssClass="text-danger small"/>
                </div>

                <hr class="my-3">
                <p class="fw-semibold text-muted small mb-3">
                    <i class="bi bi-geo-alt me-1"></i>ENDEREÇO DE ENTREGA
                </p>

                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label for="logradouro" class="form-label fw-semibold">Logradouro *</label>
                        <form:input path="logradouro" cssClass="form-control" id="logradouro"
                                    placeholder="Rua, Avenida..."/>
                        <form:errors path="logradouro" cssClass="text-danger small"/>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="numero" class="form-label fw-semibold">Número *</label>
                        <form:input path="numero" cssClass="form-control" id="numero"
                                    type="number"/>
                        <form:errors path="numero" cssClass="text-danger small"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="cep" class="form-label fw-semibold">CEP *</label>
                        <form:input path="cep" cssClass="form-control" id="cep"
                                    placeholder="00000-000" maxlength="9"/>
                        <form:errors path="cep" cssClass="text-danger small"/>
                    </div>
                    <div class="col-md-8 mb-3">
                        <label for="referenciaEntrega" class="form-label fw-semibold">Referência de Entrega *</label>
                        <form:input path="referenciaEntrega" cssClass="form-control" id="referenciaEntrega"
                                    placeholder="Ex: Próximo ao mercado..."/>
                        <form:errors path="referenciaEntrega" cssClass="text-danger small"/>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle me-1"></i>Salvar
                    </button>
                    <a href="${pageContext.request.contextPath}/clientes"
                       class="btn btn-outline-secondary">
                        <i class="bi bi-x-circle me-1"></i>Cancelar
                    </a>
                </div>
            </form:form>
        </div>
    </div>
</div>

<t:footer/>
</body>
</html>
