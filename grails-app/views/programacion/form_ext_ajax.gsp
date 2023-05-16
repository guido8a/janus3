<%@ page import="janus.Programacion" %>

<div id="create-Programacion" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-Programacion" action="save">
    <g:hiddenField name="id" value="${programacionInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: programacionInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-6">
                <g:textField name="descripcion" maxlength="40" class="form-control allCaps required" value="${programacionInstance?.descripcion}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: programacionInstance, field: 'fechaInicio', 'error')} ">
        <span class="grupo">
            <label for="fechaInicio" class="col-md-2 control-label text-info">
                Fecha Inicio
            </label>
            <span class="col-md-6">
                <input aria-label="" name="fechaInicio" id='fechaInicio' type='text' class="form-control required" value="${programacionInstance?.fechaInicio?.format("dd-MM-yyyy") ?: new Date().format("dd-MM-yyyy")}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: programacionInstance, field: 'fechaFin', 'error')} ">
        <span class="grupo">
            <label for="fechaFin" class="col-md-2 control-label text-info">
                Fecha Fin
            </label>
            <span class="col-md-6">
                <input aria-label="" name="fechaFin" id='fechaFin' type='text' class="form-control required" value="${programacionInstance?.fechaFin?.format("dd-MM-yyyy") ?: new Date().format("dd-MM-yyyy")}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: programacionInstance, field: 'grupo', 'error')} ">
        <span class="grupo">
            <label for="grupo" class="col-md-2 control-label text-info">
                Grupo
            </label>
            <span class="col-md-6">
                <g:select id="grupo" name="grupo.id" from="${janus.Grupo.list()}" optionKey="id" optionValue="descripcion" class="form-control" value="${programacionInstance?.grupo?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">

    $('#fechaInicio, #fechaFin').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#frmSave-Programacion").validate({
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

    $("input").keyup(function (ev) {
        if (ev.keyCode === 13) {
            submitFormPrograma();
        }
    });
</script>
