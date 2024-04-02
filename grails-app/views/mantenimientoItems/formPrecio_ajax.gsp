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
                               value="${fd?.format("dd-MM-yyyy") ?: new Date().format("dd-MM-yyyy")}"/>
                    </g:else>
                </g:else>
            </span>
        </span>
    </div>
</g:form>

<script type="text/javascript">

    function validarNum(ev) {
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
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#precioUnitario").keydown(function (ev) {
        return validarNum(ev);
    });


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
