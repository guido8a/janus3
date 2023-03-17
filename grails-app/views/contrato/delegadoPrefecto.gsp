<%@ page import="seguridad.Persona" %>

<div class="container">
    <div class="col-md-12">
        <div class="col-md-1">
            <label>Delegado:</label>
        </div>

        <div class="col-md-5">
            <g:select name="delegadoPrefecto" from="${seguridad.Persona.list([sort: 'apellido'])}" optionKey="id"
                      optionValue="${{it.apellido + ' ' + it.nombre }}" value="${contrato?.delegadoPrefecto?.id}"
                      noSelection="['null': 'No se ha definido aún ...']" class="form-control" />
        </div>

    </div>
</div>

