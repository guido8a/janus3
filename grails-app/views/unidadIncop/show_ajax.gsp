
<g:if test="${unidadIncopInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${unidadIncopInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${unidadIncopInstance?.descripcion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Descripción
        </div>
        <div class="col-md-8">
            ${unidadIncopInstance?.descripcion}
        </div>
    </div>
</g:if>