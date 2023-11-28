
<%@ page import="janus.pac.CodigoComprasPublicas" %>

<div id="create-CodigoComprasPublicas" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-CodigoComprasPublicas" action="save">
        <g:hiddenField name="id" value="${codigoComprasPublicasInstance?.id}"/>


        <div class="form-group ${hasErrors(bean: codigoComprasPublicasInstance, field: 'numero', 'error')} ">
            <span class="grupo">
                <label for="numero" class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-3">
                    <g:textField name="numero" maxlength="32"  class="form-control required" value="${codigoComprasPublicasInstance?.numero}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: codigoComprasPublicasInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-10">
                    <g:textArea name="descripcion" maxlength="512"  class="form-control required" style="resize: none; height: 100px" value="${codigoComprasPublicasInstance?.descripcion}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: codigoComprasPublicasInstance, field: 'fecha', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Fecha
                </label>
                <span class="col-md-4">
                    <input aria-label="" name="fecha" id='fecha' type='text' class="form-control" value="${codigoComprasPublicasInstance?.fecha?.format("dd-MM-yyyy") ?: new java.util.Date().format("dd-MM-yyyy")}" />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

    </g:form>

<script type="text/javascript">

    $('#fecha').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });


    $("#frmSave-CodigoComprasPublicas").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important",
        submitHandler  : function(form) {
            $(".btn-success").replaceWith(spinner);
            form.submit();
        }
    });

</script>
