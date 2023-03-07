
<%@ page import="janus.Presupuesto" %>

<div id="create-presupuestoInstance" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-presupuestoInstance" action="saveAjax">
    <g:hiddenField name="id" value="${presupuestoInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: presupuestoInstance, field: 'numero', 'error')} ">
        <span class="grupo">
            <label for="numero" class="col-md-2 control-label text-info">
                Número
            </label>
            <span class="col-md-8">
                <g:textField name="numero" maxlength="50" class="form-control required" value="${presupuestoInstance?.numero}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: presupuestoInstance, field: 'anio', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Año
            </label>
            <span class="col-md-4">
                <g:select name="anio.id" from="${janus.pac.Anio.list([sort: "anio"])}" optionKey="id" optionValue="anio" class="form-control required" value="${presupuestoInstance?.anio?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: presupuestoInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Actividad
            </label>
            <span class="col-md-8">
                <g:textArea name="descripcion" maxlength="255" style="resize: none" class="form-control required" value="${presupuestoInstance?.descripcion}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: presupuestoInstance, field: 'fuente', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Fuente de financiamiento
            </label>
            <span class="col-md-4">
                <g:select name="fuente.id" class="form-control" from="${janus.FuenteFinanciamiento.list([sort: 'descripcion'])}" optionValue="descripcion" optionKey="id" value="${presupuestoInstance?.fuente?.id}"/>                    <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: presupuestoInstance, field: 'programa', 'error')} ">
        <span class="grupo">
            <label for="programa" class="col-md-2 control-label text-info">
                Programa
            </label>
            <span class="col-md-8">
                <g:textField name="programa" maxlength="255" class="form-control required" value="${presupuestoInstance?.programa}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: presupuestoInstance, field: 'subPrograma', 'error')} ">
        <span class="grupo">
            <label for="subPrograma" class="col-md-2 control-label text-info">
                SubPrograma
            </label>
            <span class="col-md-8">
                <g:textField name="subPrograma" maxlength="255" class="form-control required" value="${presupuestoInstance?.subPrograma}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: presupuestoInstance, field: 'proyecto', 'error')} ">
        <span class="grupo">
            <label for="proyecto" class="col-md-2 control-label text-info">
                Proyecto
            </label>
            <span class="col-md-8">
                <g:textField name="proyecto" maxlength="255" class="form-control required" value="${presupuestoInstance?.proyecto}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

</g:form>

<script type="text/javascript">

    var validator = $("#frmSave-presupuestoInstance").validate({
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
            submitFormPresupuesto();
            return false;
        }
        return true;
    });
</script>
