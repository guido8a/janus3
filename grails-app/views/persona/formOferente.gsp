
<g:form class="form-horizontal" name="frmSave-Oferente" action="saveOferente">
    <g:hiddenField name="id" value="${personaInstance?.id}"/>
    <table cellpadding="5">
        <tr>
            <td width="100px">
                <span class="control-label label label-inverse">
                    Cédula o RUC(Empresas)
                </span>
            </td>
            <td width="250px">
                <g:textField name="cedula" maxlength="13" class="span2 required" value="${personaInstance?.cedula}"/>
                <p class="help-block ui-helper-hidden"></p>
                <span class="mandatory">*</span>
            </td>
            <td>
                <span class="control-label label label-inverse">
                    Nombre
                </span>
            </td>
            <td>
                <g:textField name="nombre" maxlength="30" class="span2 required" value="${personaInstance?.nombre}"/>
                <p class="help-block ui-helper-hidden"></p>
                <span class="mandatory">*</span>
            </td>
        </tr>
        <tr>
            <td>
                <span class="control-label label label-inverse">
                    Apellido
                </span>
            </td>
            <td>
                <g:textField name="apellido" maxlength="30" class="span2 required" value="${personaInstance?.apellido}"/>
                <p class="help-block ui-helper-hidden"></p>
                <span class="mandatory">*</span>
            </td>
            <td>
                <span class="control-label label label-inverse">
                    Perfil
                </span>
            </td>
            <td>

                <g:textField name="perfilesTxt" class="span2" value="${seguridad.Prfl.findByCodigo("OFRT")}" readonly="true"/>

                <g:hiddenField name="perfiles" class="span2" value="${seguridad.Prfl.findByCodigo("OFRT")?.id}"/>

            </td>

        </tr>
        <tr>
            <td>
                <span class="control-label label label-inverse">
                    Fecha Nacimiento
                </span>
            </td>
            <td>
%{--                <elm:datepicker name="fechaNacimiento" class="span2" value="${personaInstance?.fechaNacimiento}" yearRange="-75:-18"/>--}%
                <p class="help-block ui-helper-hidden"></p>
            </td>
            <td>
                <span class="control-label label label-inverse">
                    Departamento
                </span>
            </td>
            <td>
                OFERENTES

%{--                <g:hiddenField name="departamento.id" class="span2" value="${janus.Departamento?.findByDescripcion("OFERENTES")?.id}" optionKey="id"/>--}%

                <p class="help-block ui-helper-hidden"></p>
            </td>
        </tr>
        <tr>
            <td>
                <span class="control-label label label-inverse">
                    Fecha Inicio
                </span>
            </td>
            <td>
%{--                <elm:datepicker name="fechaInicio" class="span2" value="${personaInstance?.fechaInicio}" yearRange="-1:+0"/>--}%


                <p class="help-block ui-helper-hidden"></p>
            </td>
            <td>
                <span class="control-label label label-inverse">
                    Fecha Fin
                </span>
            </td>
            <td>
%{--                <elm:datepicker name="fechaFin" class="span2" value="${personaInstance?.fechaFin}" yearRange="-1:+0"/>--}%


                <p class="help-block ui-helper-hidden"></p>
            </td>
        </tr>
        <tr>
            <td>
                <span class="control-label label label-inverse">
                    Título
                </span>
            </td>
            <td>
                <g:textField name="titulo" maxlength="4" class="span2" value="${personaInstance?.titulo}"/>

                <p class="help-block ui-helper-hidden"></p>
            </td>

            <td>
                <span class="control-label label label-inverse">
                    Mail
                </span>
            </td>
            <td>
                <g:textField name="email" maxlength="63" class="span2 required" value="${personaInstance?.mail}"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </td>

        </tr>
        <tr>
            <td>
                <span class="control-label label label-inverse">
                    Cargo
                </span>
            </td>
            <td>
                <g:textField name="cargo" maxlength="50" class="span2" value="${personaInstance?.cargo}"/>

                <p class="help-block ui-helper-hidden"></p>
            </td>
            <td>
                <span class="control-label label label-inverse">
                    Login
                </span>
            </td>
            <td>
                <g:textField name="login" maxlength="16" class="span2 required" value="${personaInstance?.login}"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </td>
        </tr>
            <tr>
                <td>
                    <span class="control-label label label-inverse">
                        Password
                    </span>
                </td>
                <td>
                    <g:passwordField name="password" maxlength="63" class="span2 required" value="${personaInstance?.password}"/>
                    <span class="mandatory">*</span>

                    <p class="help-block ui-helper-hidden"></p>
                </td>
                <td>
                    <span class="control-label label label-inverse">
                        Verificar Password
                    </span>
                </td>
                <td>
                    <g:passwordField name="passwordVerif" equalTo="#password" maxlength="63" class="span2 required" value="${personaInstance?.password}"/>
                    <span class="mandatory">*</span>

                    <p class="help-block ui-helper-hidden"></p>
                </td>
            </tr>

        <tr>
            <td>
                <span class="control-label label label-inverse">
                    Activo
                </span>
            </td>
            <td>
                <g:radioGroup name="activo" values="['1', '0']" labels="['Sí', 'No']" value="${personaInstance?.id ? personaInstance.activo : '0'}">
                    ${it.label} ${it.radio}
                </g:radioGroup>
                <p class="help-block ui-helper-hidden"></p>
            </td>
            <td>
                <span class="control-label label label-inverse">
                    Firma
                </span>
            </td>
            <td>
                <g:textField name="firma" maxlength="50" class="span2 required" value="${personaInstance?.firma}"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </td>

        </tr>
        <tr>

        </tr>
    </table>
</g:form>


<script type="text/javascript">
    $("#frmSave-Oferente").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important",
        submitHandler  : function (form) {
            $(".btn-success").replaceWith(spinner);
            form.submit();
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });
</script>
