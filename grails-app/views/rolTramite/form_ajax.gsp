<g:form class="form-horizontal" name="frmRolTramite" action="saveRolTramite_ajax">
    <g:hiddenField name="id" value="${rolTramiteInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: rolTramiteInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-3 control-label text-info">
                Código
            </label>
            <span class="col-md-2">
                <g:textField name="codigo" maxlength="4" class="form-control allCaps required" value="${rolTramiteInstance?.codigo}" readonly="${rolTramiteInstance?.id ? true : false}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: rolTramiteInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-3 control-label text-info">
                Descripción
            </label>
            <span class="col-md-6">
                <g:textField name="descripcion" maxlength="63" class="form-control required" value="${rolTramiteInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    var validator = $("#frmRolTramite").validate({
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
            submitFormRolTramite();
            return false;
        }
        return true;
    });
</script>
