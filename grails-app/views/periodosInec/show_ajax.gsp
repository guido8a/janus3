
<%@ page import="janus.ejecucion.PeriodosInec" %>

<g:if test="${periodosInecInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${periodosInecInstance?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${periodosInecInstance?.fechaInicio}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Inicio
        </div>
        <div class="col-md-6">
            <g:formatDate date="${periodosInecInstance?.fechaInicio}" format="dd-MM-yyyy"/>
        </div>
    </div>
</g:if>

<g:if test="${periodosInecInstance?.fechaFin}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Fin
        </div>
        <div class="col-md-6">
            <g:formatDate date="${periodosInecInstance?.fechaFin}" format="dd-MM-yyyy"/>
        </div>
    </div>
</g:if>

<g:if test="${periodosInecInstance?.periodoCerrado}">
    <div class="row">
        <div class="col-md-3 text-info">
            Período Cerrado
        </div>
        <div class="col-md-6">
            ${periodosInecInstance?.periodoCerrado == 'N' ? 'NO' : 'SI'}
        </div>
    </div>
</g:if>
