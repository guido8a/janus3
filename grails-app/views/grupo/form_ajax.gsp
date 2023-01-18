<g:form class="form-horizontal" name="frmGrupo" action="saveGrupo_ajax">
    <g:hiddenField name="id" value="${grupoInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: grupoInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-3 control-label text-info">
                Código
            </label>
            <span class="col-md-2">
                <g:textField name="codigo" maxlength="3" class="form-control required number" value="${grupoInstance?.codigo}" readonly="${grupoInstance?.id ? true : false}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: grupoInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-3 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="31" class="form-control allCaps required" value="${grupoInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: grupoInstance, field: 'direccion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-3 control-label text-info">
                Dirección
            </label>
            <span class="col-md-8">
                <g:select name="direccion" from="${janus.Direccion.list()}" optionKey="id"  class="form-control required" value="${grupoInstance?.direccion?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    var validator = $("#frmGrupo").validate({
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
            submitFormGrupo();
            return false;
        }
        return true;
    });
</script>
