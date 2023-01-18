<g:if test="${grupoInstance?.codigo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${grupoInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${grupoInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${grupoInstance?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${grupoInstance?.direccion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Dirección
        </div>
        <div class="col-md-6">
            ${grupoInstance?.direccion?.nombre}
        </div>
    </div>
</g:if>