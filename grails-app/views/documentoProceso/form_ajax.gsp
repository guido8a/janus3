<%@ page import="janus.pac.DocumentoProceso" %>

<div id="create-DocumentoProceso" class="span" role="main">
    <g:uploadForm class="form-horizontal" method="post" name="frmSave-DocumentoProceso" action="save">
        <g:hiddenField name="id" value="${documentoProcesoInstance?.id}"/>
        <g:hiddenField name="concurso.id" value="${concurso.id}"/>
        <g:hiddenField name="contrato" value="${contrato?.id}"/>
        <g:hiddenField name="show" value="${show}"/>

        <div class="form-group ${hasErrors(bean: documentoProcesoInstance, field: 'etapa', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Etapa
                </label>
                <span class="col-md-3">
                    <g:select id="etapa" name="etapa.id" from="${janus.pac.Etapa.list()}" optionKey="id" class="form-control many-to-one "
                              value="${documentoProcesoInstance?.etapa?.id?:4}"
                              optionValue="descripcion"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: documentoProcesoInstance, field: 'path', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Archivo
                </label>
                <span class="col-md-8">
                    <g:if test="${documentoProcesoInstance?.path}">
                        <span class="text-success">
                            ${documentoProcesoInstance?.path ? documentoProcesoInstance?.path : 'No se encuentra cargado ningún archivo' }
                        </span>
                    </g:if>
                    <g:else>
                        <input type="file" id="archivo" name="archivo" class='required'/>
                    </g:else>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: documentoProcesoInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <span class="col-md-6">
                    <g:textArea name="nombre" maxlength="255" class="form-control required"
                                value="${documentoProcesoInstance?.nombre}"  style="resize: none"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: documentoProcesoInstance, field: 'resumen', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Resumen
                </label>
                <span class="col-md-6">
                    <g:textArea name="resumen" maxlength="1024" class="form-control" value="${documentoProcesoInstance?.resumen}"
                                style="resize: none"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: documentoProcesoInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <span class="col-md-6">
                    <g:textField name="descripcion" maxlength="63" class="form-control required"
                                 value="${documentoProcesoInstance?.descripcion ?: respaldo}"
                                 style="width:280px;"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: documentoProcesoInstance, field: 'palabrasClave', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Palabras Clave
                </label>
                <span class="col-md-6">
                    <g:textField name="palabrasClave" maxlength="63" class="form-control" value="${documentoProcesoInstance?.palabrasClave}"
                    />
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

    </g:uploadForm>
</div>

<script type="text/javascript">
    $("#frmSave-DocumentoProceso").validate({
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
            submitFormDoc();
            return false;
        }
        return true;
    });
</script>
