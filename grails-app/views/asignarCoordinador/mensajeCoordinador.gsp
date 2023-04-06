<g:if test="${id != '' && id}">
    <g:if test="${getCoordinador != null}">
        <div class="col-md-5 alert alert-info" id="directorSel" style="font-weight: bold;">Coordinador Actual: ${getCoordinador?.persona?.nombre + " " +  getCoordinador?.persona?.apellido}</div>
    </g:if>
    <g:else>
        <div class="col-md-5 alert alert-danger" id="directorSel" style="font-weight: bold;">Coordinador Actual: El departamento seleccionado no cuenta con un coordinador asignado.</div>
    </g:else>
</g:if>
