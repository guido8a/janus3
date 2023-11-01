
<%@ page import="janus.pac.TipoProcedimiento" %>

<div id="create-TipoProcedimiento" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-TipoProcedimiento" action="save">
        <g:hiddenField name="id" value="${tipoProcedimientoInstance?.id}"/>

        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-4 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textField name="descripcion" maxlength="63" class="form-control required" value="${tipoProcedimientoInstance?.descripcion}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'sigla', 'error')} ">
            <span class="grupo">
                <label for="sigla" class="col-md-4 control-label text-info">
                    Sigla
                </label>
                <span class="col-md-4">
                    <g:textField name="sigla" maxlength="5" class="form-control allCaps required" value="${tipoProcedimientoInstance?.sigla}" readonly="${tipoProcedimientoInstance?.id ? true : false}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'fuente', 'error')} ">
            <span class="grupo">
                <label  class="col-md-4 control-label text-info">
                    Fuente
                </label>
                <span class="col-md-4">
                    <g:select name="fuente" from="${['OF' : 'OF', 'OB' : 'OB']}" class="form-control" optionValue="value" optionKey="key" value="${tipoProcedimientoInstance?.fuente}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'bases', 'error')} ">
            <span class="grupo">
                <label for="bases" class="col-md-4 control-label text-info">
                    Bases
                </label>
                <span class="col-md-4">
                    <g:textField name="bases" class="form-control number required" value="${tipoProcedimientoInstance?.bases}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'preparatorio', 'error')} ">
            <span class="grupo">
                <label for="preparatorio" class="col-md-4 control-label text-info">
                    Período Preparatorio (d)
                </label>
                <span class="col-md-4">
                    <g:textField name="preparatorio" class="form-control number required" value="${tipoProcedimientoInstance?.preparatorio}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'precontractual', 'error')} ">
            <span class="grupo">
                <label for="precontractual" class="col-md-4 control-label text-info">
                    Período Precontractual (d)
                </label>
                <span class="col-md-4">
                    <g:textField name="precontractual" class="form-control number required" value="${tipoProcedimientoInstance?.precontractual}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'contractual', 'error')} ">
            <span class="grupo">
                <label for="contractual" class="col-md-4 control-label text-info">
                    Período Contractual (d)
                </label>
                <span class="col-md-4">
                    <g:textField name="contractual" class="form-control number required" value="${tipoProcedimientoInstance?.contractual}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'minimo', 'error')} ">
            <span class="grupo">
                <label for="minimo" class="col-md-4 control-label text-info">
                    Desde
                </label>
                <span class="col-md-4">
                    <g:textField name="minimo" class="form-control number required" value="${g.formatNumber(number: tipoProcedimientoInstance?.minimo, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2)}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: tipoProcedimientoInstance, field: 'techo', 'error')} ">
            <span class="grupo">
                <label for="techo" class="col-md-4 control-label text-info">
                    Techo
                </label>
                <span class="col-md-4">
                    <g:textField name="techo" class="form-control number required" value="${g.formatNumber(number: tipoProcedimientoInstance?.techo, format: "##,##0", locale: "ec", maxFractionDigits: 2, minFractionDigits: 2)}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>



    </g:form>

<script type="text/javascript">
    $("#frmSave-TipoProcedimiento").validate({
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
            submitFormTP();
            return false;
        }
        return true;
    });
</script>
