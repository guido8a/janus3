<g:if test="${direccionInstance?.nombre}">
    <div class="row">
        <div class="col-md-3 text-info">
            Nombre
        </div>
        <div class="col-md-6">
            ${direccionInstance?.nombre}
        </div>
    </div>
</g:if>

<g:if test="${direccionInstance?.jefatura}">
    <div class="row">
        <div class="col-md-3 text-info">
            Jefatura
        </div>
        <div class="col-md-6">
            ${direccionInstance?.jefatura}
        </div>
    </div>
</g:if>