<%@ page import="janus.ClaseObra" %>

<div id="create-ClaseObra" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-ClaseObra" action="save">
    <g:hiddenField name="id" value="${claseObraInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: claseObraInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${claseObraInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: claseObraInstance, field: 'grupo', 'error')} ">
        <span class="grupo">
            <label for="grupo" class="col-md-2 control-label text-info">
                Grupo
            </label>
            <span class="col-md-4">
                <g:select name="grupo" from="${janus.Grupo.list()}"  optionValue="descripcion" optionKey="id"  class="form-control required" value="${claseObraInstance?.grupo?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">
    $("#frmSave-ClaseObra").validate({
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
            submitFormClaseObra();
            return false;
        }
        return true;
    });
</script>
