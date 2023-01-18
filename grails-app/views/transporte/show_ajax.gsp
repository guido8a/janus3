<g:if test="${transporteInstance?.codigo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${transporteInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${transporteInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${transporteInstance?.descripcion}
        </div>
    </div>
</g:if>

