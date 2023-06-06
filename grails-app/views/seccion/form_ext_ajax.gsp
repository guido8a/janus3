<%@ page import="janus.actas.Seccion" %>

<div id="create-Seccion" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave" action="save_ext">
        <g:hiddenField name="id" value="${seccionInstance?.id}"/>
        <g:hiddenField name="acta.id" value="${seccionInstance?.actaId}"/>
        <g:hiddenField name="numero" value="${seccionInstance?.numero}"/>


        <div class="form-group">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Número
                </label>
                <span class="col-md-8">
                    ${fieldValue(bean: seccionInstance, field: 'numero')}
                </span>
            </span>
        </div>


        <div class="form-group ${hasErrors(bean: seccionInstance, field: 'titulo', 'error')} ">
            <span class="grupo">
                <label for="titulo" class="col-md-2 control-label text-info">
                    Título
                </label>
                <span class="col-md-8">
                    <g:textField name="titulo" maxlength="511" class="inputSeccion required form-control" value="${seccionInstance?.titulo}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:form>
</div>
<script type="text/javascript">

    $("#frmSave").validate({
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
            submitFormSeccion();
            return false;
        }
        return true;
    });

</script>
