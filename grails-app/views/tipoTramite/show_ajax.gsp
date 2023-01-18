<g:if test="${tipoTramiteInstance?.codigo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Código
        </div>
        <div class="col-md-6">
            ${tipoTramiteInstance?.codigo}
        </div>
    </div>
</g:if>

<g:if test="${tipoTramiteInstance?.descripcion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Descripción
        </div>
        <div class="col-md-8">
            ${tipoTramiteInstance?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${tipoTramiteInstance?.padre}">
    <div class="row">
        <div class="col-md-2 text-info">
            Padre
        </div>
        <div class="col-md-8">
            ${tipoTramiteInstance?.padre?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${tipoTramiteInstance?.tiempo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Tiempo
        </div>
        <div class="col-md-6">
            ${tipoTramiteInstance?.tiempo + " días"}
        </div>
    </div>
</g:if>

<g:if test="${tipoTramiteInstance?.tipo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Tipo
        </div>
        <div class="col-md-6">
            ${tipoTramiteInstance?.tipo == 'P' ? 'Planilla' : (tipoTramiteInstance?.tipo == 'C' ? 'Contrato' : 'Obra')}
        </div>
    </div>
</g:if>

