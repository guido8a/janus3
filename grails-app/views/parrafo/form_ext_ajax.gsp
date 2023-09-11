<%@ page import="janus.actas.Parrafo" %>

<div id="create-Parrafo" class="span" role="main">
<g:form class="form-horizontal" name="frmSave" action="save_ext">
    <g:hiddenField name="id" value="${parrafoInstance?.id}"/>
    <g:hiddenField id="seccion" name="seccion.id" value="${parrafoInstance?.seccion?.id}"/>
    <g:hiddenField name="numero" value="${fieldValue(bean: parrafoInstance, field: 'numero')}"/>

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Sección
            </label>
            <span class="col-md-8">
                <elm:poneHtml textoHtml="${parrafoInstance?.seccion?.titulo ?: ''}" />
            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Número
            </label>
            <span class="col-md-8">
                ${parrafoInstance.seccion.numero}.${fieldValue(bean: parrafoInstance, field: 'numero')}
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: parrafoInstance, field: 'tipoTabla', 'error')} ">
        <span class="grupo">
            <label for="tipoTabla" class="col-md-2 control-label text-info">
                Tipo Tabla
            </label>
            <span class="col-md-8">
                <g:select name="tipoTabla" from="${["", "RBR", "DTP", "OAD", "OCP", "RRP", "RGV", "DTA", "DTS", "RPR"]}" class="form-control" value="${parrafoInstance?.tipoTabla}" valueMessagePrefix="parrafo.tipoTabla"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Sección--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--           <elm:poneHtml textoHtml="${parrafoInstance.seccion.titulo}"/>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Número--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            ${parrafoInstance.seccion.numero}.${fieldValue(bean: parrafoInstance, field: 'numero')}--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Tipo Tabla--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:select name="tipoTabla" from="${parrafoInstance.constraints.tipoTabla.inList}" class="" value="${parrafoInstance?.tipoTabla}" valueMessagePrefix="parrafo.tipoTabla" noSelection="['': '']"/>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

</g:form>

<script type="text/javascript">

    $("#frmSave").validate({
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
