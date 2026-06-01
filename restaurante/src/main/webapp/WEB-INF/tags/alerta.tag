<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${not empty mensagem}">
    <div class="alert alert-${tipoMensagem} alert-dismissible fade show" role="alert">
        <c:out value="${mensagem}"/>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
