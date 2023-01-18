<g:if test="${departamentoInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-8">
            ${departamentoInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${departamentoInstance?.descripcion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Descripción
        </div>
        <div class="col-md-8">
            ${departamentoInstance?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${departamentoInstance?.direccion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Dirección
        </div>
        <div class="col-md-8">
            ${departamentoInstance?.direccion}
        </div>
    </div>
</g:if>

<g:if test="${departamentoInstance?.requirente}">
    <div class="row">
        <div class="col-md-2 text-info">
            Requirente
        </div>
        <div class="col-md-8">
            ${departamentoInstance?.requirente == 1 ? 'SI' : 'NO'}
        </div>
    </div>
</g:if>