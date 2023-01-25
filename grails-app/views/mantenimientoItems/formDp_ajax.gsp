<%@ page import="janus.DepartamentoItem" %>

<g:form class="form-horizontal" name="frmSave" action="saveDp_ajax">
    <g:hiddenField name="id" value="${departamentoItemInstance?.id}"/>
    <g:hiddenField name="subgrupo" value="${subgrupo.id}"/>

    <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'grupo', 'error')} ">
        <span class="grupo">
            <label for="subgrupoName" class="col-md-2 control-label text-info">
                Subgrupo
            </label>
            <span class="col-md-8">
                <g:textField name="subgrupoName" class="form-control" value="${subgrupo?.descripcion}" readonly="" />
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-2">
                <g:textField name="codigoSubgrupo" class="form-control" value="${subgrupo?.codigo ?: ''}" readonly=""/>
            </span>
            <span class="col-md-2">
                <g:textField name="codigo" maxlength="3" minlength="3" class="form-control allCaps number required" value="${departamentoItemInstance?.codigo ?: ''}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${departamentoItemInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <g:if test="${subgrupo?.grupo?.codigo?.toInteger() != 1}">
        <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'transporte', 'error')} ">
            <span class="grupo">
                <label for="transporte" class="col-md-2 control-label text-info">
                    Grupo asociado a transporte
                </label>
                <span class="col-md-8">
                    <g:select name="transporte" from="${janus.Transporte.list()}" optionValue="descripcion" optionKey="id" class="form-control" value="${departamentoItemInstance?.transporte?.id}" noSelection="['null': '']"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
    </g:if>
</g:form>

%{--<div id="create" class="span" role="main">--}%
%{--    <g:form class="form-horizontal" name="frmSave" action="saveDp_ajax">--}%
%{--        <g:hiddenField name="id" value="${departamentoItemInstance?.id}"/>--}%

%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Subgrupo--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                ${subgrupo.descripcion}--}%
%{--                <g:hiddenField name="subgrupo.id" value="${subgrupo.id}"/>--}%

%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Código--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:set var="cd1" value="${subgrupo.codigo.toString().padLeft(3, '0')}"/>--}%
%{--                <g:if test="${departamentoItemInstance.id}">--}%
%{--                    <g:if test="${!mos.contains(subgrupo.id)}">--}%
%{--                        ${cd1}.</g:if>${departamentoItemInstance?.codigo?.toString()?.padLeft(3, '0')}--}%
%{--                </g:if>--}%
%{--                <g:else>--}%
%{--                    <g:if test="${!mos.contains(subgrupo.id)}">--}%
%{--                        <div class="input-prepend">--}%
%{--                            <span class="add-on">${cd1}</span>--}%
%{--                            <g:textField name="codigo" class="allCaps required input-small" maxlength="3" value="${departamentoItemInstance.id ? departamentoItemInstance?.codigo?.toString()?.padLeft(3, '0') : ''}"/>--}%
%{--                            <span class="mandatory">*</span>--}%

%{--                            <p class="help-block ui-helper-hidden"></p>--}%
%{--                        </div>--}%
%{--                    </g:if>--}%
%{--                    <g:else>--}%
%{--                        <g:textField name="codigo" class="allCaps required input-small" maxlength="3" value="${departamentoItemInstance.id ? departamentoItemInstance.codigo.toString().padLeft(3, '0') : ''}"/>--}%
%{--                        <span class="mandatory">*</span>--}%

%{--                        <p class="help-block ui-helper-hidden"></p>--}%
%{--                    </g:else>--}%
%{--                </g:else>--}%
%{--            </div>--}%
%{--        </div>--}%


%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Descripción--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textArea cols="5" rows="3" name="descripcion" style="resize: none; height: 50px" maxlength="63" class="allCaps required input-xxlarge" value="${departamentoItemInstance?.descripcion}"/>--}%
%{--                <span class="mandatory">*</span>--}%

%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <g:if test="${subgrupo?.grupo?.codigo?.toInteger() != 1}">--}%
%{--            <div class="control-group">--}%
%{--                <div>--}%
%{--                    <span class="control-label label label-inverse">--}%
%{--                        Grupo asociado a transporte--}%
%{--                    </span>--}%
%{--                </div>--}%

%{--                <div class="controls">--}%
%{--                    <g:select id="transporte" name="transporte.id" from="${janus.Transporte.list()}" optionKey="id" optionValue="descripcion"--}%
%{--                              class="many-to-one " value="${departamentoItemInstance?.transporte?.id}" noSelection="['null': '']"/>--}%

%{--                    <p class="help-block ui-helper-hidden"></p>--}%
%{--                </div>--}%
%{--            </div>--}%
%{--        </g:if>--}%
%{--    </g:form>--}%
%{--</div>--}%
<script type="text/javascript">

    function validarNumDec(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
            ev.keyCode == 37 || ev.keyCode == 39);
    }

    $("#codigo").keydown(function (ev) {
        return validarNumDec(ev)
    });

    var validator = $("#frmSave").validate({
        rules          : {
            codigo      : {
                remote : {
                    url  : "${createLink(action:'checkCdDp_ajax')}",
                    type : "post",
                    data : {
                        id : "${departamentoItemInstance?.id}",
                        sg : "${subgrupo.id}"
                    }
                }
            },
            descripcion : {
                remote : {
                    url  : "${createLink(action:'checkDsDp_ajax')}",
                    type : "post",
                    data : {
                        id : "${departamentoItemInstance?.id}"
                    }
                }
            }
        },
        messages       : {
            codigo      : {
                remote : "El código se encuentra duplicado"
            },
            descripcion : {
                remote : "La descripción ya fue ingresada"
            }
        },
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
