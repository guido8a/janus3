<%@ page import="janus.Grupo" %>

<legend>${grupoInstance.descripcion}</legend>

<g:if test="${grupoInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-9">
            ${grupoInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${grupoInstance?.direccion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Dirección
        </div>
        <div class="col-md-9">
            ${grupoInstance?.direccion}
        </div>
    </div>
</g:if>
