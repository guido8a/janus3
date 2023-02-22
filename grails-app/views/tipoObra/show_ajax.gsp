<g:if test="${tipoObraInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${tipoObraInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${tipoObraInstance?.descripcion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Descripción
        </div>
        <div class="col-md-8">
            ${tipoObraInstance?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${tipoObraInstance?.grupo}">
    <div class="row">
        <div class="col-md-2 text-info">
           Grupo
        </div>
        <div class="col-md-8">
            ${tipoObraInstance?.grupo?.descripcion}
        </div>
    </div>
</g:if>