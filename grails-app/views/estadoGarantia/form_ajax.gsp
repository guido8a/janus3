
<%@ page import="janus.pac.EstadoGarantia" %>

<div id="create-EstadoGarantia" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-EstadoGarantia" action="save">
        <g:hiddenField name="id" value="${estadoGarantiaInstance?.id}"/>

        <div class="form-group ${hasErrors(bean: estadoGarantiaInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-3">
                    <g:textField name="codigo" maxlength="2" class="form-control allCaps required" value="${estadoGarantiaInstance?.codigo}" readonly="${estadoGarantiaInstance?.id ? true : false}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: estadoGarantiaInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textField name="descripcion" maxlength="30" class="form-control required" value="${estadoGarantiaInstance?.descripcion}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

    </g:form>

<script type="text/javascript">
    $("#frmSave-EstadoGarantia").validate({
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
            submitFormEG();
            return false;
        }
        return true;
    });

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
                (ev.keyCode >= 96 && ev.keyCode <= 105) ||
                ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
                ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#codigo").keydown(function (ev){
        return validarNum(ev)
    })

</script>
