<g:if test="${claseObraInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${claseObraInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${claseObraInstance?.descripcion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Descripción
        </div>
        <div class="col-md-8">
            ${claseObraInstance?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${claseObraInstance?.grupo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Grupo
        </div>
        <div class="col-md-8">
            ${claseObraInstance?.grupo?.descripcion}
        </div>
    </div>
</g:if>