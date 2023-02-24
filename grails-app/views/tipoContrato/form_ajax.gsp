
<%@ page import="janus.pac.TipoContrato" %>

<div id="create-TipoContrato" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-TipoContrato" action="save">
    <g:hiddenField name="id" value="${tipoContratoInstance?.id}"/>
    <div class="form-group ${hasErrors(bean: tipoContratoInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-3">
                <g:textField name="codigo" maxlength="2" class="form-control allCaps required" value="${tipoContratoInstance?.codigo}" readonly="${tipoContratoInstance?.id ? true : false}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: tipoContratoInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="32" class="form-control required" value="${tipoContratoInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    $("#frmSave-TipoContrato").validate({
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
            submitFormTC();
            return false;
        }
        return true;
    });
</script>
