<%@ page import="janus.Lugar" %>

<div id="create" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave" action="saveLg_ajax">
        <g:hiddenField name="id" value="${lugarInstance?.id}"/>
        <g:hiddenField name="all" value="${all}"/>

        <div class="form-group ${hasErrors(bean: lugarInstance, field: 'tipoLista', 'error')} ">
            <span class="grupo">
                <label for="tipoLista.id" class="col-md-2 control-label text-info">
                    Tipo
                </label>
                <span class="col-md-8">
                    <g:select name="tipoLista.id" id="tipoListaId" class="form-control" from="${janus.TipoLista.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" value="${lugarInstance?.tipoLista?.id}" />
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: lugarInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-3">
                    <g:if test="${id}">
                        <g:textField name="codigo" class="form-control required" readonly="true" value="${lugarInstance?.codigo}"/>
                    </g:if>
                    <g:else>
                        <g:textField name="codigo" class="form-control required" readonly="true" value="${ultimo+1}"/>
                    </g:else>

                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: lugarInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-3">
                    <g:textField name="descripcion" maxlength="40" class="form-control required" value="${lugarInstance?.descripcion}"/>
                </span>
            </span>
        </div>

%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Tipo--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:select name="tipoLista.id" id="tipoListaId" from="${janus.TipoLista.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" value="${lugarInstance?.tipoLista?.id}" />--}%
%{--                <span class="mandatory">*</span>--}%

%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%



%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Código--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:field type="number" name="codigo" class="allCaps required input-small" readonly="true" value="${ultimo+1}"/>--}%
%{--                <span class="mandatory">*</span>--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Descripcion--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textField name="descripcion" maxlength="40" class="allCaps required" value="${lugarInstance?.descripcion}"/>--}%
%{--                <span class="mandatory">*</span>--}%

%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%

    </g:form>
</div>

<script type="text/javascript">
    //    $(".allCaps").keyup(function () {
    //        this.value = this.value.toUpperCase();
    //    });

    $("#frmSave").validate({
        rules          : {
            codigo      : {
                remote : {
                    url  : "${createLink(action:'checkCdLg_ajax')}",
                    type : "post",
                    data : {
                        id : "${lugarInstance?.id}"
                    }
                }
            },
            descripcion : {
                remote : {
                    url  : "${createLink(action:'checkDsLg_ajax')}",
                    type : "post",
                    data : {
                        id : "${lugarInstance?.id}"
                    }
                }
            }
        },
        messages       : {
            codigo      : {
                remote : "El código ya se ha ingresado para otro lugar"
            },
            descripcion : {
                remote : "La descripción ya se ha ingresado para otro lugar"
            }
        },
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important"
    });

</script>
