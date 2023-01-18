<g:form class="form-horizontal" name="frmTipoTramite" action="saveTipoTramite_ajax">
    <g:hiddenField name="id" value="${tipoTramiteInstance?.id}"/>

    <div class="form-group ${hasErrors(bean: tipoTramiteInstance, field: 'codigo', 'error')} ">
        <span class="grupo">
            <label for="codigo" class="col-md-2 control-label text-info">
                Código
            </label>
            <span class="col-md-2">
                <g:textField name="codigo" maxlength="4" minlength="4" class="form-control allCaps required" value="${tipoTramiteInstance?.codigo}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: tipoTramiteInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${tipoTramiteInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: tipoTramiteInstance, field: 'padre', 'error')} ">
        <span class="grupo">
            <label for="padre" class="col-md-2 control-label text-info">
                Padre
            </label>
            <span class="col-md-8">
                <g:select name="padre" from="${janus.TipoTramite.list()}" optionKey="id" optionValue="descripcion" class="many-to-one form-control" value="${tipoTramiteInstance?.padre?.id}" noSelection="['null': '']"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: tipoTramiteInstance, field: 'tiempo', 'error')} ">
        <span class="grupo">
            <label for="tiempo" class="col-md-2 control-label text-info">
                Tiempo
            </label>
            <span class="col-md-3">
                <g:textField name="tiempo" maxlength="4" class="form-control number required" value="${tipoTramiteInstance?.tiempo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: tipoTramiteInstance, field: 'tipo', 'error')} ">
        <span class="grupo">
            <label for="tipo" class="col-md-2 control-label text-info">
                Tipo
            </label>
            <span class="col-md-3">
                <g:select name="tipo" from="${['O' : 'Obra', 'C': 'Contrato', 'P' : 'Planilla']}"  optionValue="value" optionKey="key"  class="form-control required" value="${tipoTramiteInstance?.tipo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
    <div class="form-group ${hasErrors(bean: tipoTramiteInstance, field: 'requiereRespuesta', 'error')} ">
        <span class="grupo">
            <label for="requiereRespuesta" class="col-md-2 control-label text-info">
                Requiere respuesta
            </label>
            <span class="col-md-3">
                <g:select name="requiereRespuesta" from="${['S' : 'SI', 'N' : 'NO']}" optionValue="value" optionKey="key" class="form-control required" value="${tipoTramiteInstance?.requiereRespuesta}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>
</g:form>


<script type="text/javascript">

    var validator = $("#frmTipoTramite").validate({
        rules          : {
            codigo : {
                remote : {
                    url  : "${createLink(action:'checkCd_ajax')}",
                    type : "POST",
                    data : {
                        id : "${tipoTramiteInstance?.id}"
                    }
                }
            }
        },
        messages       : {
            codigo : {
                remote : "El código ya se ha ingresado para otro tipo de trámite"
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

    $(".form-control").keydown(function (ev) {
        if (ev.keyCode === 13) {
            submitFormUnidad();
            return false;
        }
        return true;
    });
</script>
