
<%@ page import="janus.ejecucion.TipoPlanilla" %>

<div id="create-TipoPlanilla" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-TipoPlanilla" action="save">
        <g:hiddenField name="id" value="${tipoPlanillaInstance?.id}"/>

        <div class="form-group ${hasErrors(bean: tipoPlanillaInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-8">
                    <g:textField name="codigo" maxlength="1" class="form-control allCaps required" value="${tipoPlanillaInstance?.codigo}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: tipoPlanillaInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textField name="nombre" maxlength="63" class="form-control required" value="${tipoPlanillaInstance?.nombre}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:form>

<script type="text/javascript">
    $("#frmSave-TipoPlanilla").validate({
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
            submitFormTP();
            return false;
        }
        return true;
    });
</script>
