
<%@ page import="janus.pac.CronogramaContratado; janus.pac.CronogramaContrato" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">

    <asset:javascript src="/apli/tableHandlerBody.js"/>
    <asset:stylesheet src="/tableHandler.css"/>
    <asset:javascript src="/jquery/plugins/box/js/jquery.luz.box.js"/>
    <asset:javascript src="/jquery/plugins/box/css/jquery.luz.box.css"/>
    <asset:stylesheet src="/apli/cronograma.css"/>

    <style>
    .negrita{
        font-weight: bold;
        font-style: italic;
    }
    .rowSelected {
        /*background-color: #39abc7;*/
    }

    </style>

    <title>Cronograma</title>
</head>

<body>
<g:set var="meses" value="${Math.ceil(contrato.plazo/30).toInteger()}"/>
<g:set var="sum" value="${0}"/>

<div class="tituloTree alert alert-info">
    Cronograma del contrato de la obra: <strong> ${obra.descripcion} (${meses} mes${meses == 1 ? "" : "es"}) </strong>
</div>

<div class="btn-toolbar" style="margin-top: 15px">
    <div class="btn-group" style="margin-top: 10px">
        <a href="${g.createLink(controller: 'contrato', action: 'registroContrato', params: [contrato: contrato?.id])}" class="btn btn-info btn-new" id="atras" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </a>
        %{--<g:if test="${meses > 0 && plazoOk && contrato.estado != 'R'}">--}%
        <a href="#" class="btn disabled" id="btnDeleteRubro">
            <i class="fa fa-minus"></i>
            Eliminar Rubro
        </a>
        <a href="#" class="btn btn-danger ${contrato?.estado == 'R' ? 'disabled' : ''} " id="btnDeleteCronograma">
            <i class="fa fa-trash"></i>
            Eliminar Cronograma
        </a>
        %{--</g:if>--}%
    </div>

    %{--<g:if test="${meses > 0 && plazoOk}">--}%
    <div class="btn-group" style="margin-top: 10px">
        <a href="#" class="btn" id="btnGrafico">
            <i class="fa fa-clipboard"></i>
            Gráficos de avance
        </a>
        <a href="#" id="btnReporte" class="btn">
            <i class="fa fa-print"></i>
            Imprimir
        </a>
    </div>
    %{--</g:if>--}%


    %{--    <div class="btn-group">--}%
    %{--    <g:link controller="cronogramaContrato" action="excelCronograma" class="btn btn-print btnExcel"--}%
    %{--            id="${contrato?.id}"--}%
    %{--            title="Exportar a excel el cronograma"--}%
    %{--            style="margin-left: 80px;">--}%
    %{--        <i class="fa fa-file-excel"></i> Generar Archivo Excel--}%
    %{--    </g:link>--}%
    %{--    <g:link controller="cronogramaContrato" action="subirExcelCronograma" class="btn btn-print btnExcel"--}%
    %{--            id="${contrato?.id}"--}%
    %{--            title="Subir archivo excel"--}%
    %{--            style="margin-left: 0px;">--}%
    %{--        <i class="fa fa-arrow-up"></i> Cargar desde Excel--}%
    %{--    </g:link>--}%
    %{--    </div>--}%



    <div class="col-md-3">
        <strong>Subpresupuesto:</strong>
        <g:select name="subpresupuesto" class="form-control" from="${subpres}" optionKey="${{it.id}}" optionValue="${{it.descripcion}}"
                  style="font-size: 10px" id="subpres" value="${subpre}"
                  noSelection="['-1': 'TODOS']"/>
    </div>
    <div class="col-md-3" style="margin-top: 15px">
        <a href="#" class="btn btn-info"  id="btnSubpre"><i class="fa fa-search"></i> Ver</a>

        <g:if test="${contrato.estado != 'R'}">
            <a href="#" class="btn" id="btnDesmarcar"><i class="fa fa-eraser"></i> Desmarcar todo</a>
        </g:if>
    </div>


</div>

%{--<div class="col-md-12" style="margin-top: 5px; margin-bottom: 5px;">--}%
%{--    <div class="col-md-3">--}%
%{--        <strong>Subpresupuesto:</strong>--}%
%{--        <g:select name="subpresupuesto" class="form-control" from="${subpres}" optionKey="${{it.id}}" optionValue="${{it.descripcion}}"--}%
%{--                  style="font-size: 10px" id="subpres" value="${subpre}"--}%
%{--                  noSelection="['-1': 'TODOS']"/>--}%
%{--    </div>--}%
%{--    <div class="col-md-4" style="margin-top: 15px">--}%
%{--        <a href="#" class="btn btn-info"  id="btnSubpre"><i class="fa fa-search"></i> Ver</a>--}%

%{--        <g:if test="${contrato.estado != 'R'}">--}%
%{--            <a href="#" class="btn" id="btnDesmarcar"><i class="fa fa-eraser"></i> Desmarcar todo</a>--}%
%{--        </g:if>--}%
%{--    </div>--}%
%{--</div>--}%

<div>
    <strong style="font-size: 14px"> * La ruta crítica se muestra con los rubros marcados en amarillo </strong>
</div>

