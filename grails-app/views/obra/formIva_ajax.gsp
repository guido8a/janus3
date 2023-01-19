<g:form class="form-horizontal" name="frmIva" action="guardarIva_ajax">
    <div class="form-group">
        <span class="grupo">
            <label for="iva_name" class="col-md-2 control-label text-info">
                IVA
            </label>
            <span class="col-md-4">
                <g:textField name="iva_name" maxlength="2" class="form-control number required" value="${janus.Parametros.first().iva}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">
    var validator = $("#frmIva").validate({
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
</script>