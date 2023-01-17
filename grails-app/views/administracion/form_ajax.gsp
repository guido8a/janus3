<g:form class="form-horizontal" name="frmAdministracion" action="saveAdministracion_ajax">
    <g:hiddenField name="id" value="${administracionInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: administracionInstance, field: 'nombrePrefecto', 'error')} ">
        <span class="grupo">
            <label for="nombrePrefecto" class="col-md-3 control-label text-info">
                Nombre prefecto
            </label>
            <span class="col-md-6">
                <g:textField name="nombrePrefecto" maxlength="63" class="form-control required" value="${administracionInstance?.nombrePrefecto}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: administracionInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-3 control-label text-info">
                Descripción
            </label>
            <span class="col-md-6">
                <g:textField name="descripcion" maxlength="63" class="form-control required" value="${administracionInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: administracionInstance, field: 'fechaInicio', 'error')} ">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
               Fecha inicio
            </label>
            <span class="col-md-6">
                <input aria-label="" name="fechaInicio" id='datetimepicker1' type='text' class="form-control required"
                       value="${administracionInstance?.fechaInicio?.format("dd-MM-yyyy")}"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: administracionInstance, field: 'fechaFin', 'error')} ">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
                Fecha fin
            </label>
            <span class="col-md-6">
                <input aria-label="" name="fechaFin" id='datetimepicker2' type='text' class="form-control required"
                       value="${administracionInstance?.fechaFin?.format("dd-MM-yyyy")}"/>
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">

    $('#datetimepicker1, #datetimepicker2').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        // daysOfWeekDisabled: [0, 6],
        sideBySide: true,
        icons: {
        }
    });

    var validator = $("#frmAdministracion").validate({
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
            submitFormAdministracion();
            return false;
        }
        return true;
    });
</script>