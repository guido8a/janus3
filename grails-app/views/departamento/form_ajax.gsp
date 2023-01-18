<g:form class="form-horizontal" name="frmDepartamento" action="saveDepartamento_ajax">
    <g:hiddenField name="id" value="${departamentoInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-3 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${departamentoInstance?.descripcion}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'direccion', 'error')} ">
        <span class="grupo">
            <label for="direccion" class="col-md-3 control-label text-info">
                Dirección
            </label>
            <span class="col-md-8">
                <g:select name="direccion" from="${janus.Direccion.list()}" optionKey="id" optionValue="nombre" class="form-control many-to-one required" value="${departamentoInstance?.direccion?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-3 control-label text-info">
                Código
            </label>
            <span class="col-md-4">
                <g:textField name="codigo" maxlength="6" class="form-control allCaps required" value="${departamentoInstance?.codigo}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'requirente', 'error')} ">
        <span class="grupo">
            <label for="requirente" class="col-md-3 control-label text-info">
                Es requirente de Obras?
            </label>
            <span class="col-md-4">
                <g:select name="requirente" from="${[1: 'SI', 0: 'NO']}" optionKey="key" optionValue="value"
                          class="form-control" value="${departamentoInstance?.requirente ?: 0}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    var validator = $("#frmDepartamento").validate({
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
            submitFormDepartamento();
            return false;
        }
        return true;
    });
</script>


