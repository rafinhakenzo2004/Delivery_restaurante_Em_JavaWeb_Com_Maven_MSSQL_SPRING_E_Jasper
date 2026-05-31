<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"    uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="t"    tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${modo == 'novo' ? 'Novo Ingrediente' : 'Editar Ingrediente'} - Restaurante Delivery</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<t:navbar paginaAtiva="ingredientes"/>

<div class="container mt-4" style="max-width: 620px;">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/ingredientes">Ingredientes</a>
            </li>
            <li class="breadcrumb-item active">
                ${modo == 'novo' ? 'Novo' : 'Editar'}
            </li>
        </ol>
    </nav>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-success text-white">
            <h5 class="mb-0 fw-bold">
                <i class="bi bi-basket me-2"></i>
                ${modo == 'novo' ? 'Cadastrar Ingrediente' : 'Editar Ingrediente'}
            </h5>
        </div>
        <div class="card-body p-4">
            <c:set var="action"
                   value="${modo == 'novo'
                       ? pageContext.request.contextPath.concat('/ingredientes/novo')
                       : pageContext.request.contextPath.concat('/ingredientes/').concat(ingrediente.idIngrediente).concat('/editar')}"/>

            <form:form action="${action}" method="post" modelAttribute="ingrediente">

                <div class="mb-3">
                    <label for="nome" class="form-label fw-semibold">Nome *</label>
                    <form:input path="nome" cssClass="form-control" id="nome"
                                placeholder="Ex: Alface Americana"/>
                    <form:errors path="nome" cssClass="text-danger small"/>
                </div>

                <div class="mb-3">
                    <label for="apresentacao" class="form-label fw-semibold">Apresentação *</label>
                    <form:textarea path="apresentacao" cssClass="form-control" id="apresentacao"
                                   rows="3"
                                   placeholder="Descreva como o ingrediente é apresentado no prato..."/>
                    <form:errors path="apresentacao" cssClass="text-danger small"/>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-circle me-1"></i>Salvar
                    </button>
                    <a href="${pageContext.request.contextPath}/ingredientes"
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
