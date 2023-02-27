<%@ page import="janus.pac.UnidadIncop" %>

<div id="create-UnidadIncop" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-UnidadIncop" action="save">
        <g:hiddenField name="id" value="${unidadIncopInstance?.id}"/>
                
        <div class="form-group ${hasErrors(bean: unidadIncopInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-4">
                    <g:textField name="codigo" maxlength="7" class="form-control allCaps required" value="${unidadIncopInstance?.codigo}" readonly="${unidadIncopInstance?.id ? true : false}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: unidadIncopInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textField name="descripcion" maxlength="32" class="form-control required" value="${unidadIncopInstance?.descripcion}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:form>

<script type="text/javascript">
    $("#frmSave-UnidadIncop").validate({
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
            submitFormUnidad();
            return false;
        }
        return true;
    });
</script>
