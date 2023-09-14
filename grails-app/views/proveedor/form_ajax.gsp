
<%@ page import="janus.pac.Proveedor" %>

<div id="create-Proveedor" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-Proveedor" action="save">
    <g:hiddenField name="id" value="${proveedorInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'especialidad', 'error')} ">
        <span class="grupo">
            <label for="especialidad" class="col-md-2 control-label text-info">
                Especialidad
            </label>
            <span class="col-md-4">
                <g:select id="especialidad" name="especialidad" from="${janus.EspecialidadProveedor.list()}" optionKey="id" optionValue="descripcion" class="form-control" value="${proveedorInstance?.especialidad?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'tipo', 'error')} ">
        <span class="grupo">
            <label for="tipo" class="col-md-2 control-label text-info">
                Tipo
            </label>
            <span class="col-md-4">
                <g:select id="tipo" name="tipo" from="${['J' : 'Jurídica', 'N': 'Natural', 'E' : 'Empresa Pública']}" optionKey="key" optionValue="value" class="form-control" value="${proveedorInstance?.tipo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'ruc', 'error')} ">
        <span class="grupo">
            <label for="ruc" class="col-md-2 control-label text-info">
                RUC
            </label>
            <span class="col-md-8">
                <g:textField name="ruc" maxlength="13" class="form-control required" value="${proveedorInstance?.ruc}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'nombre', 'error')} ">
        <span class="grupo">
            <label for="nombre" class="col-md-2 control-label text-info">
                Nombre
            </label>
            <span class="col-md-8">
                <g:textField name="nombre" maxlength="63" class="form-control required" value="${proveedorInstance?.nombre}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'nombreContacto', 'error')} ">
        <span class="grupo">
            <label for="nombreContacto" class="col-md-2 control-label text-info">
                Nombre contacto
            </label>
            <span class="col-md-8">
                <g:textField name="nombreContacto" maxlength="31" class="form-control required" value="${proveedorInstance?.nombreContacto}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'apellidoContacto', 'error')} ">
        <span class="grupo">
            <label for="apellidoContacto" class="col-md-2 control-label text-info">
                Apellido contacto
            </label>
            <span class="col-md-8">
                <g:textField name="apellidoContacto" maxlength="31" class="form-control" value="${proveedorInstance?.apellidoContacto}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'direccion', 'error')} ">
        <span class="grupo">
            <label for="direccion" class="col-md-2 control-label text-info">
                Dirección
            </label>
            <span class="col-md-8">
                <g:textField name="direccion" maxlength="60" class="form-control" value="${proveedorInstance?.direccion}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'telefonos', 'error')} ">
        <span class="grupo">
            <label for="telefonos" class="col-md-2 control-label text-info">
                Teléfono
            </label>
            <span class="col-md-8">
                <g:textField name="telefonos" maxlength="40" class="form-control" value="${proveedorInstance?.telefonos}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'email', 'error')} ">
        <span class="grupo">
            <label for="email" class="col-md-2 control-label text-info">
                Email
            </label>
            <span class="col-md-8">
                <g:textField name="email" maxlength="40" class="form-control email mail" value="${proveedorInstance?.email}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'garante', 'error')} ">
        <span class="grupo">
            <label for="garante" class="col-md-2 control-label text-info">
                Gerente
            </label>
            <span class="col-md-8">
                <g:textField name="garante" maxlength="40" class="form-control" value="${proveedorInstance?.garante}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'titulo', 'error')} ">
        <span class="grupo">
            <label for="titulo" class="col-md-2 control-label text-info">
                Título
            </label>
            <span class="col-md-4">
                <g:textField name="titulo" maxlength="4" class="form-control" value="${proveedorInstance?.titulo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'origen', 'error')} ">
        <span class="grupo">
            <label for="origen" class="col-md-2 control-label text-info">
                Origen
            </label>
            <span class="col-md-4">
                <g:select name="origen" from="${['N' : 'Nacional', 'E': 'Extranjero', 'M' : 'Multinacional']}" optionKey="key" optionValue="value" class="form-control" value="${proveedorInstance?.origen}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'pagarNombre', 'error')} ">
        <span class="grupo">
            <label for="pagarNombre" class="col-md-2 control-label text-info">
                Pago a nombre de
            </label>
            <span class="col-md-8">
                <g:textField name="pagarNombre" maxlength="63" class="form-control" value="${proveedorInstance?.pagarNombre}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'estado', 'error')} ">
        <span class="grupo">
            <label for="estado" class="col-md-2 control-label text-info">
                Estado
            </label>
            <span class="col-md-4">
                <g:select name="estado" from="${[1 : 'Activo', 0: 'Inactivo']}" optionKey="key" optionValue="value" class="form-control" value="${proveedorInstance?.estado}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: proveedorInstance, field: 'observaciones', 'error')} ">
        <span class="grupo">
            <label for="observaciones" class="col-md-2 control-label text-info">
                Observaciones
            </label>
            <span class="col-md-8">
                <g:textArea name="observaciones" maxlength="127" class="form-control" value="${proveedorInstance?.observaciones}" style="resize: none;" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">
    $("#frmSave-Proveedor").validate({
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
            submitFormProveedor();
            return false;
        }
        return true;
    });
</script>
