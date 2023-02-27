<%@ page import="janus.pac.Aseguradora" %>

<div id="create-Aseguradora" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-Aseguradora" action="save">
    <g:hiddenField name="id" value="${aseguradoraInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'nombre', 'error')} ">
        <span class="grupo">
            <label for="nombre" class="col-md-2 control-label text-info">
                Nombre
            </label>
            <span class="col-md-8">
                <g:textField name="nombre" maxlength="61" class="form-control required" value="${aseguradoraInstance?.nombre}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'fax', 'error')} ">
        <span class="grupo">
            <label for="fax" class="col-md-2 control-label text-info">
                Fax
            </label>
            <span class="col-md-6">
                <g:textField name="fax" maxlength="15" class="form-control" value="${aseguradoraInstance?.fax}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'telefonos', 'error')} ">
        <span class="grupo">
            <label for="telefonos" class="col-md-2 control-label text-info">
                Teléfonos
            </label>
            <span class="col-md-6">
                <g:textField name="telefonos" maxlength="63" class="form-control" value="${aseguradoraInstance?.telefonos}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'mail', 'error')} ">
        <span class="grupo">
            <label for="mail" class="col-md-2 control-label text-info">
                Email
            </label>
            <span class="col-md-8">
                <g:textField name="mail" maxlength="63" class="form-control email" value="${aseguradoraInstance?.mail}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'responsable', 'error')} ">
        <span class="grupo">
            <label for="responsable" class="col-md-2 control-label text-info">
               Responsable
            </label>
            <span class="col-md-8">
                <g:textField name="responsable" maxlength="63" class="form-control" value="${aseguradoraInstance?.responsable}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'tipo', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Tipo
            </label>
            <span class="col-md-6">
                <g:select name="tipo" from="${janus.pac.TipoAseguradora.list()}" optionKey="id" optionValue="descripcion"
                          class="many-to-one form-control" value="${aseguradoraInstance?.tipo?.id}" noSelection="['null': 'Seleccione...']"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'fechaContacto', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Fecha Contacto
            </label>
            <span class="col-md-4">
                <input aria-label="" name="fechaContacto" id='fecha1' type='text' class="form-control" value="${aseguradoraInstance?.fechaContacto?.format("dd-MM-yyyy")}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'direccion', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Dirección
            </label>
            <span class="col-md-8">
                <g:textArea name="direccion" maxlength="127" class="form-control" style="resize: none;" value="${aseguradoraInstance?.direccion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: aseguradoraInstance, field: 'observaciones', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Dirección
            </label>
            <span class="col-md-8">
                <g:textArea name="observaciones" maxlength="127" style="resize: none;" class="form-control" value="${aseguradoraInstance?.observaciones}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">

    $("#frmSave-Aseguradora").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
        }
    });
    $(".form-control").keydown(function (ev) {
        if (ev.keyCode === 13) {
            submitFormAseguradora();
            return false;
        }
        return true;
    });

    $('#fecha1').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
                (ev.keyCode >= 96 && ev.keyCode <= 105) ||
                ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
                ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#fax, #telefonos").keydown(function (ev){
        return validarNum(ev)
    });

</script>
