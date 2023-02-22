
<%@ page import="janus.EstadoObra" %>

<div id="create-estadoObraInstance" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-estadoObraInstance" action="save">
    <g:hiddenField name="id" value="${estadoObraInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: estadoObraInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-2">
                <g:textField name="codigo" maxlength="1" class="form-control allCaps required" value="${estadoObraInstance?.codigo}" readonly="${estadoObraInstance?.id ? true : false}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: estadoObraInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="31" class="form-control allCaps required" value="${estadoObraInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    $("#frmSave-estadoObraInstance").validate({
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
            submitFormEstadoObra();
            return false;
        }
        return true;
    });
</script>
