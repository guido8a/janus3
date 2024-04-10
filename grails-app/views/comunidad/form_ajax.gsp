
<%@ page import="janus.Comunidad" %>

    <g:form class="form-horizontal" name="frmSave-comunidadInstance" action="save">
        <g:hiddenField name="id" value="${comunidadInstance?.id}"/>

        <div class="form-group ${hasErrors(bean: comunidadInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <span class="col-md-3">
                    <g:textField name="nombre" maxlength="63" class="form-control allCaps required" value="${comunidadInstance?.nombre}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: comunidadInstance, field: 'numero', 'error')} ">
            <span class="grupo">
                <label for="numero" class="col-md-2 control-label text-info">
                    Número
                </label>
                <span class="col-md-3">
                    <g:textField name="numero" maxlength="8" class="form-control required" value="${comunidadInstance?.numero}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: comunidadInstance, field: 'parroquia', 'error')} ">
            <span class="grupo">
                <label for="parroquia" class="col-md-2 control-label text-info">
                    Parroquia
                </label>
                <span class="col-md-3">
%{--                    <g:select id="canton" name="canton" from="${janus.Canton.list().sort{it.nombre}}" optionKey="id" optionValue="nombre" class="many-to-one form-control" value="${parroquiaInstance?.canton?.id ?: janus.Canton.get(padre)?.id}" noSelection="['null': '']"/>--}%
                    <g:select id="parroquia" name="parroquia" from="${janus.Parroquia.list().sort{it.nombre}}" optionKey="id" class="many-to-one form-control"  disabled="" value="${comunidadInstance?.parroquia?.id ?: janus.Parroquia.get(padre)?.id}" noSelection="['null': '']"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>


        <div class="form-group ${hasErrors(bean: comunidadInstance, field: 'latitud', 'error')} ">
            <span class="grupo">
                <label for="latitud" class="col-md-2 control-label text-info">
                    Latitud
                </label>
                <span class="col-md-3">
                    <g:textField name="latitud" class="form-control number" value="${comunidadInstance?.latitud}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: comunidadInstance, field: 'longitud', 'error')} ">
            <span class="grupo">
                <label for="longitud" class="col-md-2 control-label text-info">
                    Longitud
                </label>
                <span class="col-md-3">
                    <g:textField name="longitud" class="form-control number" value="${comunidadInstance?.longitud}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

                
    </g:form>

<script type="text/javascript">
    $("#frmSave-comunidadInstance").validate({
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
            submitForm();
            return false;
        }
        return true;
    });
</script>
