<%@ page import="janus.TipoObra" %>

<div id="create-TipoObra" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-TipoObra" action="save">
    <g:hiddenField name="id" value="${tipoObraInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: tipoObraInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-2">
                <g:textField name="codigo" maxlength="4" class="form-control allCaps required" value="${tipoObraInstance?.codigo}" readonly="${tipoObraInstance?.id ? true : false}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: tipoObraInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${tipoObraInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: tipoObraInstance, field: 'grupo', 'error')} ">
        <span class="grupo">
            <label for="tipo" class="col-md-2 control-label text-info">
                Tipo
            </label>
            <span class="col-md-4">
                <g:select name="tipo" from="${janus.Grupo.list()}"  optionValue="descripcion" optionKey="id"  class="form-control required" value="${tipoObraInstance?.grupo?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    $("#frmSave-TipoObra").validate({
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
            submitFormTipoObra();
            return false;
        }
        return true;
    });
</script>