%{--<g:if test="${meses > 0 && plazoOk}">--}%
<div class="divTabla">
    <table class="table table-bordered table-condensed table-hover">
        <thead>
        <tr>
            <th class="codigo">
                Código
            </th>
            <th class="nombre">
                Rubro
            </th>
            <th class="unidad">
                Unidad
            </th>
            <th class="cantidad">
                Cantidad
            </th>
            <th class="precioU">
                Unitario
            </th>
            <th class="subtotal">
                C.Total
            </th>
            <th class="tiny">
                T.
            </th>
            <g:each in="${0..meses - 1}" var="i">
                <th class="meses">
                    Mes ${i + 1}
                </th>
            </g:each>
            <th class="totalRubro">
                Total Rubro
            </th>
        </tr>
        </thead>
        <tbody id="tabla_material">

        <g:each in="${detalle}" var="vol" status="s">

            <g:set var="cronos" value="${CronogramaContratado.findAllByVolumenContrato(vol)}"/>

            <tr class="item_row ${vol.rutaCritica == 'S' ? 'rutaCritica' : ''}" id="${vol.id} " data-id="${vol.id}">
                <td class="codigo">
                    ${vol.item.codigo}
                </td>
                <td class="nombre">
                    ${vol.item.nombre}
                </td>
                <td style="text-align: center" class="unidad">
                    ${vol.item.unidad.codigo}
                </td>
                <td class="num cantidad" data-valor="${vol.volumenCantidad + vol.cantidadComplementaria}">
                    <g:formatNumber number="${vol.volumenCantidad + vol.cantidadComplementaria}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                </td>
                <td class="num precioU" data-valor="${vol.volumenPrecio}">
                    <g:formatNumber number="${vol.volumenPrecio}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                </td>
                <g:set var="parcial" value="${Math.round( (vol.volumenCantidad + vol.cantidadComplementaria)* vol.volumenPrecio*10000)/10000}"/>
                <td class="num subtotal" data-valor="${parcial}">
                    <g:formatNumber number="${parcial}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                    <g:set var="sum" value="${sum + parcial}"/>
                </td>
                <td class="tiny">
                    $
                </td>
                <g:each in="${0..meses - 1}" var="i">
                    <g:set var="prec" value="${cronos.find { it.periodo == i + 1 }}"/>
                    <td class="dol mes meses num mes${i + 1} rubro${vol.id}" data-mes="${i + 1}" data-rubro="${vol.id}" data-valor="0"
                        data-tipo="dol" data-val="${prec?.precio ?: 0}" data-id="${prec?.id ?: ''}">
                        <g:formatNumber number="${prec?.precio}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                    </td>
                </g:each>
                <td class="num rubro${vol.id} dol total totalRubro">
                    <span>
                    </span> $
                </td>
            </tr>

            <tr class="item_prc ${vol.rutaCritica == 'S' ? 'rutaCritica' : ''}" data-id="${vol.id}">
                <td colspan="3">
                    &nbsp
                </td>
                <td style="text-align: center">
                    <a href="#" class="btn btn-success btn-xs btnEditar" data-id="${vol?.id}" data-cantidad="${vol.volumenCantidad + vol.cantidadComplementaria}" title="Editar cantidad complementaria">
                        <i class="fa fa-edit"></i>
                    </a>
                </td>
                <td colspan="2">
                    &nbsp
                </td>
                <td>
                    %
                </td>
                <g:each in="${0..meses - 1}" var="i">
                    <g:set var="porc" value="${cronos.find { it.periodo == i + 1 }}"/>
                    <td class="prct mes num mes${i + 1} rubro${vol.id}" data-mes="${i + 1}" data-rubro="${vol.id}" data-valor="0"
                        data-tipo="prct" data-val="${porc?.porcentaje ?: 0}" data-id="${porc?.id ?: ''}">
                        <g:formatNumber number="${porc?.porcentaje}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                    </td>
                </g:each>
                <td class="num rubro${vol.id} prct total totalRubro">
                    <span>
                    </span> %
                </td>
            </tr>
            <tr class="item_f ${vol.rutaCritica == 'S' ? 'rutaCritica' : ''}" data-id="${vol.id}">
                <td colspan="6">
                    &nbsp
                </td>
                <td>
                    F
                </td>
                <g:each in="${0..meses - 1}" var="i">
                    <g:set var="cant" value="${cronos.find { it.periodo == i + 1 }}"/>
                    <td class="fis mes num mes${i + 1} rubro${vol.id}" data-mes="${i + 1}" data-rubro="${vol.id}" data-valor="0"
                        data-tipo="fis" data-val="${cant?.cantidad ?: 0}" data-id="${cant?.id ?: ''}">
                        <g:formatNumber number="${cant?.cantidad}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                    </td>
                </g:each>
                <td class="num rubro${vol.id} fis total totalRubro">
                    <span>
                    </span> F
                </td>
            </tr>

        </g:each>
        </tbody>
        <tfoot>
        <tr>
            <td></td>
            <td colspan="4" class="negrita">TOTAL PARCIAL</td>
            <td class="num negrita">
                <g:formatNumber number="${sum}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
            </td>
            <td class="negrita">T</td>
            <g:each in="${0..meses - 1}" var="i">
                <td class="num mes${i + 1} totalParcial total negrita" data-mes="${i + 1}" data-valor="0">
                </td>
            </g:each>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td colspan="4" class="negrita">TOTAL ACUMULADO</td>
            <td></td>
            <td class="negrita">T</td>
            <g:each in="${0..meses - 1}" var="i">
                <td class="num mes${i + 1} totalAcumulado total negrita" data-mes="${i + 1}" data-valor="0">
                    0.00
                </td>
            </g:each>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td colspan="4" class="negrita">% PARCIAL</td>
            <td></td>
            <td class="negrita">T</td>
            <g:each in="${0..meses - 1}" var="i">
                <td class="num mes${i + 1} prctParcial total negrita" data-mes="${i + 1}" data-valor="0">
                    0.00
                </td>
            </g:each>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td colspan="4" class="negrita">% ACUMULADO</td>
            <td></td>
            <td class="negrita">T</td>
            <g:each in="${0..meses - 1}" var="i">
                <td class="num mes${i + 1} prctAcumulado total negrita" data-mes="${i + 1}" data-valor="0">
                    0.00
                </td>
            </g:each>
            <td></td>
        </tr>
        </tfoot>
    </table>
