<%@ page import="janus.Programacion" %>

<g:form class="form-horizontal" name="frmSave-Programacion" action="guardarCantidad_ajax">
    <g:hiddenField name="id" value="${volumen?.id}"/>

    <div class="form-group">
        <span class="grupo">
            <label for="cantidad" class="col-md-3 control-label text-info">
                Cantidad Actual
            </label>
            <span class="col-md-4">
                <g:textField name="cantidad" class="form-control" value="${cantidad}"  readonly="${true}"/>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: volumen, field: 'cantidadComplementaria', 'error')} ">
        <span class="grupo">
            <label for="volumenCantidad" class="col-md-3 control-label text-info">
                Cantidad a modificar
            </label>
            <span class="col-md-4">
                <g:textField name="volumenCantidad" maxlength="10" class="form-control number required" value="${volumen?.cantidadComplementaria}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    $("#frmSave-Programacion").validate({
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
            submitFormModificarCantidad();
            return false;
        }
        return true;
    });
</script>
