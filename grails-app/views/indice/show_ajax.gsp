
<%@ page import="janus.Indice" %>

<g:if test="${indiceInstance?.tipoIndice}">
    <div class="row">
        <div class="col-md-3 text-info">
            Tipo de Índice
        </div>
        <div class="col-md-6">
            ${indiceInstance?.tipoIndice?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${indiceInstance?.codigo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${indiceInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${indiceInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${indiceInstance?.descripcion}
        </div>
    </div>
</g:if>
