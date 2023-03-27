<%@ page import="janus.DepartamentoItem" %>

<div id="create" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave" action="saveDp_ajax">
        <g:hiddenField name="id" value="${departamentoItemInstance?.id}"/>
        <g:hiddenField name="subgrupo" value="${subgrupo.id}"/>

        <div class="form-group">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Grupo
                </label>
                <span class="col-md-8">
                    ${subgrupo.descripcion}
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-2">
                    <g:set var="cd1" value="${subgrupo.codigo.toString().padLeft(3, '0')}"/>
                    <g:if test="${departamentoItemInstance.id}">
                        <g:if test="${subgrupo.id != 21}">
                            ${cd1}.</g:if>${departamentoItemInstance?.codigo?.toString()?.padLeft(3, '0')}
                    </g:if>
                    <g:else>
                        <g:if test="${subgrupo.id != 21}">
                            <div class="input-prepend">
                                <span class="add-on">${cd1}</span>
                                <g:textField name="codigo" class="allCaps required form-control" value="${departamentoItemInstance?.codigo?.toString()}" maxlength="3"/>
                                <p class="help-block ui-helper-hidden"></p>
                            </div>
                        </g:if>
                        <g:else>
                            <g:textField name="codigo" class="allCaps required form-control" value="${departamentoItemInstance.codigo.toString()}" maxlength="3"/>
                            <p class="help-block ui-helper-hidden"></p>
                        </g:else>
                    </g:else>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: departamentoItemInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textArea name="descripcion" style="resize: none" maxlength="50" class="allCaps required form-control" value="${departamentoItemInstance?.descripcion}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

    </g:form>
</div>
<script type="text/javascript">


    $("#frmSave").validate({
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
                remote : "El código ya se ha ingresado para otro item"
            },
            descripcion : {
                remote : "La descripción ya se ha ingresado para otro item"
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
