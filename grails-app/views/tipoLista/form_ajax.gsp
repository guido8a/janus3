

<%@ page import="janus.TipoLista" %>

<div id="create-TipoLista" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-TipoLista" action="save">
    <g:hiddenField name="id" value="${tipoListaInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: tipoListaInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-8">
                <g:textField name="codigo" maxlength="63" class="form-control allCaps required" value="${tipoListaInstance?.codigo}" readonly="${tipoListaInstance?.id ? true : false}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: tipoListaInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="63" class="form-control required" value="${tipoListaInstance?.descripcion}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: tipoListaInstance, field: 'unidad', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Unidad
            </label>
            <span class="col-md-8">
                <g:select name="unidad" class="form-control" from="${['Ton', 'm3']}" noSelection="${["no" : 'Sin unidad']}" value="${tipoListaInstance?.unidad}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    $("#frmSave-TipoLista").validate({
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
            submitFormTL();
            return false;
        }
        return true;
    });
</script>
