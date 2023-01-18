<g:form class="form-horizontal" name="frmDireccion" action="saveDireccion_ajax">
    <g:hiddenField name="id" value="${direccionInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: direccionInstance, field: 'nombre', 'error')} ">
        <span class="grupo">
            <label for="nombre" class="col-md-3 control-label text-info">
                Nombre
            </label>
            <span class="col-md-6">
                <g:textField name="nombre" maxlength="63" class="form-control allCaps required" value="${direccionInstance?.nombre}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: direccionInstance, field: 'jefatura', 'error')} ">
        <span class="grupo">
            <label for="jefatura" class="col-md-3 control-label text-info">
                Jefatura
            </label>
            <span class="col-md-6">
                <g:textField name="jefatura" maxlength="63" class="form-control allCaps required" value="${direccionInstance?.jefatura}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    var validator = $("#frmDireccion").validate({
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
            submitFormDireccion();
            return false;
        }
        return true;
    });
</script>
