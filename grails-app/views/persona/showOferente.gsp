
<g:if test="${personaInstance?.cedula}">
    <div class="row">
        <div class="col-md-3 text-info">
            Cédula
        </div>
        <div class="col-md-6">
            ${personaInstance?.cedula}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.nombre}">
    <div class="row">
        <div class="col-md-3 text-info">
            Nombre
        </div>
        <div class="col-md-6">
            ${personaInstance?.nombre}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.apellido}">
    <div class="row">
        <div class="col-md-3 text-info">
            Apellido
        </div>
        <div class="col-md-6">
            ${personaInstance?.apellido}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.departamento}">
    <div class="row">
        <div class="col-md-3 text-info">
            Coordinación
        </div>
        <div class="col-md-6">
            ${personaInstance?.departamento?.descripcion}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.fechaInicio}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha inicio
        </div>
        <div class="col-md-6">
            ${personaInstance?.fechaInicio?.format("dd-MM-yyyy")}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.fechaFin}">
    <div class="row">
        <div class="col-md-3 text-info">
            Fecha fin
        </div>
        <div class="col-md-6">
            ${personaInstance?.fechaFin?.format("dd-MM-yyyy")}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.sigla}">
    <div class="row">
        <div class="col-md-3 text-info">
            Sigla
        </div>
        <div class="col-md-6">
            ${personaInstance?.sigla}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.titulo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Titulo
        </div>
        <div class="col-md-6">
            ${personaInstance?.titulo}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.cargo}">
    <div class="row">
        <div class="col-md-3 text-info">
            Cargo
        </div>
        <div class="col-md-6">
            ${personaInstance?.cargo}
        </div>
    </div>
</g:if>
<g:if test="${personaInstance?.login}">
    <div class="row">
        <div class="col-md-3 text-info">
            Login
        </div>
        <div class="col-md-6">
            ${personaInstance?.login}
        </div>
    </div>
</g:if>

<g:if test="${personaInstance?.activo != null}">
    <div class="row">
        <div class="col-md-3 text-info">
            Activo
        </div>
        <div class="col-md-6">
            ${personaInstance?.activo == 1 ? 'SI' : 'NO'}
        </div>
    </div>
</g:if>
