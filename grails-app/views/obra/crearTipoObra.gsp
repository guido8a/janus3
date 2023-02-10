<%@ page import="janus.TipoObra" %>

<div id="create-TipoObra" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-TipoObra" controller="tipoObra" action="saveTipoObra">
    <g:hiddenField name="id" value="${tipoObraInstance?.id}"/>
    <g:hiddenField name="grupo" value="${grupo}"/>

    <div class="form-group">
        <span class="grupo">
            <label for="codigo" class="col-md-3 control-label text-info">
                Código
            </label>
            <span class="col-md-6">
                <g:textField name="codigo" maxlength="4" class="form-control allCaps required" value="${tipoObraInstance?.codigo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group">
        <span class="grupo">
            <label for="descripcion" class="col-md-3 control-label text-info">
                Descripción
            </label>
            <span class="col-md-6">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${tipoObraInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group">
        <span class="grupo">
            <label for="grupo" class="col-md-3 control-label text-info">
                Grupo
            </label>
            <span class="col-md-6">
                <g:select id="grupo" name="grupo.id" class="form-control" from="${janus.Grupo.list()}" optionKey="id" optionValue="descripcion" value="${tipoObraInstance?.grupo?.id}"/>
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
        },
        rules: {
            codigo: {

                remote : {
                    url  : "${createLink(controller: 'tipoObra' ,action:'checkCodigo')}",
                    type : "post"
                }
            },
            descripcion: {

                remote : {
                    url  : "${createLink(controller: 'tipoObra' ,action:'checkDesc')}",
                    type : "post"
                }
            }
        },
        messages       : {
            codigo      : {
                remote : "El código ya se ha ingresado para otro item"
            },
            descripcion : {
                remote : "La descripción ya se ha ingresado para otro item"
            }
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
