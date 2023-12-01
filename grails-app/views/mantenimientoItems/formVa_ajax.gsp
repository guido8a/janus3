<%@ page import="janus.Lugar" %>

<div id="create" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave" action="saveVa_ajax">
        <g:hiddenField name="id" value="${vaeInstance?.id}"/>
        <g:hiddenField name="item" value="${item}"/>

        <div class="form-group ${hasErrors(bean: vaeInstance, field: 'fecha', 'error')} ">
            <span class="grupo">
                <label for="fechaVae" class="col-md-2 control-label text-info">
                    Fecha
                </label>
                <span class="col-md-6">
                        <input aria-label="" name="fecha" id='fechaVae' type='text' class="form-control required" value="${vaeInstance?.fecha?.format("dd-MM-yyyy") ?: fd.format("dd-MM-yyyy")}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: vaeInstance, field: 'porcentaje', 'error')} ">
            <span class="grupo">
                <label for="porcentaje" class="col-md-2 control-label text-info">
                    Valor
                </label>
                <span class="col-md-6">
                    <g:textField name="porcentaje"  maxlength="40" class="allCaps form-control required" value="${vaeInstance.porcentaje}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:form>
</div>

<script type="text/javascript">

    $('#fechaVae').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#porcentaje").keydown(function (ev){
        return validarNum(ev)
    });

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            (ev.keyCode === 190 || ev.keyCode === 110) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#frmSave").validate({
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

</script>
