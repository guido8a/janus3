
<%@ page import="janus.FuenteFinanciamiento" %>

<div id="create-FuenteFinanciamiento" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-FuenteFinanciamiento" action="save">
        <g:hiddenField name="id" value="${fuenteFinanciamientoInstance?.id}"/>


        <div class="form-group ${hasErrors(bean: fuenteFinanciamientoInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textField name="descripcion" maxlength="100" class="form-control allCaps required" value="${fuenteFinanciamientoInstance?.descripcion}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
                
    </g:form>

<script type="text/javascript">
    $("#frmSave-FuenteFinanciamiento").validate({
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
            submitFormFF();
            return false;
        }
        return true;
    });
</script>
