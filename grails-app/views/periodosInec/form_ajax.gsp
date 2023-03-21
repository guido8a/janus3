
<%@ page import="janus.ejecucion.PeriodosInec" %>

<div id="create-PeriodosInec" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-PeriodosInec" action="save">
        <g:hiddenField name="id" value="${periodosInecInstance?.id}"/>

        <div class="form-group ${hasErrors(bean: periodosInecInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-3 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-5">
                    <g:textField name="descripcion" maxlength="31" class="form-control required" value="${periodosInecInstance?.descripcion}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: periodosInecInstance, field: 'fechaInicio', 'error')} ">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-3 control-label text-info">
                    Fecha Inicio
                </label>
                <span class="col-md-5">
                    <input aria-label="" name="fechaInicio" id='fechaInicio' type='text' class="form-control required" value="${periodosInecInstance?.fechaInicio?.format("dd-MM-yyyy")}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: periodosInecInstance, field: 'fechaFin', 'error')} ">
            <span class="grupo">
                <label for="fechaFin" class="col-md-3 control-label text-info">
                    Fecha Fin
                </label>
                <span class="col-md-5">
                    <input aria-label="" name="fechaFin" id='fechaFin' type='text' class="form-control required" value="${periodosInecInstance?.fechaFin?.format("dd-MM-yyyy")}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: periodosInecInstance, field: 'periodoCerrado', 'error')} ">
            <span class="grupo">
                <label for="periodoCerrado" class="col-md-3 control-label text-info">
                    Período Cerrado
                </label>
                <span class="col-md-2">
                    <g:select name="periodoCerrado" from="${['N' : 'NO' , 'S' : 'SI']}" class="form-control required" value="${periodosInecInstance?.periodoCerrado}" optionKey="key" optionValue="value" />
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

    $("#frmSave-PeriodosInec").validate({
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
            submitFormPeriodo();
            return false;
        }
        return true;
    });
</script>
