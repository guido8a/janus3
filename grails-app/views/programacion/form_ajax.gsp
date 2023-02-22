<%@ page import="janus.Programacion" %>

<div id="create-Programacion" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-Programacion" action="save">
    <g:hiddenField name="id" value="${programacionInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: programacionInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="40" class="form-control allCaps required" value="${programacionInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: programacionInstance, field: 'grupo', 'error')} ">
        <span class="grupo">
            <label for="grupo" class="col-md-2 control-label text-info">
                Grupo
            </label>
            <span class="col-md-4">
                <g:select name="grupo" from="${janus.Grupo.list()}"  optionValue="descripcion" optionKey="id"  class="form-control required" value="${programacionInstance?.grupo?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: programacionInstance, field: 'fechaInicio', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Fecha Inicio
            </label>
            <span class="col-md-4">
                <input aria-label="" name="fechaInicio" id='fecha1' type='text' class="form-control" value="${programacionInstance?.fechaInicio?.format("dd-MM-yyyy")}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: programacionInstance, field: 'fechaFin', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Fecha Fin
            </label>
            <span class="col-md-4">
                <input aria-label="" name="fechaFin" id='fecha2' type='text' class="form-control" value="${programacionInstance?.fechaFin?.format("dd-MM-yyyy")}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">

    $('#fecha1, #fecha2').datetimepicker({
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
    $(".form-control").keydown(function (ev) {
        if (ev.keyCode === 13) {
            submitFormProgramacion();
            return false;
        }
        return true;
    });
</script>