</div>

<div class="" id="modal-cronograma">

    <div class="modal-body" id="modalBody">
        <form class="form-horizontal" id="frmRubro">

            <div class="control-group sm">

                <span class="col-md-3 badge" style="width: 135px; margin-right: 10px">
                    Rubro N.
                </span>



                <div class="controls">
                    <span aria-labelledby="num-label" id="spanCodigo">

                    </span>
                </div>
            </div>

            <div class="control-group sm">
                <span class="col-md-3 badge" style="width: 135px;margin-right: 10px">
                    Descripción
                </span>

                <div class="controls">
                    <span aria-labelledby="desc-label" id="spanDesc">

                    </span>
                </div>
            </div>

            <div class="control-group sm">
                <span class="col-md-3 badge" style="width: 135px;margin-right: 10px">
                    Cantidad
                </span>

                <div class="controls">
                    <span aria-labelledby="cant-label" id="spanCant">

                    </span>
                </div>
            </div>

            <div class="control-group sm">
                <span class="col-md-3 badge" style="width: 135px;margin-right: 10px">
                    Precio
                </span>

                <div class="controls">
                    <span aria-labelledby="precio-label" id="spanPrecio">

                    </span>
                </div>
            </div>

            <div class="control-group sm">
                <span class="col-md-3 badge" style="width: 135px;margin-right: 10px">
                    Subtotal
                </span>
                <div class="controls">
                    <span aria-labelledby="st-label" id="spanSubtotal">

                    </span>
                </div>
            </div>
        </form>

        <div id="divRubro" class="col-md-3 badge" style="width: 135px; margin-top: 10px; margin-bottom: 20px">
            Múltiples rubros
        </div>

        <div class="well" style="height: 180px">
            <div class="row" style="margin-bottom: 10px;">
                <div class="span5">
                    Períodos   <input id="periodosDesde" type="text" class="input-mini tf"/> al
                    <input id="periodosHasta" type="text" class="input-mini tf" value="${meses}"/>
                </div>
            </div>

%{--            <div class="row">--}%
%{--                <div class="span5">--}%
%{--                    <input type="radio" class="radio cant" name="tipo" id="rd_cant" value="cant" checked=""/>--}%
%{--                    Cantidad <input type="text" class="input-mini tf" id="tf_cant"/><span class="spUnidad"></span>--}%
%{--                    de <span id="spCant"></span> <span class="spUnidad"></span>--}%
%{--                </div>--}%
%{--            </div>--}%

            <div class="col-md-12" style="margin-top: 5px">
                <div class="col-md-1">
                    <input type="radio" class="radio cant" name="tipo" id="rd_cant" value="cant" checked=""/>
                </div>
                <div class="col-md-2">
                    Cantidad
                </div>
                <div class="col-md-6">
                    <input type="text" class="input-mini tf" id="tf_cant"/> <span class="spUnidad"></span>
                </div>
                <div class="col-md-3">
                    de <span id="spCant"></span> <span class="spUnidad"></span>
                </div>
            </div>

            <div class="col-md-12" style="margin-top: 5px">
                <div class="col-md-1">
                    <input type="radio" class="radio prct" name="tipo" id="rd_prct" value="prct"/>
                </div>
                <div class="col-md-2">
                    Porcentaje
                </div>
                <div class="col-md-6">
                    <input type="text" class="input-mini tf" id="tf_prct"/> %
                </div>
                <div class="col-md-3">
                    de <span id="spPrct"></span>%
                </div>
            </div>

            <div class="col-md-12" style="margin-top: 5px">
                <div class="col-md-1">
                    <input type="radio" class="radio precio" name="tipo" id="rd_precio" value="prct"/>
                </div>
                <div class="col-md-2">
                    Precio
                </div>
                <div class="col-md-6">
                    <input type="text" class="input-mini tf" id="tf_precio"/> $
                </div>
                <div class="col-md-3">
                    de <span id="spPrecio"></span>$
                </div>
            </div>

%{--            <div class="row">--}%
%{--                <div class="span5">--}%
%{--                    <input type="radio" class="radio prct" name="tipo" id="rd_prct" value="prct"/>--}%
%{--                    Porcentaje <input type="text" class="input-mini tf" id="tf_prct"/>%--}%
%{--                de <span id="spPrct"></span>%--}%
%{--                </div>--}%
%{--            </div>--}%

%{--            <div class="row">--}%
%{--                <div class="span5">--}%
%{--                    <input type="radio" class="radio precio" name="tipo" id="rd_precio" value="prct"/>--}%
%{--                    Precio <input type="text" class="input-mini tf" id="tf_precio"/>$--}%
%{--                de <span id="spPrecio"></span>$--}%
%{--                </div>--}%
%{--            </div>--}%
        </div>

    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>


