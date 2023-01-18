<g:if test="${unidadInstance?.codigo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${unidadInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${unidadInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${unidadInstance?.descripcion}
        </div>
    </div>
</g:if>