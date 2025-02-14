<style type="text/css">
.formato {
    font-weight : bold;
}

.dpto {
    font-size: smaller;
    font-style: italic;
}
input[readonly] {
    cursor: pointer !important;
    background-color: #ebebe5 !important;
}

</style>
<g:form name="frmSave-Planilla" action="savePagoPlanilla" id="${planilla.id}">
    <g:hiddenField name="tipo" value="${tipo}"/>
    <fieldset>


    <div class="form-group">
        <span class="grupo">
            <label class="col-md-12 control-label text-info">
                ${extra}
            </label>
        </span>
    </div>

    <g:if test="${tipo.toInteger() < 5}">

        <div class="col-md-12 form-group">
            <span class="grupo">
                <label  class="col-md-3 control-label text-info">
                    ${lblMemo}
                </label>
                <span class="col-md-5">
                    <g:textField name="memo" class="form-control required allCaps" maxlength="40" value="${planilla.memoPagoPlanilla}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:if>

    <div class="col-md-12 form-group">
        <span class="grupo">
            <label  class="col-md-3 control-label text-info">
                ${lblFecha}
            </label>
            <span class="col-md-5">
                <input aria-label="" name="fecha" id='fc' type='text' class="form-control required" value="${fecha?.format("dd-MM-yyyy")}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    ${raw(nombres)}

    </fieldset>
</g:form>

<script type="text/javascript">

    $('#fc').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        minDate: new Date(${fechaMin}),
        maxDate: new Date(${fechaMax}),
        icons: {
        }
    });

    $("#frmSave-Planilla").validate({
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