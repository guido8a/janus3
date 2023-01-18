<g:if test="${tipoItemInstance?.codigo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${tipoItemInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${tipoItemInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${tipoItemInstance?.descripcion}
        </div>
    </div>
</g:if>