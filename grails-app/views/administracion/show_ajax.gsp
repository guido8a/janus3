<g:if test="${administracionInstance?.nombrePrefecto}">
    <div class="row">
        <div class="col-md-3 text-info">
            Nombre del Prefecto
        </div>
        <div class="col-md-6">
            ${administracionInstance?.nombrePrefecto}
        </div>
    </div>
</g:if>

<g:if test="${administracionInstance?.descripcion}">
    <div class="row">
        <div class="col-md-3 text-info">
            Descripción
        </div>
        <div class="col-md-6">
            ${administracionInstance?.descripcion}
        </div>
    </div>
</g:if>

<g:if test="${administracionInstance?.fechaInicio}">
    <div class="row">
        <div class="col-md-3 text-info">
           Fecha Inicio
        </div>
        <div class="col-md-6">
            <g:formatDate date="${administracionInstance?.fechaInicio}" format="dd-MM-yyyy"/>
        </div>
    </div>
</g:if>

<g:if test="${administracionInstance?.fechaFin}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha Fin
        </div>
        <div class="col-md-6">
            <g:formatDate date="${administracionInstance?.fechaFin}" format="dd-MM-yyyy"/>
        </div>
    </div>
</g:if>