<div class="modal longModal tallModal fade hide " id="modal-graf">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle-graf"></h3>
    </div>

    <div class="modal-body" id="modalBody-graf">
        <div class="graf" id="graf"></div>
    </div>

    <div class="modal-footer" id="modalFooter-graf">
    </div>
</div>

<div class="modal hide fade mediumModal" id="modal-TipoObra" style=";overflow: hidden;">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle_tipo">
        </h3>
    </div>

    <div class="modal-body" id="modalBody_tipo">

    </div>

    <div class="modal-footer" id="modalFooter_tipo">
    </div>
</div>

<script type="text/javascript">

    $("#modal-cronograma").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        draggable: false,
        width: 550,
        height: 480,
        position: 'center',
        title: 'Registro del cronograma'
    });

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        var cantidad = $(this).data("cantidad");

        $.ajax({
            type: 'POST',
            url:'${createLink(controller: 'cronogramaContrato', action: 'modificarCantidad_ajax')}',
            data:{
                id: id
            },
            success: function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : "Modificar la cantidad",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormModificarCantidad();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        });
    });

    function submitFormModificarCantidad() {
        var $form = $("#frmSave-Programacion");
        if ($form.valid()) {
            var data = $form.serialize();
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    if(msg === 'ok'){
                        log("Cantidad Modificada", "success");
                        setTimeout(function () {
                            location.reload();
                        }, 800);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al cambiar la cantidad" + '</strong>');
                        return false;
                    }
                }
            });
        } else {
            return false;
        }
    }

    function updateTotales() {

        $("#tabla_material").children("tr").each(function () {
            var rubro = $(this).data("id");

            var totalFilaDol = 0;
            var totalFilaPrct = 0;
            var totalFilaFis = 0;

            var $totalFilaDol = $(".total.dol" + ".rubro" + rubro);
            var $totalFilaPrct = $(".total.prct" + ".rubro" + rubro);
            var $totalFilaFis = $(".total.fis" + ".rubro" + rubro);

            //calcular los totales de la fila: del rubro
            if ($(this).hasClass("item_row")) {
                $(".dol.rubro" + rubro).not(".total").each(function () {
                    var val = parseFloat($(this).data("val"));
                    if (val && !isNaN(val)) {
                        totalFilaDol += val;
                    }
                });
                $totalFilaDol.data("val", totalFilaDol).children("span").first().text(number_format(totalFilaDol, 2, ".", ","));
            } else if ($(this).hasClass("item_prc")) {
                $(".prct.rubro" + rubro).not(".total").each(function () {
                    var val = parseFloat($(this).data("val"));
                    if (val && !isNaN(val)) {
                        totalFilaPrct += val;
                    }
                });
                $totalFilaPrct.data("val", totalFilaPrct).children("span").first().text(number_format(totalFilaPrct, 2, ".", ","));
            } else if ($(this).hasClass("item_f")) {
                $(".fis.rubro" + rubro).not(".total").each(function () {
                    var val = parseFloat($(this).data("val"));
                    if (val && !isNaN(val)) {
                        totalFilaFis += val;
                    }
                });
                $totalFilaFis.data("val", totalFilaFis).children("span").first().text(number_format(totalFilaFis, 2, ".", ","));
            }
        });

        //calcular los totales de la columna: del mes
        var totAcum = 0;
        for (var i = 0; i < parseInt("${meses}") + 1; i++) {
            var $totalParcial = $(".totalParcial.mes" + i);
            var $totalAcumulado = $(".totalAcumulado.mes" + i);
            var $prctParcial = $(".prctParcial.mes" + i);
            var $prctAcumulado = $(".prctAcumulado.mes" + i);
            var tot = 0;
            $(".dol.mes" + i).not(".total").each(function () {
                var val = parseFloat($(this).data("val"));
                if (val && !isNaN(val)) {
                    tot += val;
                    totAcum += val;
                }
            });

            var prc = tot * 100 / parseFloat("${sum}");
            $(".total.mes" + i + ".totalParcial").text(number_format(tot, 2, ".", ",")).data("val", tot);
            $(".total.mes" + i + ".prctParcial").text(number_format(prc, 2, ".", ",")).data("val", prc);

            var prcAcum = totAcum * 100 / parseFloat("${sum}");
            $(".total.mes" + i + ".totalAcumulado").text(number_format(totAcum, 2, ".", ",")).data("val", totAcum);
            $(".total.mes" + i + ".prctAcumulado").text(number_format(prcAcum, 2, ".", ",")).data("val", prcAcum);
        }
    }

    function validar() {
        var periodoIni = $.trim($("#periodosDesde").val());
        var periodoFin = $.trim($("#periodosHasta").val());

        var $cant = $("#tf_cant");
        var $prct = $("#tf_prct");
        var $prec = $("#tf_precio");

        var cant = $.trim($cant.val());
        var prct = $.trim($prct.val());
        var prec = $.trim($prec.val());

        if (periodoIni === "") {
            bootbox.alert("Ingrese el periodo inicial");
            return false;
        }
        if (periodoFin === "") {
            bootbox.alert("Ingrese el periodo final");
            return false;
        }
        if (cant === "") {
            bootbox.alert("Ingrese la cantidad, porcentaje o precio");
            return false;
        }
        if (prct === "") {
            bootbox.alert("Ingrese el porcentaje, cantidad o precio");
            return false;
        }
        if (prec === "") {
            bootbox.alert("Ingrese el precio, cantidad o porcentaje");
            return false;
        }

        var maxCant = $cant.attr("max");
        var maxPrct = $prct.attr("max");
        var maxPrec = $prec.attr("max");

        try {
            periodoIni = parseFloat(periodoIni);
            periodoFin = parseFloat(periodoFin);

            if (periodoFin < periodoIni) {
                bootbox.alert("El periodo inicial debe ser inferior al periodo final");
                return false;
            }

            cant = parseFloat(cant);
            prct = parseFloat(prct);
            maxCant = parseFloat(maxCant);
            maxPrct = parseFloat(maxPrct);
            maxPrec = parseFloat(maxPrec);

            if (cant > maxCant) {
                bootbox.alert("La cantidad debe ser menor que " + maxCant);
                return false;
            }
            if (prct > maxPrct) {
                bootbox.alert("El porcentaje debe ser menor que " + maxPrct);
                return false;
            }
            if (prec > maxPrec) {
                bootbox.alert("El precio debe ser menor que " + maxPrec);
                return false;
            }

        } catch (e) {
            return false;
        }
        return true;
    }

    function validar2() {
        var periodoIni = $.trim($("#periodosDesde").val());
        var periodoFin = $.trim($("#periodosHasta").val());

        var $prct = $("#tf_prct");

        var prct = $.trim($prct.val());

        if (periodoIni === "") {
            bootbox.alert("Ingrese el periodo inicial");
            return false;
        }
        if (periodoFin === "") {
            bootbox.alert("Ingrese el periodo final");
            return false;
        }
        if (prct === "") {
            bootbox.alert("Ingrese el porcentaje, cantidad o precio");
            return false;
        }

        var maxPrct = $prct.attr("max");

        try {
            periodoIni = parseFloat(periodoIni);
            periodoFin = parseFloat(periodoFin);

            if (periodoFin < periodoIni) {
                bootbox.alert("El periodo inicial debe ser inferior al periodo final");
                return false;
            }

            prct = parseFloat(prct);
            maxPrct = parseFloat(maxPrct);

            if (prct > maxPrct) {
                bootbox.alert("El porcentaje debe ser menor que " + maxPrct);
                return false;
            }

        } catch (e) {
            return false;
        }
        return true;
    }

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) || (ev.keyCode >= 96 && ev.keyCode <= 105) || ev.keyCode === 190 || ev.keyCode === 110 || ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9);
    }

    function getSelected() {
        return $(".item_row").filter(".rowSelected");
    }

    $(function () {

        $("#subpres").val(${subpre});

        updateTotales();

        $("#btnDesmarcar").click(function () {
            quitarSeleccion();
        });

        function quitarSeleccion () {
            $("#btnDeleteRubro").addClass("disabled");
            $(".rowSelected").removeClass("rowSelected");
        }

        $("#btnSubpre").click(function () {
            location.href = "${createLink(action: 'nuevoCronograma')}/${contrato.id}?subpre=" + $("#subpres").val();
        });

        <g:if test="${contrato.estado!='R'}">
        $("#tabla_material").children("tr").click(function () {

            if ($(this).hasClass("rowSelected")) {
                $(this).removeClass("rowSelected");
                if ($(this).hasClass("item_row")) {
                    $(this).next().removeClass("rowSelected").next().removeClass("rowSelected");
                } else if ($(this).hasClass("item_prc")) {
                    $(this).next().removeClass("rowSelected");
                    $(this).prev().removeClass("rowSelected");
                } else if ($(this).hasClass("item_f")) {
                    $(this).prev().removeClass("rowSelected").prev().removeClass("rowSelected");
                }
            } else {
                $(this).addClass("rowSelected");
                if ($(this).hasClass("item_row")) {
                    $(this).next().addClass("rowSelected").next().addClass("rowSelected");
                } else if ($(this).hasClass("item_prc")) {
                    $(this).next().addClass("rowSelected");
                    $(this).prev().addClass("rowSelected");
                } else if ($(this).hasClass("item_f")) {
                    $(this).prev().addClass("rowSelected").prev().addClass("rowSelected");
                }
            }

            var sel = getSelected();
            if (sel.length === 0) {
                $("#btnLimpiarRubro, #btnDeleteRubro").addClass("disabled");
            } else {
                $("#btnLimpiarRubro, #btnDeleteRubro").removeClass("disabled");
            }
        });
        </g:if>

        $(".spinner").spinner({
            min : 1,
            max :${meses}//,

        }).keydown(function () {
            return false;
        });

        $(".disabled").click(function () {
            return false;
        });

        $(".tf").keydown(function (ev) {
            return validarNum(ev);
        }).focus(function () {
            var id = $(this).attr("id");
            var parts = id.split("_");
            $("#rd_" + parts[1]).attr("checked", true);
        });

        $("#tf_cant").keyup(function (ev) {
            if (validarNum(ev)) {
                var val = $.trim($(this).val());
                if (val === "") {
                    $("#tf_prct").val("");
                    $("#tf_precio").val("");
                } else {
                    try {
                        val = parseFloat(val);
                        var max = parseFloat($(this).data("max"));
                        if (val > max) {
                            val = max;
                        }
                        var $precio = $("#tf_precio");
                        var total = parseFloat($(this).data("total"));
                        var prct = (val * 100) / total;
                        var dol = $precio.data("max") * (prct / 100);
                        $("#tf_prct").val(number_format(prct, 2, ".", "")).data("val", prct);
                        $precio.val(number_format(dol, 2, ".", "")).data("val", dol);
                        if (ev.keyCode !== 110 && ev.keyCode !== 190) {
                            $("#tf_cant").val(val).data("val", val);
                        }
                    } catch (e) {
                    }
                }
            }
        });

        $("#tf_prct").keyup(function (ev) {
            if (validarNum(ev)) {
                var prct = $.trim($(this).val());
                if (prct === "") {
                    $("#tf_cant").val("");
                    $("#tf_precio").val("");
                } else {
                    var $sel = getSelected();
                    if ($sel.length === 1) {
                        try {
                            prct = parseFloat(prct);
                            var max = parseFloat($(this).data("max"));
                            if (prct > max) {
                                prct = max;
                            }
                            var $precio = $("#tf_precio");
                            var $cant = $("#tf_cant");
                            var total = parseFloat($cant.data("total"));
                            var val = (prct / 100) * total;
                            var dol = $precio.data("max") * (prct / 100);
                            $cant.val(number_format(val, 2, ".", "")).data("val", val);
                            $precio.val(number_format(dol, 2, ".", "")).data("val", dol);
                            if (ev.keyCode !== 110 && ev.keyCode !== 190) {
                                $("#tf_prct").val(prct).data("val", prct);
                            }
                        } catch (e) {
                        }
                    } //if $sel.lenght = 1
                    else {
                        try {
                            prct = parseFloat(prct);
                            if (prct > 100) {
                                prct = 100;
                            }
                            if (ev.keyCode !== 110 && ev.keyCode !== 190) {
                                $("#tf_prct").val(prct).data("val", prct);
                                $("#tf_cant").val("").data("val", null);
                                $("#tf_precio").val("").data("val", null);
                            }
                        } catch (e) {
                        }
                    } //$sel.lenght > 1
                }
            }
        });
        $("#tf_precio").keyup(function (ev) {
            if (validarNum(ev)) {
                var dol = $.trim($(this).val());
                if (dol === "") {
                    $("#tf_prct").val("");
                    $("#tf_cant").val("");
                } else {
                    try {
                        dol = parseFloat(dol);
                        var max = parseFloat($(this).data("max"));
                        if (dol > max) {
                            dol = max;
                        }
                        var $cant = $("#tf_cant");
                        var total = parseFloat($(this).data("total"));
                        var totalCant = parseFloat($cant.data("total"));
                        var prct = (dol * 100) / total;
                        var cant = dol * totalCant / total;

                        $("#tf_prct").val(number_format(prct, 2, ".", "")).data("val", prct);
                        $cant.val(number_format(cant, 2, ".", "")).data("val", cant);
                        if (ev.keyCode !== 110 && ev.keyCode !== 190) {
                            $("#tf_precio").val(dol).data("val", dol);
                        }
                    } catch (e) {
                    }
                }
            }
        });

        function clickOne($celda) {
            var $tr = $celda.parents("tr");
            if ($tr.hasClass("item_prc")) {
                $tr = $tr.prev();
            } else if ($tr.hasClass("item_f")) {
                $tr = $tr.prev().prev();
            }

            var mes = $celda.data("mes");
            var tipo = $celda.data("tipo");
            var valor = $celda.data("valor");
            var rubro = $celda.data("rubro");

            $("#periodosDesde").val(mes);
            $("#periodosHasta").val("${meses}");
            $("#divRubro").hide();
            $("#frmRubro").show();

            $("#rd_cant,#tf_cant,#rd_precio,#tf_precio").removeAttr("disabled");
            $("#rd_cant").attr("checked", true);

            var codigo = $.trim($tr.find(".codigo").text());
            var desc = $.trim($tr.find(".nombre").text());
            var cant = $.trim($tr.find(".cantidad").data("valor"));
            var precio = $.trim($tr.find(".precioU").data("valor"));
            var subtotal = $.trim($tr.find(".subtotal").data("valor"));
            var unidad = $.trim($tr.find(".unidad").text());

            var dolAsignado = $.trim($(".dol.rubro" + rubro).children("span").text());
            var prctAsignado = $.trim($(".prct.rubro" + rubro).children("span").text());
            var fAsignado = $.trim($(".fis.rubro" + rubro).children("span").text());

            var dolRestante = parseFloat(subtotal) - parseFloat(dolAsignado);
            var prctRestante = 100 - parseFloat(prctAsignado);
            var cantRestante = parseFloat(cant) - parseFloat(fAsignado);

            $("#spCant").text(cantRestante);
            $("#spPrct").text(prctRestante);
            $("#spPrecio").text(number_format(dolRestante, 2, ".", ","));

            $("#tf_cant").data({
                max   : cantRestante,
                total : cant
            }).val("");
            $("#tf_prct").data({
                max   : prctRestante,
                total : 100
            }).val("");
            $("#tf_precio").data({
                max   : dolRestante,
                total : subtotal
            }).val("");

            $("#spanCodigo").text(codigo);
            $("#spanDesc").text(desc);
            $("#spanCant").text(number_format(cant, 2, ".", ",") + " " + unidad);
            $("#spanPrecio").text(number_format(precio, 2, ".", ",") + " $");
            $("#spanSubtotal").text(number_format(subtotal, 2, ".", ",") + " $");
            $(".spUnidad").text(unidad);

            var $btnCancel = $('<a href="#" data-dismiss="modal" class="btn btn-info" id="btnCerrar"><i class="fa fa-times"></i> Cerrar</a>');
            var $btnOk = $('<a href="#" class="btn btn-success"><i class="fa fa-save"></i> Aceptar</a>');

            $btnOk.click(function () {
                if (validar()) {
                    $btnOk.replaceWith(spinner);

                    var dataAjax = "";

                    var periodoIni = parseInt($("#periodosDesde").val());
                    var periodoFin = parseInt($("#periodosHasta").val());

                    var cant = $("#tf_cant").data("val");
                    var prct = $("#tf_prct").data("val");

                    var d, i, dol;

                    if (periodoIni === periodoFin) {
                        dol = subtotal * (prct / 100);
                        $(".dol.mes" + periodoIni + ".rubro" + rubro).text(number_format(dol, 2, ".", ",")).data("val", dol);
                        $(".prct.mes" + periodoIni + ".rubro" + rubro).text(number_format(prct, 2, ".", ",")).data("val", prct);
                        $(".fis.mes" + periodoIni + ".rubro" + rubro).text(number_format(cant, 2, ".", ",")).data("val", cant);
                        dataAjax += "&crono=" + rubro + "_" + periodoIni + "_" + dol + "_" + prct + "_" + cant;
                    } else {
                        var meses = periodoFin - periodoIni + 1;
                        dol = subtotal * (prct / 100);

                        var dolCalc = dol, prctCalc = prct, cantCalc = cant;
                        dol = Math.round((dol / meses) * 100) / 100;
                        prct = Math.round((prct / meses) * 100) / 100;
                        cant = Math.round((cant / meses) * 100) / 100;

                        for (i = periodoIni; i <= periodoFin; i++) {
                            if (i === periodoFin) {
                                dol = dolCalc;
                                prct = prctCalc;
                                cant = cantCalc;
                            }
                            dolCalc -= dol;
                            prctCalc -= prct;
                            cantCalc -= cant;
                            $(".dol.mes" + i + ".rubro" + rubro).text(number_format(dol, 2, ".", ",")).data("val", dol);
                            $(".prct.mes" + i + ".rubro" + rubro).text(number_format(prct, 2, ".", ",")).data("val", prct);
                            $(".fis.mes" + i + ".rubro" + rubro).text(number_format(cant, 2, ".", ",")).data("val", cant);

                            dataAjax += "&crono=" + rubro + "_" + i + "_" + dol + "_" + prct + "_" + cant + "&";
                        }
                    }
                    dataAjax += "&cont=${contrato.id}";
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'saveCronoNuevo_ajax')}",
                        data    : dataAjax,
                        success : function (msg) {
                            var parts = msg.split("_");
                            if (parts[0] === "OK") {
                                parts = parts[1].split(";");
                                for (i = 0; i < parts.length; i++) {
                                    var p = parts[i].split(":");
                                    var mes = p[0];
                                    var id = p[1];
                                    $(".dol.mes" + mes + ".rubro" + rubro).data("id", id);
                                    $(".prct.mes" + mes + ".rubro" + rubro).data("id", id);
                                    $(".fis.mes" + mes + ".rubro" + rubro).data("id", id);
                                }
                                updateTotales();
                                $("#modal-cronograma").dialog("close");
                            } else {
                            }
                            $(".rowSelected").removeClass("rowSelected");
                        }
                    });
                }
                return false;
            });

            $btnCancel.click(function () {
                $("#modal-cronograma").dialog("close");
            });

            $("#modalTitle").html("Registro del Cronograma");

            $("#modalFooter").html("").append($btnCancel).append($btnOk);
            $("#modal-cronograma").dialog("open");
        }

        <g:if test="${contrato.estado!='R'}">
        $(".mes").dblclick(function () {

            var $sel = getSelected();
            var $celda = $(this);

            if ($sel.length === 1) {
                clickOne($celda);
            } else {
                if ($sel.length > 1) {
                    var mes = $celda.data("mes");
                    $("#rd_cant,#tf_cant,#rd_precio,#tf_precio").attr("disabled", "true");
                    $("#periodosDesde").val(mes);
                    $("#periodosHasta").val("${meses}");
                    $("#rd_prct").attr("checked", true);

                    $("#frmRubro").hide();
                    $("#divRubro").show();

                    $("#tf_prct").data({
                        max   : 100,
                        total : 100
                    }).val("");

                    $("#spCant").text("");
                    $("#spPrecio").text("");
                    $("#spPrct").text(100);

                    var $btnCancel = $('<a href="#" data-dismiss="modal" class="btn btn-info" id="btnCerrar"><i class="fa fa-times"></i> Cerrar</a>');
                    var $btnOk = $('<a href="#" class="btn btn-success"><i class="fa fa-save"></i> Aceptar</a>');

                    $btnOk.click(function () {
                        if (validar2()) {
                            $btnOk.replaceWith(spinner);

                            var dataAjax = "";

                            var periodoIni = parseInt($("#periodosDesde").val());
                            var periodoFin = parseInt($("#periodosHasta").val());

                            var prct = $("#tf_prct").data("val");

                            $sel.each(function () {
                                var $tr = $(this);

                                var rubro = $tr.data("id");

                                var cantTot = $tr.find(".cantidad").data("valor");
                                var precTot = $tr.find(".subtotal").data("valor");

                                var cantCal = cantTot * (prct / 100);
                                var precCal = precTot * (prct / 100);

                                if (periodoIni === periodoFin) {
                                    $(".dol.mes" + periodoIni + ".rubro" + rubro).text(number_format(precCal, 2, ".", ",")).data("val", precCal);
                                    $(".prct.mes" + periodoIni + ".rubro" + rubro).text(number_format(prct, 2, ".", ",")).data("val", prct);
                                    $(".fis.mes" + periodoIni + ".rubro" + rubro).text(number_format(cantCal, 2, ".", ",")).data("val", cantCal);
                                    dataAjax += "&crono=" + rubro + "_" + periodoIni + "_" + precCal + "_" + prct + "_" + cantCal;
                                } else {
                                    var meses = periodoFin - periodoIni + 1;

                                    var pr = Math.round((prct / meses) * 100) / 100;
                                    var cn = Math.round((cantCal / meses) * 100) / 100;
                                    var pe = Math.round((precCal / meses) * 100) / 100;

                                    var prRest = prct, cnRest = cantCal, peRest = precCal;

                                    for (var i = periodoIni; i <= periodoFin; i++) {
                                        if (i === periodoFin) {
                                            pr = prRest;
                                            cn = cnRest;
                                            pe = peRest;
                                        }
                                        prRest -= pr;
                                        cnRest -= cn;
                                        peRest -= pe;

                                        $(".dol.mes" + i + ".rubro" + rubro).text(number_format(pe, 2, ".", ",")).data("val", pe);
                                        $(".prct.mes" + i + ".rubro" + rubro).text(number_format(pr, 2, ".", ",")).data("val", pr);
                                        $(".fis.mes" + i + ".rubro" + rubro).text(number_format(cn, 2, ".", ",")).data("val", cn);

                                        dataAjax += "&crono=" + rubro + "_" + i + "_" + pe + "_" + pr + "_" + cn + "&";
                                    }
                                }
                            });
                            dataAjax += "&cont=${contrato.id}";
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'saveCronoNuevo_ajax')}",
                                data    : dataAjax,
                                success : function (msg) {
                                    var parts = msg.split("_");
                                    if (parts[0] === "OK") {
                                        parts = parts[1].split(";");
                                        for (var i = 0; i < parts.length; i++) {
                                            var p = parts[i].split(":");
                                            var mes = p[0];
                                            var id = p[1];
                                            var rubro = p[2];
                                            $(".dol.mes" + mes + ".rubro" + rubro).data("id", id);
                                            $(".prct.mes" + mes + ".rubro" + rubro).data("id", id);
                                            $(".fis.mes" + mes + ".rubro" + rubro).data("id", id);
                                        }
                                        updateTotales();
                                        $("#modal-cronograma").dialog("close");

                                        $(".rowSelected").removeClass("rowSelected");
                                    } else {
                                    }
                                }
                            });
                        } //if validar
                    });

                    $btnCancel.click(function () {
                        $("#modal-cronograma").dialog("close");
                    });

                    $("#modalTitle").html("Registro del Cronograma");
                    $("#modalFooter").html("").append($btnCancel).append($btnOk);
                    $("#modal-cronograma").dialog("open");
                }
            }

        }); //fin dblclick

        $("#btnDeleteRubro").click(function () {
            bootbox.confirm({
                title: "Eliminar Cronograma",
                message: "Se eliminarán los rubros marcados, desea continuar?<br/>Los datos serán eliminados inmediatamente, y no se puede deshacer.",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-trash"></i> Borrar',
                        className: 'btn-danger'
                    }
                },
                callback: function (result) {
                    if(result){
                        var g = cargarLoader("Borrando...");
                        $(".item_row.rowSelected").each(function () {
                            var id = $(this).data("id");
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'deleteRubroNuevo_ajax')}",
                                data    : {
                                    id : id
                                },
                                success : function (msg) {
                                    g.modal("hide");
                                    $(".mes.rubro" + id).text("").data("val", 0);
                                    quitarSeleccion();
                                    updateTotales();
                                }
                            });
                        });
                    }
                }
            });
        });

        $("#btnDeleteCronograma").click(function () {
            bootbox.confirm({
                title: "Eliminar Cronograma",
                message: "Se eliminará todo el cronograma, desea continuar? <br/> Los datos serán eliminados inmediatamente, y no se puede deshacer.",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-trash"></i> Borrar',
                        className: 'btn-danger'
                    }
                },
                callback: function (result) {
                    if(result){
                        var g = cargarLoader("Borrando...");
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(action:'deleteCronogramaNuevo_ajax')}",
                            data    : {
                                obra : ${obra.id}
                            },
                            success : function (msg) {
                                g.modal("hide");
                                $(".mes").text("").data("val", 0);
                                updateTotales();
                            }
                        });
                    }
                }
            });
        });
        </g:if>

        $("#btnReporte").click(function () {
            location.href = "${createLink(controller: 'reportes5', action:'reporteCronogramaNuevoPdf', id:contrato.id, params:[tipo:'contrato'])}";
            return false;
        });

        $("#btnGrafico").click(function () {
            var d = "obra=${obra.id}";
            d += "&sbpr=${subpre}";
            d +="&contrato=${contrato?.id}";
            location.href = "${createLink(action: 'graficos2')}?" + d;
            return false;
        });

    });
</script>

</body>
</html>