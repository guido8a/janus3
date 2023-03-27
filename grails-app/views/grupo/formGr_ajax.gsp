<%@ page import="janus.SubgrupoItems" %>

<div id="create" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave" action="saveGr_ajax">
        <g:hiddenField name="id" value="${grupo?.id}"/>


        <div class="form-group ${hasErrors(bean: grupo, field: 'direccion', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Dirección
                </label>
                <span class="col-md-8">
                    <g:select name="direccion" from="${janus.Direccion.list()}" optionKey="id" optionValue="nombre" class="form-control" value="${grupo?.direccion?.id}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: grupo, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Código
                </label>
                <span class="col-md-4">
                    <g:if test="${grupo?.id}">
                       <label> ${grupo?.codigo?.toString()} </label>
                    </g:if>
                    <g:else>
                        <g:textField name="codigo" class="allCaps required input-small" value="${grupo?.codigo?.toString()}" maxlength="3"/>
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
                    <g:textField name="descripcion" maxlength="31" class="allCaps required form-control" value="${grupo?.descripcion}"/>
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
                    url  : "${createLink(action:'checkGr_ajax')}",
                    type : "post",
                    data : {
                        id : "${grupo?.id}"
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
