<g:if test="${estadoObraInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${estadoObraInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${estadoObraInstance?.descripcion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Descripción
        </div>
        <div class="col-md-8">
            ${estadoObraInstance?.descripcion}
        </div>
    </div>
</g:if>