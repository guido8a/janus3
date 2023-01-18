<g:if test="${rolTramiteInstance?.codigo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${rolTramiteInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${rolTramiteInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${rolTramiteInstance?.descripcion}
        </div>
    </div>
</g:if>