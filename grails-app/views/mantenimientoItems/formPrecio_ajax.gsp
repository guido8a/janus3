<%@ page import="janus.PrecioRubrosItems" %>

<g:form class="form-horizontal" name="frmSave" action="savePrecio_ajax">
    <g:hiddenField name="id" value="${precioRubrosItemsInstance?.id}"/>
    <g:hiddenField id="lugar" name="lugar.id" value="${lugar ? precioRubrosItemsInstance?.lugar?.id : -1}"/>
    <g:hiddenField id="item" name="item.id" value="${precioRubrosItemsInstance?.item?.id}"/>
    <g:hiddenField name="all" value="${params.all}"/>
    <g:hiddenField name="ignore" value="${params.ignore}"/>

    <legend>
        Item:  ${precioRubrosItemsInstance.item.nombre} <br>
        Lista: ${lugarNombre}
    </legend>

    <div class="form-group ${hasErrors(bean: precioRubrosItemsInstance, field: 'precioUnitario', 'error')} ">
        <span class="grupo">
            <label for="precioUnitario" class="col-md-2 control-label text-info">
                Precio Unitario
            </label>
            <span class="col-md-6">
                <g:textField name="precioUnitario" class="form-control number required" value="${precioRubrosItemsInstance?.precioUnitario}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
            Unidad: <span style="font-weight: bold"> ${precioRubrosItemsInstance.item.unidad.codigo} </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: precioRubrosItemsInstance, field: 'fecha', 'error')} ">
        <span class="grupo">
            <label class="col-md-2 control-label text-info">
                Fecha
            </label>
            <span class="col-md-6">
                <g:if test="${fecha}">
                    ${fecha}
                    <g:hiddenField name="fecha" value="${fecha}"/>
                </g:if>
                <g:else>
                    <g:if test="${precioRubrosItemsInstance?.id}">
                        ${precioRubrosItemsInstance?.fecha?.format("dd-MM-yyyy")}
                        <g:hiddenField name="fecha" value="${precioRubrosItemsInstance?.fecha}"/>
                    </g:if>
                    <g:else>
                        <input aria-label="" name="fecha" id='datetimepicker3' type='text' class="form-control required"
                               value="${new Date().format("dd-MM-yyyy")}"/>
                    </g:else>
                </g:else>
            </span>
        </span>
    </div>


</g:form>

%{--<div id="create-precioRubrosItemsInstance" class="span" role="main">--}%
%{--    <g:form class="form-horizontal" name="frmSave" action="savePrecio_ajax">--}%
%{--        <g:hiddenField name="id" value="${precioRubrosItemsInstance?.id}"/>--}%
%{--        <g:hiddenField id="lugar" name="lugar.id" value="${lugar ? precioRubrosItemsInstance?.lugar?.id : -1}"/>--}%
%{--        <g:hiddenField id="item" name="item.id" value="${precioRubrosItemsInstance?.item?.id}"/>--}%
%{--        <g:hiddenField name="all" value="${params.all}"/>--}%
%{--        <g:hiddenField name="ignore" value="${params.ignore}"/>--}%

%{--        <div class="tituloTree">--}%
%{--            Item:  ${precioRubrosItemsInstance.item.nombre} <br>--}%
%{--            Lista: ${lugarNombre}--}%%{--${lugar ? precioRubrosItemsInstance.lugar.descripcion : "todos los lugares"}--}%
%{--        </div>--}%

%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Fecha--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:if test="${fecha}">--}%
%{--                    ${fecha}--}%
%{--                    <g:hiddenField name="fecha" value="${fecha}"/>--}%
%{--                </g:if>--}%
%{--                <g:else>--}%
%{--                    <elm:datepicker name="fecha" id="fechaPrecio" class="datepicker required" style="width: 100px"--}%
%{--                                    yearRange="${(new Date().format('yyyy').toInteger() - 40).toString() + ':' + new Date().format('yyyy')}"--}%
%{--                                    maxDate="${(new Date().format('MM').toInteger() + 60).toString()}"/>--}%
%{--                </g:else>--}%

%{--                <span class="mandatory">*</span>--}%

%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Precio Unitario--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <div class="input-append">--}%
%{--                    <g:field type="number" name="precioUnitario" class=" required input-small" value="${fieldValue(bean: precioRubrosItemsInstance, field: 'precioUnitario')}"/>--}%
%{--                    <span class="add-on" id="spanPeso">--}%
%{--                        $--}%
%{--                    </span>--}%
%{--                </div>--}%
%{--                Unidad: <span style="font-weight: bold"> ${precioRubrosItemsInstance.item.unidad.codigo} </span>--}%
%{--                <span class="mandatory">*</span>--}%

%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--    </g:form>--}%
%{--</div>--}%

<script type="text/javascript">

    $('#datetimepicker3').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });


    $("#frmSave").validate({
        rules          : {
            fecha : {
                remote : {
                    url  : "${createLink(action:'checkFcPr_ajax')}",
                    type : "post",
                    data : {
                        item  : "${precioRubrosItemsInstance.itemId}",
                        lugar : "${lugar?.id}"
                    }
                }
            }
        },
        messages       : {
            fecha : {
                remote : "Ya existe un precio para esta fecha"
            }
        },
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
        },
        errorClass     : "help-block"
    });
</script>
