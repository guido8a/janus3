<%@ page import="janus.pac.Oferta" %>

<div id="create-Oferta" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-Oferta" action="save">
    <g:hiddenField name="id" value="${ofertaInstance?.id}"/>
    <g:hiddenField id="concurso" name="concurso.id" value="${ofertaInstance?.concurso?.id}"/>

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Proceso
            </label>
            <span class="col-md-8">
                <g:if test="${ofertaInstance}">
                    ${ofertaInstance?.concurso?.objeto}
                </g:if>
                <g:else>
                    ${concurso?.objeto}
                </g:else>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-8">
                <g:textField name="descripcion" maxlength="255" class="form-control required" value="${ofertaInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'proveedor', 'error')} ">
        <span class="grupo">
            <label for="proveedor" class="col-md-2 control-label text-info">
                Proveedores
            </label>
            <span class="col-md-8">
                <g:select id="proveedor" name="proveedor.id" from="${janus.pac.Proveedor.list()}" optionKey="id" class="form-control"
                          value="${ofertaInstance?.proveedor?.id}" optionValue="nombre" noSelection="['null': '']" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'monto', 'error')} ">
        <span class="grupo">
            <label for="monto" class="col-md-2 control-label text-info">
                Monto
            </label>
            <span class="col-md-4">
                <g:textField name="monto" class="form-control required" value="${ofertaInstance?.monto}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'plazo', 'error')} ">
        <span class="grupo">
            <label for="plazo" class="col-md-2 control-label text-info">
                Plazo
            </label>
            <span class="col-md-4">
                <g:textField name="plazo" class="form-control required" value="${ofertaInstance?.plazo}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
            <span class="col-md-1">
                días
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'fechaEntrega', 'error')} ">
        <span class="grupo">
            <label for="fechaEntrega" class="col-md-2 control-label text-info">
                Fecha Entrega de la Oferta
            </label>
            <span class="col-md-4">
                <input aria-label="" name="fechaEntrega" id='fechaEntrega' type='text' class="form-control required" value="${ofertaInstance?.fechaEntrega?.format("dd-MM-yyyy") ?: new Date().format("dd-MM-yyyy")}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'hoja', 'error')} ">
        <span class="grupo">
            <label for="plazo" class="col-md-2 control-label text-info">
                Hojas de oferta
            </label>
            <span class="col-md-4">
                <g:textField name="hoja" class="form-control number" value="${ofertaInstance?.hoja ?: 0}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'hoja', 'error')} ">
        <span class="grupo">
            <label for="plazo" class="col-md-2 control-label text-info">
                Garantía
            </label>
            <span class="col-md-4">
                <g:select name="garantia" from="${[0: 'NO', 1 : 'SI']}" optionKey="key" optionValue="value" value="${ofertaInstance?.garantia}" class="form-control " />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'subsecretario', 'error')} ">
        <span class="grupo">
            <label for="subsecretario" class="col-md-2 control-label text-info">
                Secretario C.T.
            </label>
            <span class="col-md-4">
                <g:textField name="subsecretario" maxlength="40" class="form-control" value="${ofertaInstance?.subsecretario}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'responsableProceso', 'error')} ">
        <span class="grupo">
            <label for="subsecretario" class="col-md-2 control-label text-info">
                Responsable del proceso
            </label>
            <span class="col-md-8">
                <g:select name="responsableProceso.id" from="${responsablesProceso}" optionKey="id" optionValue="${{
                    it.apellido + ' ' + it.nombre
                }}" value="${ofertaInstance?.responsableProcesoId}" class="form-control required" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: ofertaInstance, field: 'observaciones', 'error')} ">
        <span class="grupo">
            <label for="observaciones" class="col-md-2 control-label text-info">
                Observaciones
            </label>
            <span class="col-md-8">
                <g:textField name="observaciones" maxlength="127" class="form-control" value="${ofertaInstance?.observaciones}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>



