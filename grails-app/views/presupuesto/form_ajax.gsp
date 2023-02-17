
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







%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Número--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textField name="numero" maxlength="50" style="width: 400px" class=" required"--}%
%{--                             value="${presupuestoInstance?.numero}"/>--}%
%{--                <span class="mandatory">*</span>--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Año--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:select name="anio.id" from="${janus.pac.Anio.list([sort: "anio"])}" style="width: 80px"--}%
%{--                          optionKey="id" optionValue="anio"></g:select>--}%
%{--                <span class="mandatory">*</span>--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Actividad--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textArea name="descripcion" cols="40" rows="3" maxlength="255" class=" required"--}%
%{--                            style="resize: none;width: 500px;" value="${presupuestoInstance?.descripcion}"/>--}%
%{--                <span class="mandatory">*</span>--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Fuente financiamiento--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:select name="fuente.id" from="${janus.FuenteFinanciamiento.list([sort: 'descripcion'])}" optionValue="descripcion" optionKey="id" value="${presupuestoInstance?.fuente?.id}"></g:select>--}%
%{--            <span class="mandatory">*</span>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%
%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Programa--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="programa"  maxlength="255" class=" required" style="resize: none;width: 300px;" value="${presupuestoInstance?.programa}"/>--}%
%{--            <span class="mandatory">*</span>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%
%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Subprograma--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="subPrograma" maxlength="255" class=" required" style="resize: none;width: 300px;" value="${presupuestoInstance?.subPrograma}"/>--}%
%{--            <span class="mandatory">*</span>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%
%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Proyecto--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="proyecto"  maxlength="255" class=" required" style="resize: none;width: 300px;" value="${presupuestoInstance?.proyecto}"/>--}%
%{--            <span class="mandatory">*</span>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%



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
