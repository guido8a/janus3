
<g:form class="form-horizontal" name="frmSave-Oferente" action="saveOferente">
    <g:hiddenField name="id" value="${personaInstance?.id}"/>

    <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cedula', 'error')}">
        <div class="col-md-6">
            <span class="grupo">
                <label for="cedula" class="col-md-4 control-label">
                    Cédula o RUC(Empresas)
                </label>

                <span class="col-md-6">
                    <g:textField name="cedula" maxlength="13" class="form-control input-sm required digits" value="${personaInstance?.cedula}"/>
                </span>
            </span>
        </div>
        <div class="col-md-6">
            <span class="grupo">
                <label for="nombre" class="col-md-4 control-label">
                    Perfil
                </label>

                <span class="col-md-8">
%{--                    <g:hiddenField name="departamento" class="" value="${seguridad.Prfl.findByCodigo("OFRT")?.id}"/>--}%
                    <g:textField name="perfilesTxt" class="form-control" value="${seguridad.Prfl.findByCodigo("OFRT")}" readonly="true"/>
                </span>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'nombre', 'error')} ${hasErrors(bean: personaInstance, field: 'apellido', 'error')} required">
        <div class="col-md-6">
            <span class="grupo">
                <label for="nombre" class="col-md-4 control-label">
                    Nombre
                </label>

                <span class="col-md-8">
                    <g:textField name="nombre" maxlength="30" required="" class="form-control input-sm required" value="${personaInstance?.nombre}"/>
                </span>
            </span>
        </div>

        <div class="col-md-6">
            <span class="grupo">
                <label for="apellido" class="col-md-4 control-label">
                    Apellido
                </label>

                <span class="col-md-8">
                    <g:textField name="apellido" maxlength="30" required="" class="form-control input-sm required" value="${personaInstance?.apellido}"/>
                </span>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'titulo', 'error')}">
        <div class="col-md-6">
            <span class="grupo">
                <label for="mail" class="col-md-4 control-label">
                    Mail
                </label>

                <span class="col-md-8">
                    <g:textField name="mail" maxlength="30" class="form-control required email" value="${personaInstance?.mail}"/>
                </span>
            </span>
        </div>

        <div class="col-md-6">
            <span class="grupo">
                <label for="titulo" class="col-md-4 control-label">
                    Título
                </label>

                <span class="col-md-8">
                    <g:textField name="titulo" maxlength="4" class="form-control" value="${personaInstance?.titulo}"/>
                </span>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fechaInicio', 'error')}">
        <div class="col-md-6">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-4 control-label">
                    Fecha inicio
                </label>

                <span class="col-md-8">
                    <input aria-label="" name="fechaInicio" id='fechaInicio' type='text' class="form-control" value="${personaInstance?.fechaInicio?.format("dd-MM-yyyy HH:mm")}" />
                </span>
            </span>
        </div>

        <div class="col-md-6">
            <span class="grupo">
                <label for="fechaFin" class="col-md-4 control-label">
                    Fecha fin
                </label>

                <span class="col-md-8">
                    <input aria-label="" name="fechaFin" id='fechaFin' type='text' class="form-control" value="${personaInstance?.fechaFin?.format("dd-MM-yyyy HH:mm")}" />
                </span>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cargo', 'error')}">
        <div class="col-md-6">
            <span class="grupo">
                <label for="mail" class="col-md-4 control-label">
                    Cargo
                </label>

                <span class="col-md-8">
                    <g:textField name="cargo" maxlength="50" class="form-control" value="${personaInstance?.cargo}"/>
                </span>
            </span>
        </div>

        <div class="col-md-6">
            <span class="grupo">
                <label for="login" class="col-md-4 control-label">
                    Login
                </label>

                <span class="col-md-8">
                    <g:textField name="login" minlength="4" maxlength="15" class="form-control required" value="${personaInstance?.login}"/>
                </span>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'password', 'error')}">
        <div class="col-md-6">
            <span class="grupo">
                <label for="password" class="col-md-4 control-label">
                    Password
                </label>

                <span class="col-md-8">
                    <g:passwordField name="password" maxlength="63" class="form-control required" value="${personaInstance?.password}"/>
                </span>
            </span>
        </div>

        <div class="col-md-6">
            <span class="grupo">
                <label for="login" class="col-md-4 control-label">
                    Verificar password
                </label>

                <span class="col-md-8">
                    <g:passwordField name="passwordVerif" equalTo="#password" maxlength="63" class="form-control required" value="${personaInstance?.password}"/>
                </span>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'firma', 'error')} ${hasErrors(bean: personaInstance, field: 'activo', 'error')}">
        <div class="col-md-12">
            <span class="grupo">
                <label for="activo" class="col-md-2 control-label">
                    Activo
                </label>

                <span class="col-md-2">
                    <g:select name="activo" value="${personaInstance.activo}" class="form-control input-sm required" required=""
                              from="${[1: 'Sí', 0: 'No']}" optionKey="key" optionValue="value"/>
                </span>

                <span class="col-md-2"></span>

                <label for="firma" class="col-md-2 control-label">
                    Firma
                </label>

                <span class="col-md-4">
                    <g:textField name="firma" maxlength="50" class="form-control" value="${personaInstance?.firma}"/>
                </span>
            </span>
        </div>
    </div>
</g:form>

<script type="text/javascript">


    $('#fechaFin, #fechaInicio').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#frmSave-Oferente").validate({
        errorClass    : "help-block",
        errorPlacement: function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success       : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
    });

</script>
