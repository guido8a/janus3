<%@ page import="janus.SubgrupoItems" %>

<div id="create" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave" action="saveSg_ajax">
        <g:hiddenField name="id" value="${subgrupoItemsInstance?.id}"/>
        <g:hiddenField name="grupo" value="${grupo.id}"/>

        <div class="form-group">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Responsable
                </label>
                <span class="col-md-8">
                    ${grupo.descripcion}
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: subgrupoItemsInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-4">
                    <g:if test="${subgrupoItemsInstance?.id}">
                        <label>  ${subgrupoItemsInstance.codigo.toString()} </label>
                    </g:if>
                    <g:else>
                        <g:textField name="codigo" class="allCaps required form-control" value="${subgrupoItemsInstance?.codigo?.toString()}" maxlength="3"/>
                        <p class="help-block ui-helper-hidden"></p>
                    </g:else>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: grupo, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-8">
                    <g:textArea name="descripcion" style="resize: none" maxlength="63" class="allCaps required form-control" value="${subgrupoItemsInstance?.descripcion}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

    </g:form>
</div>

<script type="text/javascript">

    $("#frmSave").validate({
        rules          : {
            descripcion : {
                remote : {
                    url  : "${createLink(action:'checkDsSg_ajax')}",
                    type : "post",
                    data : {
                        id : "${subgrupoItemsInstance?.id}"
                    }
                }
            }
        },
        messages       : {
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