%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Proceso--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:hiddenField id="concurso" name="concurso.id" value="${ofertaInstance?.concurso?.id}"/>--}%
%{--            ${ofertaInstance?.concurso?.objeto}--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Descripción--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textArea name="descripcion" cols="100" rows="5" maxlength="255" class="" value="${ofertaInstance?.descripcion}" style="width: 400px;"/>--}%
%{--            <span class="mandatory">*</span>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Proveedor--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <span id="spProv">--}%
%{--                <g:select id="proveedor" name="proveedor.id" from="${janus.pac.Proveedor.list()}" optionKey="id" class="many-to-one "--}%
%{--                          value="${ofertaInstance?.proveedor?.id}" noSelection="['null': '']" optionValue="nombre" style="width: 380px;"/>--}%
%{--            </span>--}%
%{--            <span class="mandatory">*</span>--}%
%{--            <a href="#" id="btnProv" class="btn" rel="tooltip" title="Agregar proveedor"><i class="icon-plus"></i></a>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%


%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Monto--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:field type="number" name="monto" class="" value="${ofertaInstance.monto}" style="width:140px;"/>--}%
%{--            <span class="mandatory">*</span>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Plazo--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:field type="number" name="plazo" class="" value="${fieldValue(bean: ofertaInstance, field: 'plazo')}" style="width:80px;"/>--}%
%{--            días--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Fecha Entrega de la Oferta--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <elm:datepicker name="fechaEntrega" class="" value="${ofertaInstance?.fechaEntrega}" style="width:140px;"/>--}%
%{--            <span class="mandatory">*</span>--}%


%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%



%{--<div class="control-group">--}%
%{--<div>--}%
%{--<span class="control-label label label-inverse">--}%
%{--Calificado--}%
%{--</span>--}%
%{--</div>--}%

%{--<div class="controls">--}%
%{--<g:textField name="calificado" maxlength="1" class="" value="${ofertaInstance?.calificado}"/>--}%

%{--<p class="help-block ui-helper-hidden"></p>--}%
%{--</div>--}%
%{--</div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Hojas de oferta--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:field type="number" name="hoja" class="" value="${fieldValue(bean: ofertaInstance, field: 'hoja')}" style="width:50px;"/>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Garantía--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <input type="checkbox" name="garantia" value="1" ${(ofertaInstance?.garantia == "1") ? "checked" : ""}>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Secretario C.T.--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="subsecretario" maxlength="40" class="" value="${ofertaInstance?.subsecretario}" style="width: 300px;"/>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Responsable del proceso--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:select name="responsableProceso.id" from="${responsablesProceso}" optionKey="id" optionValue="${{--}%
%{--                it.apellido + ' ' + it.nombre--}%
%{--            }}" value="${ofertaInstance?.responsableProcesoId}" class="required" style="width: 360px;"/>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%


%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Observaciones--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="observaciones" maxlength="127" class="" value="${ofertaInstance?.observaciones}" style="width: 400px;"/>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

</g:form>


%{--<div class="modal mediumModal hide fade" id="modal-prov">--}%
%{--    <div class="modal-header" id="modalHeader-prov">--}%
%{--        <button type="button" class="close darker" data-dismiss="modal">--}%
%{--            <i class="icon-remove-circle"></i>--}%
%{--        </button>--}%

%{--        <h3 id="modalTitle-prov"></h3>--}%
%{--    </div>--}%

%{--    <div class="modal-body" id="modalBody-prov">--}%
%{--    </div>--}%

%{--    <div class="modal-footer" id="modalFooter-prov">--}%
%{--    </div>--}%
%{--</div>--}%

<script type="text/javascript">

    $('#fechaEntrega').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    %{--$("#btnProv").click(function () {--}%
    %{--    var url = "${createLink(controller: 'proveedor', action: 'form_ajax_fo')}";--}%
    %{--    $.ajax({--}%
    %{--        type    : "POST",--}%
    %{--        url     : url,--}%
    %{--        success : function (msg) {--}%
    %{--            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');--}%
    %{--            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');--}%

    %{--            btnSave.click(function () {--}%
    %{--                btnSave.replaceWith(spinner)--}%
    %{--                var $frm = $("#frmSave-Proveedor-fo");--}%
    %{--                $.ajax({--}%
    %{--                    type    : "POST",--}%
    %{--                    url     : $frm.attr("action"),--}%
    %{--                    data    : $frm.serialize(),--}%
    %{--                    success : function (msg) {--}%
    %{--                        if (msg != "NO") {--}%
    %{--                            $("#modal-prov").modal("hide");--}%
    %{--                            $("#spProv").html(msg);--}%
    %{--                        }--}%
    %{--                    }--}%
    %{--                });--}%

    %{--                return false;--}%
    %{--            });--}%

    %{--            $("#modalHeader-prov").removeClass("btn-edit btn-show btn-delete");--}%
    %{--            $("#modalTitle-prov").html("Crear Proveedor");--}%
    %{--            $("#modalBody-prov").html(msg);--}%
    %{--            $("#modalFooter-prov").html("").append(btnOk).append(btnSave);--}%
    %{--            $("#modal-prov").modal("show");--}%
    %{--        }--}%
    %{--    });--}%
    %{--    return false;--}%
    %{--});--}%

    $("#frmSave-Oferta").validate({
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
            submitFormOferta();
            return false;
        }
        return true;
    });
</script>
