<%@ page import="janus.ClaseObra" %>

<div id="create-claseObraInstance" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-claseObraInstance" action="save_ext">
    <g:hiddenField name="id" value="${claseObraInstance?.id}"/>
    <g:hiddenField name="grupo" value="${grupo}"/>

%{--    <div class="form-group">--}%
%{--        <span class="grupo">--}%
%{--            <label for="codigo" class="col-md-3 control-label text-info">--}%
%{--                Código--}%
%{--            </label>--}%
%{--            <span class="col-md-2">--}%
%{--                <g:textField name="codigo" maxlength="3" class="form-control allCaps required number" value="${claseObraInstance?.codigo ?: ''}" readonly="${claseObraInstance?.id ? true : false}"/>--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </span>--}%
%{--        </span>--}%
%{--    </div>--}%

    <div class="form-group">
        <span class="grupo">
            <label for="descripcion" class="col-md-3 control-label text-info">
                Descripción
            </label>
            <span class="col-md-6">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${claseObraInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label for="grupo" class="col-md-3 control-label text-info">
                Grupo
            </label>
            <span class="col-md-6">
                <g:select id="grupo" name="grupo" class="form-control" from="${janus.Grupo.list()}" optionKey="id" optionValue="descripcion" value="${programacionInstance?.grupo?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Código--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <g:if test="${claseObraInstance?.id}">--}%

%{--            <div class="controls">--}%
%{--                <g:textField name="codigo" readonly="readonly" class=" required allCaps" value="${fieldValue(bean: claseObraInstance, field: 'codigo')}"/>--}%
%{--                <span class="mandatory">*</span>--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%

%{--        </g:if>--}%
%{--        <g:else>--}%
%{--            <div class="controls">--}%
%{--                <g:textField name="codigo"  id="codigo1" class=" required allCaps" value=""/>--}%
%{--                <span class="mandatory">*</span>--}%

%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </g:else>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Descripción--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="descripcion" maxlength="63" class=" required" value="${claseObraInstance?.descripcion}"/>--}%
%{--            <span class="mandatory">*</span>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Grupo--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:select id="grupo" name="grupo.id" from="${janus.Grupo.list()}" optionKey="id" class="many-to-one "--}%
%{--                      value="${claseObraInstance?.grupo?.id}"/>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

</g:form>

<script type="text/javascript">

    var validator = $("#frmSave-claseObraInstance").validate({
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
            submitFormClase();
            return false;
        }
        return true;
    });

    //
    // function validarNum(ev) {
    //     /*
    //      48-57      -> numeros
    //      96-105     -> teclado numerico
    //      188        -> , (coma)
    //      190        -> . (punto) teclado
    //      110        -> . (punto) teclado numerico
    //      8          -> backspace
    //      46         -> delete
    //      9          -> tab
    //      37         -> flecha izq
    //      39         -> flecha der
    //      */
    //     return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
    //             (ev.keyCode >= 96 && ev.keyCode <= 105) ||
    //             ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
    //             ev.keyCode == 37 || ev.keyCode == 39);
    // }
    //
    //
    // $("#codigo").keydown(function (ev){
    //     return validarNum(ev)
    // })

</script>
