
<g:if test="${aseguradoraInstance?.nombre}">
    <div class="row">
        <div class="col-md-2 text-info">
            Nombre
        </div>
        <div class="col-md-6">
            ${aseguradoraInstance?.nombre}
        </div>
    </div>
</g:if>
<g:if test="${aseguradoraInstance?.fax}">
    <div class="row">
        <div class="col-md-2 text-info">
            Fax
        </div>
        <div class="col-md-6">
            ${aseguradoraInstance?.fax}
        </div>
    </div>
</g:if>
<g:if test="${aseguradoraInstance?.telefonos}">
    <div class="row">
        <div class="col-md-2 text-info">
            Teléfonos
        </div>
        <div class="col-md-6">
            ${aseguradoraInstance?.telefonos}
        </div>
    </div>
</g:if>
<g:if test="${aseguradoraInstance?.mail}">
    <div class="row">
        <div class="col-md-2 text-info">
            Mail
        </div>
        <div class="col-md-6">
            ${aseguradoraInstance?.mail}
        </div>
    </div>
</g:if>
<g:if test="${aseguradoraInstance?.responsable}">
    <div class="row">
        <div class="col-md-2 text-info">
            Responsable
        </div>
        <div class="col-md-6">
            ${aseguradoraInstance?.responsable}
        </div>
    </div>
</g:if>
<g:if test="${aseguradoraInstance?.fechaContacto}">
    <div class="row">
        <div class="col-md-2 text-info">
            Fecha Contacto
        </div>
        <div class="col-md-6">
            <g:formatDate date="${aseguradoraInstance?.fechaContacto}" format="dd-MM-yyyy"/>
        </div>
    </div>
</g:if>
<g:if test="${aseguradoraInstance?.direccion}">
    <div class="row">
        <div class="col-md-2 text-info">
            Dirección
        </div>
        <div class="col-md-6">
            ${aseguradoraInstance?.direccion}
        </div>
    </div>
</g:if>
<g:if test="${aseguradoraInstance?.observaciones}">
    <div class="row">
        <div class="col-md-2 text-info">
            Observaciones
        </div>
        <div class="col-md-6">
            ${aseguradoraInstance?.observaciones}
        </div>
    </div>
</g:if>
<g:if test="${aseguradoraInstance?.tipo}">
    <div class="row">
        <div class="col-md-2 text-info">
            Tipo
        </div>
        <div class="col-md-6">
            ${aseguradoraInstance?.tipo?.descripcion}
        </div>
    </div>
</g:if>