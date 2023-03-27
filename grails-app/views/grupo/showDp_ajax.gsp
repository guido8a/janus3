<%@ page import="janus.DepartamentoItem" %>

<legend>${departamentoItemInstance.descripcion}</legend>

<g:if test="${departamentoItemInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-9">
            ${departamentoItemInstance?.subgrupo?.codigo?.toString()?.padLeft(3,'0')}.${departamentoItemInstance?.codigo?.toString()?.padLeft(3,'0')}
        </div>
    </div>
</g:if>

<g:if test="${departamentoItemInstance?.subgrupo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Grupo
        </div>
        <div class="col-md-9">
            ${departamentoItemInstance?.subgrupo?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${departamentoItemInstance?.transporte}">
    <div class="row">
        <div class="col-md-2 text-info">
            Transporte
        </div>
        <div class="col-md-9">
            ${departamentoItemInstance?.transporte?.descripcion}
        </div>
    </div>
</g:if>

