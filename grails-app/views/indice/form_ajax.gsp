
<%@ page import="janus.Indice" %>

<div id="create-Indice" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-Indice" action="save">
        <g:hiddenField name="id" value="${indiceInstance?.id}"/>

        <div class="form-group ${hasErrors(bean: indiceInstance, field: 'tipoIndice', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Tipo Índice
                </label>
                <span class="col-md-4">
                    <g:select id="tipoIndice" name="tipoIndice.id" from="${janus.TipoIndice.list()}" optionKey="id" optionValue="descripcion" class="form-control" value="${indiceInstance?.tipoIndice?.id}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: indiceInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-4">
                    <g:textField name="codigo" maxlength="20" class="form-control required" value="${indiceInstance?.codigo}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: indiceInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-10">
                    <g:textField name="descripcion" maxlength="131" class="form-control required" value="${indiceInstance?.descripcion}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
                
    </g:form>

<script type="text/javascript">
    $("#frmSave-Indice").validate({
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
            submitFormIndice();
            return false;
        }
        return true;
    });
</script>
