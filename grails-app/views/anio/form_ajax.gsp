
<%@ page import="janus.pac.Anio" %>

<div id="create-Anio" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-Anio" action="save">
        <g:hiddenField name="id" value="${anioInstance?.id}"/>
        <div class="form-group ${hasErrors(bean: anioInstance, field: 'anio', 'error')} ">
            <span class="grupo">
                <label for="anio" class="col-md-2 control-label text-info">
                    Año
                </label>
                <span class="col-md-7">
                    <g:textField name="anio" maxlength="4" minlength="4" class="form-control number required" value="${anioInstance?.anio}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:form>

<script type="text/javascript">
    $("#frmSave-Anio").validate({
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
            submitFormAnio();
            return false;
        }
        return true;
    });
</script>
