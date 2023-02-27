<g:if test="${tipoProcedimientoInstance?.descripcion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${tipoProcedimientoInstance?.descripcion}
        </div>
    </div>
</g:if>
<g:if test="${tipoProcedimientoInstance?.sigla}">
    <div class="row">
        <div class="col-md-2 text-info">
            Sigla
        </div>
        <div class="col-md-6">
            ${tipoProcedimientoInstance?.sigla}
        </div>
    </div>
</g:if>
<g:if test="${tipoProcedimientoInstance?.fuente}">
    <div class="row">
        <div class="col-md-2 text-info">
            Fuente
        </div>
        <div class="col-md-6">
            ${tipoProcedimientoInstance?.fuente}
        </div>
    </div>
</g:if>
<g:if test="${tipoProcedimientoInstance?.bases}">
    <div class="row">
        <div class="col-md-2 text-info">
            Bases
        </div>
        <div class="col-md-6">
            ${tipoProcedimientoInstance?.bases}
        </div>
    </div>
</g:if>
<g:if test="${tipoProcedimientoInstance?.contractual}">
    <div class="row">
        <div class="col-md-2 text-info">
            Contractual
        </div>
        <div class="col-md-6">
            ${tipoProcedimientoInstance?.contractual}
        </div>
    </div>
</g:if>
<g:if test="${tipoProcedimientoInstance?.precontractual}">
    <div class="row">
        <div class="col-md-2 text-info">
            Precontractual
        </div>
        <div class="col-md-6">
            ${tipoProcedimientoInstance?.precontractual}
        </div>
    </div>
</g:if>
<g:if test="${tipoProcedimientoInstance?.preparatorio}">
    <div class="row">
        <div class="col-md-2 text-info">
            Preparatorio
        </div>
        <div class="col-md-6">
            ${tipoProcedimientoInstance?.preparatorio}
        </div>
    </div>
</g:if>
<g:if test="${tipoProcedimientoInstance?.techo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Techo
        </div>
        <div class="col-md-6">
            ${tipoProcedimientoInstance?.techo}
        </div>
    </div>
</g:if>