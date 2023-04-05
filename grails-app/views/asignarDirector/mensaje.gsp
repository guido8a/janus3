<g:if test="${id != '-1'}">
    <g:if test="${obtenerDirector != null}">
        <div class="col-md-5 alert alert-info" id="directorSel" style="font-weight: bold;">Director Actual: ${obtenerDirector?.persona?.nombre + " " +  obtenerDirector?.persona?.apellido}</div>
    </g:if>
    <g:else>
        <div class="col-md-5 alert alert-danger" id="directorSel" style="font-weight: bold">Director Actual: La Dirección seleccionada no cuenta con un director asignado.</div>
    </g:else>
</g:if>

