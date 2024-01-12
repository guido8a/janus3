<style type="text/css">
.formato {
    font-weight : bold;
}

.dpto {
    font-size  : smaller;
    font-style : italic;
}
</style>
<g:form name="frmSave-Planilla" action="iniciarObra" id="${cntr}">
    <g:hiddenField name="tipo" value="${tipo}"/>
    <fieldset>
        <div class="row">
            <div class="col-md-5">
                ${extra}
            </div>
        </div>

        <div class="row">
            <div class="col-md-2 formato">
                ${lblMemo}
            </div>

            <div class="col-md-4">
                <g:textField name="memo" class="span3 required allCaps" maxlength="20"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-2 formato">
                ${lblFecha}
            </div>

            <div class="col-md-4">
                <elm:datepicker name="fecha" class=" span3 required" maxDate="${fechaMax}" minDate="${fechaMin}" value="${fecha}"/>
                %{--<elm:datepicker name="fecha" class=" span3 required"/>--}%
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="alert alert-danger" style="font-size: large;">
            <strong>
                Los datos ingresados para la impresión del oficio son definitivos. Una vez guardados no podrán ser modificados.
            </strong>
        </div>
    </fieldset>
    <input type="submit" value="Iniciar Obra">
</g:form>

<script type="text/javascript">
    $("#frmSave-Planilla").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important",
        submitHandler  : function (form) {
            $("[name=btnSave-rubroInstance]").replaceWith(spinner);
            form.submit();
        }
    });
</script>