<g:if test="${funcionInstance?.codigo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${funcionInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${funcionInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${funcionInstance?.descripcion}
        </div>
    </div>
</g:if>